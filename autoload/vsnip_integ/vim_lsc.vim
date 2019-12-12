let s:context = {}

function! vsnip_integ#vim_lsc#enable() abort
  let g:lsc_enable_snippet_support = v:true
  augroup vsnip_integ#vim_lsc
    autocmd!
    autocmd CompleteDone * call s:on_complete_done()
  augroup END
endfunction

"
" on_complete_done.
"
function! s:on_complete_done() abort
  if empty(v:completed_item)
    return
  endif

  try
    let l:user_data = json_decode(v:completed_item.user_data)
  catch /.*/
    let l:user_data = {}
  endtry

  if empty(l:user_data) || !has_key(l:user_data, 'snippet_trigger') || !has_key(l:user_data, 'snippet')
    return
  endif

  let s:context.curpos = getcurpos()
  let s:context.line = getline('.')
  let s:context.completed_item = copy(v:completed_item)
  let s:context.snippet = l:user_data.snippet
  call feedkeys(printf("\<C-r>=<SNR>%d_on_complete_done_after()\<CR>", s:SID()), 'nt')
endfunction

"
" on_complete_done_after
"
function! s:on_complete_done_after() abort
  let l:curpos = s:context.curpos
  let l:line = s:context.line
  let l:completed_item = s:context.completed_item
  let l:snippet = s:context.snippet

  " <BS> or <C-h>
  if strlen(getline('.')) < strlen(l:line)
    return ''
  endif

  call s:clear_inserted_text(l:curpos, l:line, l:completed_item)
  call vsnip#anonymous(l:snippet)

  return ''
endfunction

"
" s:clear_inserted_text
"
function! s:clear_inserted_text(curpos, line, completed_item) abort
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

  call vsnip#edits#text_edit#apply(bufnr('%'), [{
        \   'range': l:range,
        \   'newText': ''
        \ }])

  " move to complete start position.
  call cursor([l:range.start.line + 1, l:range.start.character + 1])
endfunction

"
" SID
"
function! s:SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun

