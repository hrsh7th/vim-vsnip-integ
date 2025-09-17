"
" vsnip_integ#integration#vimlsp#attach
"
function! vsnip_integ#integration#vimlsp#attach() abort
  let g:lsp_text_edit_enabled = v:true

  " save existing value because it may be user-defined.
  let s:existing_capabilities_function = get(g:, lsp_get_supported_capabilities)
  let g:lsp_get_supported_capabilities = [function('s:get_supported_capabilities')]

  let g:lsp_snippet_expand = [{ option -> vsnip#anonymous(option.snippet) }]
endfunction

"
" get_supported_capabilities.
"
function! s:get_supported_capabilities(server_info) abort
  let l:capabilities = call(s:existing_capabilities_function[0], [a:server_info])

  if !has_key(l:capabilities, 'textDocument')
    let l:capabilities.textDocument = {}
  endif

  if !has_key(l:capabilities.textDocument, 'completion')
    let l:capabilities.textDocument.completion = {}
  endif

  if !has_key(l:capabilities.textDocument.completion, 'completionItem')
    let l:capabilities.textDocument.completion.completionItem = {}
  endif

  let l:capabilities.textDocument.completion.completionItem.snippetSupport = v:true

  return l:capabilities
endfunction

