let s:TextEdit = vital#vsnip#import('VS.LSP.TextEdit')

let s:stop = v:false

"
" CompleteDone context.
"
" When completed LSP item, context will have `completion_item` key.
" When completed snippet item, context will have `snippet` key.
"
let s:context = {
\   'done_line': '',
\   'done_pos': [],
\   'completed_item': v:null,
\   'snippet': '',
\   'completion_item': v:null,
\ }

inoremap <silent> <Plug>(vsnip_integ:on_complete_done_after) <C-r>=<SID>on_complete_done_after()<CR>

"
" vsnip_integ#on_complete_done_for_lsp
"
" Deprecated.
"
function! vsnip_integ#on_complete_done_for_lsp(context) abort
  if s:stop | return | endif
  let s:stop = v:true
  call timer_start(0, { -> execute('let s:stop = v:false') })

  let s:context = {
  \   'done_line': getline('.'),
  \   'done_pos': getcurpos(),
  \   'completed_item': a:context.completed_item,
  \   'completion_item': a:context.completion_item,
  \   'apply_additional_text_edits': v:false,
  \ }
  call feedkeys("\<Plug>(vsnip_integ:on_complete_done_after)")
endfunction

"
" vsnip_integ#on_complete_done
"
function! vsnip_integ#on_complete_done(completed_item) abort
  if s:stop | return | endif
  let s:stop = v:true
  call timer_start(0, { -> execute('let s:stop = v:false') })

  let l:context = s:extract_user_data(a:completed_item)
  if !empty(l:context)
    let s:context = extend(l:context, {
    \   'done_line': getline('.'),
    \   'done_pos': getcurpos(),
    \   'completed_item': a:completed_item,
    \   'apply_additional_text_edits': v:true,
    \ })
    call feedkeys("\<Plug>(vsnip_integ:on_complete_done_after)")
  endif
endfunction

"
" on_complete_done_after
"
function! s:on_complete_done_after() abort
  " Fix lnum for external additionalTextEdits
  let s:context.done_pos[1] = getcurpos()[1]

  " Check <BS> or <C-h>
  if strlen(getline('.')) < strlen(s:context.done_line)
    return ''
  endif

  " Remove completed text
  let l:expand_text = s:get_expand_text(s:context)
  if strlen(l:expand_text) > 0
    call s:remove_completed_text(s:context)
  endif

  " additionalTextEdits
  if get(s:context, 'apply_additional_text_edits', v:false)
    call s:apply_additional_text_edits(s:context)
  endif

  " Expand snippet.
  if strlen(l:expand_text) > 0
    call vsnip#anonymous(l:expand_text)
  endif

  return ''
endfunction

"
" get_expand_text
"
function! s:get_expand_text(context) abort
  let l:done_line = a:context.done_line
  let l:done_pos = a:context.done_pos
  let l:completed_item = a:context.completed_item
  let l:snippet = get(a:context, 'snippet', v:null)
  let l:completion_item = get(a:context, 'completion_item', v:null)

  " Snippet body.
  if l:snippet isnot# v:null
    return type(l:snippet) == type([]) ? join(l:snippet, "\n") : l:snippet
  endif

  " LSP CompletionItem.
  if l:completion_item isnot# v:null
    let l:word = l:completed_item.word
    if has_key(l:completion_item, 'textEdit') && type(l:completion_item.textEdit) == type({})
      let l:word = l:completion_item.textEdit.newText
    elseif has_key(l:completion_item, 'insertText') && type(l:completion_item.insertText) == type('')
      let l:word = l:completion_item.insertText
    endif
    if get(l:completion_item, 'insertTextFormat', 1) == 2 || l:word !=# l:completed_item.word
      return l:word
    endif
  endif

  return ''
endfunction

