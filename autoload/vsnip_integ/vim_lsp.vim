function! vsnip_integ#vim_lsp#enable() abort
  let g:lsp_get_supported_capabilities = [function('s:get_supported_capabilities')]
  let g:lsp_snippets_get_snippet = [function('s:get_snippet')]
  let g:lsp_snippets_expand_snippet = [function('s:expand_snippet')]
endfunction

function! s:get_supported_capabilities(server_info) abort
endfunction

function! s:get_snippet(text) abort
  return a:text
endfunction

function! s:expand_snippet(trigger, snippet) abort
  call vsnip#anonymous(a:snippet)
endfunction

