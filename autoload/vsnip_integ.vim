function! vsnip_integ#vim_lsp() abort
  augroup vsnip_integ#vim_lsp
    autocmd!
    autocmd User lsp_setup call vsnip_integ#vim_lsp#enable()
  augroup END
endfunction

function! vsnip_integ#lamp() abort
  augroup vsnip_integ#lamp
    autocmd!
    autocmd User lamp#initialized call vsnip_integ#lamp#enable()
  augroup END
endfunction
