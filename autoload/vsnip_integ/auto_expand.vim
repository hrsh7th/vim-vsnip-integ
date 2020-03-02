let s:context = {}

function! vsnip_integ#auto_expand#enable() abort
  augroup vsnip_integ#auto_expand
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

  if empty(l:user_data) || !has_key(l:user_data, 'vsnip_integ') || !has_key(l:user_data.vsnip_integ, 'snippet')
    return
  endif

  let s:context.curpos = getcurpos()
  let s:context.line = getline('.')
  let s:context.completed_item = copy(v:completed_item)
  let s:context.snippet = l:user_data.vsnip_integ.snippet
  call feedkeys(printf("\<C-r>=<SNR>%d_on_complete_done_after()\<CR>", s:SID()), 'n')
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

  call vsnip_integ#_#clear_inserted_text(l:curpos, l:line, l:completed_item)
  call vsnip#anonymous(join(l:snippet, "\n"))

  return ''
endfunction

"
" SID
"
function! s:SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun

