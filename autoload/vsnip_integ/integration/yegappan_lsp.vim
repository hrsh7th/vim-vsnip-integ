"
" vsnip_integ#integration#yegappan_lsp#attach
"
function! vsnip_integ#integration#yegappan_lsp#attach() abort
  call LspOptionsSet({ 'snippetSupport': v:true })
endfunction

