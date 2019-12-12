if exists('g:loaded_vsnip_integ')
  finish
endif
let g:loaded_vsnip_integ = v:true

function! s:initialize(timer_id) abort
  call vsnip_integ#vim_lsp()
  call vsnip_integ#vim_lsc()
  call vsnip_integ#lamp()
  call vsnip_integ#deoplete_lsp()
endfunction
call timer_start(0, function('s:initialize'))

