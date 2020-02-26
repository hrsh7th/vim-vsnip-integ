let s:TextEdit = vital#vsnip#import('VS.LSP.TextEdit')

let s:context = {}

function! vsnip_integ#deoplete_lsp#enable() abort
  augroup vsnip_integ#deoplete_lsp
    autocmd!
    autocmd CompleteDone * call s:on_complete_done()
  augroup END
endfunction

"
" on_complete_done
"
function! s:on_complete_done() abort
  " check v:completed_item
  if empty(v:completed_item)
    return
  endif

  " check user_data.
  try
    let l:user_data = json_decode(v:completed_item.user_data)
  catch /.*/
    let l:user_data = {}
  endtry
  if empty(l:user_data) || !has_key(l:user_data, 'lspitem')
    return
  endif

  let s:context.curpos = getcurpos()
  let s:context.line = getline('.')
  let s:context.completed_item = copy(v:completed_item)
  let s:context.completion_item = l:user_data.lspitem
  call feedkeys(printf("\<C-r>=<SNR>%d_on_complete_done_after()\<CR>", s:SID()), 'n')
endfunction

"
" on_complete_done_after
"
function! s:on_complete_done_after() abort
  let l:curpos = s:context.curpos
  let l:line = s:context.line
  let l:completed_item = s:context.completed_item
  let l:completion_item = s:context.completion_item

  " Check <BS> or <C-h>
  if strlen(getline('.')) < strlen(l:line)
    return ''
  endif

  let l:expand_text = s:get_expand_text(l:completed_item, l:completion_item)
  if strlen(l:expand_text) > 0
    call s:clear_inserted_text(l:curpos, l:line, l:completed_item, l:completion_item)
  endif

  if has_key(l:completion_item, 'additionalTextEdits')
    call s:TextEdit.apply(bufnr('%'), l:completion_item.additionalTextEdits)
  endif

  if strlen(l:expand_text) > 0
    call vsnip#anonymous(l:expand_text)
  endif

  return ''
endfunction

"
" clear_inserted_text
"
function! s:clear_inserted_text(curpos, line, completed_item, completion_item) abort
  " remove last inserted characters.
  call setline('.', a:line)

  " remove completed string.
  let l:range = {
        \   'start': {
        \     'line': a:curpos[1] - 1,
        \     'character': (a:curpos[2] + a:curpos[3]) - strlen(a:completed_item.word) - 1
        \   },
        \   'end': {
        \     'line': a:curpos[1] - 1,
        \     'character': (a:curpos[2] + a:curpos[3]) - 1
        \   }
        \ }
  if has_key(a:completion_item, 'textEdit')
    let l:range.start.character = min([
          \   l:range.start.character,
          \   a:completion_item.textEdit.range.start.character
          \ ])
    let l:range.end.character = max([
          \   l:range.end.character,
          \   a:completion_item.textEdit.range.end.character
          \ ])
  endif
  call s:TextEdit.apply(bufnr('%'), [{
        \   'range': l:range,
        \   'newText': ''
        \ }])

  " move to complete start position.
  call cursor([l:range.start.line + 1, l:range.start.character + 1])
endfunction

"
" get_expand_text
"
function! s:get_expand_text(completed_item, completion_item) abort
  let l:text = a:completed_item.word
  if has_key(a:completion_item, 'textEdit')
    let l:text = a:completion_item.textEdit.newText
  elseif has_key(a:completion_item, 'insertText')
    let l:text = a:completion_item.insertText
  endif
  return l:text != a:completed_item.word ? l:text : ''
endfunction

"
" SID
"
function! s:SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun

