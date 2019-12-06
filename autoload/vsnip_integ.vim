function! vsnip_integ#vim_lsp() abort
  augroup vsnip_integ#vim_lsp
    autocmd!
    autocmd User lsp_setup call vsnip_integ#vim_lsp#enable()
  augroup END
endfunction