"
" apply_additional_text_edits
"
function! s:apply_additional_text_edits(context) abort
  if type(get(a:context, 'completion_item', v:null)) != type({})
    return
  endif
  if type(get(a:context.completion_item, 'additionalTextEdits', v:null)) != type([])
    return
  endif
  if len(a:context.completion_item.additionalTextEdits) == 0
    return
  endif

  " Special ignore case (Some lsp clients will expand additionalTextEdits by itself).
  for l:id in ['lcn', 'vimlsp', 'lamp', 'completion-nvim']
    if index(s:context.sources, l:id) >= 0 && vsnip_integ#detection#exists(l:id)
      return
    endif
  endfor

  call s:TextEdit.apply(bufnr('%'), a:context.completion_item.additionalTextEdits)
endfunction

"
" remove_completed_text
"
function! s:remove_completed_text(context) abort
  let l:done_line = a:context.done_line
  let l:done_pos = a:context.done_pos
  let l:completed_item = a:context.completed_item
  let l:completion_item = get(a:context, 'completion_item', v:null)

  " Remove trigger character.
  call setline('.', l:done_line)

  " Create range to remove.
  let l:range = {
        \   'start': {
        \     'line': l:done_pos[1] - 1,
        \     'character': (l:done_pos[2] + l:done_pos[3]) - strchars(l:completed_item.word) - 1
        \   },
        \   'end': {
        \     'line': l:done_pos[1] - 1,
        \     'character': (l:done_pos[2] + l:done_pos[3]) - 1
        \   }
        \ }

  " Support `textEdit` range for LSP CompletionItem.
  " TODO: Need `complete_position` support.
  if !empty(l:completion_item) && has_key(l:completion_item, 'textEdit') && type(l:completion_item.textEdit) == type({})
    let l:range.start.character = l:completion_item.textEdit.range.start.character
    let l:range.end.character = max([l:range.end.character, l:completion_item.textEdit.range.end.character])
  endif

  " Remove range.
  call s:TextEdit.apply(bufnr('%'), [{
        \   'range': l:range,
        \   'newText': ''
        \ }])
  call cursor([l:range.start.line + 1, l:range.start.character + 1])
endfunction

"
" extract_user_data
"
function! s:extract_user_data(completed_item) abort
  try
    " Has no `user_data`.
    if !has_key(a:completed_item, 'user_data')
      return {}
    endif

    " Decode user_data.
    let l:user_data = a:completed_item.user_data
    if type(l:user_data) == type('')
      let l:user_data = json_decode(l:user_data)
    endif

    " Support dict only.
    if type(l:user_data) != type({})
      return {}
    endif

    " deoplete-lsp, LanguageClient-neovim
    if s:has_key(l:user_data, 'lspitem')
      return {
      \   'sources': ['deoplete-lsp', 'lcn'],
      \   'completion_item': l:user_data.lspitem
      \ }
    endif

    " neovim built-in
    if s:has_key(l:user_data, 'nvim') && s:has_key(l:user_data.nvim, 'lsp') && s:has_key(l:user_data.nvim.lsp, 'completion_item')
      return {
      \   'sources': ['nvim', 'completion-nvim'],
      \   'completion_item': l:user_data.nvim.lsp.completion_item
      \ }
    endif

    " neovim built-in
    if s:has_key(l:user_data, 'lsp') && s:has_key(l:user_data.lsp, 'completion_item')
      return {
      \   'sources': ['nvim', 'completion-nvim'],
      \   'completion_item': l:user_data.lsp.completion_item
      \ }
    endif

    " vim-lsc
    if s:has_key(l:user_data, 'snippet') && s:has_key(l:user_data, 'snippet_trigger')
      return {
      \   'sources': ['lsc'],
      \   'snippet': l:user_data.snippet
      \ }
    endif

    " vsnip
    if s:has_key(l:user_data, 'vsnip')
      return {
      \   'sources': ['vsnip'],
      \   'snippet': join(l:user_data.vsnip.snippet, "\n")
      \ }
    endif
  catch /.*/
    if g:vsnip_integ_debug
      echomsg string([v:exception, v:throwpoint])
    endif
  endtry

  return {}
endfunction

"
" has_key
"
function! s:has_key(maybe_dict, key) abort
  if type(a:maybe_dict) != type({})
    return v:false
  endif
  return has_key(a:maybe_dict, a:key)
endfunction

