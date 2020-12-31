"
" vsnip_integ#integration#mucomplete#attach
"
function! vsnip_integ#integration#mucomplete#attach() abort
  call mucomplete#add_user_mapping('vsnip', "\<C-r>=vsnip_integ#integration#mucomplete#complete()\<CR>")
endfunction

"
" vsnip_integ#integration#mucomplete#complete
"
function! vsnip_integ#integration#mucomplete#complete() abort
  let l:before_line = getline('.')
  let l:idx = min([strlen(l:before_line), col('.') - 2])
  let l:idx = max([l:idx, 0])
  let l:before_line =  l:before_line[0 : l:idx]
  let l:keyword = matchstr(l:before_line, '\k\+$')

  if l:keyword == ''
    return ''
  endif

  let l:candidates = vsnip#get_complete_items(bufnr('%'))
  let l:match = map(l:candidates, { _, val -> (l:keyword == val["word"][0:strlen(l:keyword)-1]) ? val : ''})
  
  if !empty(l:candidates)
    call complete(col('.') - strlen(l:keyword), l:match)
  endif

  return ''
endfunction

