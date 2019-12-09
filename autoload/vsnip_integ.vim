function! vsnip_integ#vim_lsp() abort
  if exists('g:lsp_loaded')
    call vsnip_integ#vim_lsp#enable()
  endif
endfunction

function! vsnip_integ#vim_lsc() abort
  if exists('g:loaded_lsc')
    call vsnip_integ#vim_lsc#enable()
  endif
endfunction

function! vsnip_integ#lamp() abort
  if exists('g:loaded_lamp')
    call vsnip_integ#lamp#enable()
  endif
endfunction

