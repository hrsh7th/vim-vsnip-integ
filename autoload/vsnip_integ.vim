function! vsnip_integ#vim_lsp() abort
  if !exists('g:lsp_loaded')
    return
  endif
  call vsnip_integ#vim_lsp#enable()
endfunction
