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
  return vsnip_integ#_#on_complete_done_after(
  \   s:context.curpos,
  \   s:context.line,
  \   s:context.completed_item,
  \   s:context.completion_item
  \ )
endfunction

"
" SID
"
function! s:SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun

