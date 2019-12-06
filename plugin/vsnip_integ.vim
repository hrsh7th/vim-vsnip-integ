if exists('g:loaded_vsnip_integ')
  finish
endif
let g:loaded_vsnip_integ = v:true

call vsnip_integ#vim_lsp()
call vsnip_integ#lamp()

