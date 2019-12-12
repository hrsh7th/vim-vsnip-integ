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

  let l:fn = {}
  let l:fn.line = getline('.')
  let l:fn.completed_item = v:completed_item
  let l:fn.snippet = l:user_data.snippet
  function! l:fn.next_tick() abort
    call s:clear_inserted_text(self.line, self.completed_item)
    call vsnip#anonymous(self.snippet)
  endfunction
  call timer_start(0, { -> l:fn.next_tick() })
endfunction

"
" s:clear_inserted_text
"
function! s:clear_inserted_text(line, completed_item) abort
  let l:before_text = a:line[0 : col('.') - 3]
  let l:remove_start = strlen(l:before_text) - strlen(a:completed_item.word) - 1
  let l:remove_end = strlen(l:before_text)

  let l:line = ''
  let l:line .= a:line[0 : l:remove_start]
  let l:line .= a:line[l:remove_end : - 1]

  call setline('.', l:line)
  call cursor('.', l:remove_start + 2)
endfunction

