function! vsnip_integ#vim_lsp#enable() abort
  let g:lsp_get_supported_capabilities = [function('s:get_supported_capabilities')]
  let g:lsp_snippets_get_snippet = [function('s:get_snippet')]
  let g:lsp_snippets_expand_snippet = [function('s:expand_snippet')]
  let g:lsp_get_vim_completion_item = [function('s:get_vim_completion_item')]

  augroup vsnip_integ_vim_lsp
    autocmd!
    autocmd User lsp_complete_done call s:on_complete_done()
  augroup END
endfunction

"
" on_complete_done.
"
function! s:on_complete_done() abort
  let l:fn = {}
  let l:fn.line = getline('.')
  let l:fn.completed_item = v:completed_item
  function! l:fn.next_tick() abort
    echomsg string(self.completed_item)
    " parse user_data.
    let l:completion_item = {}
    try
      let l:completion_item = json_decode(self.completed_item.user_data).vsnip.item
    catch /.*/
    endtry
    if empty(l:completion_item)
      return
    endif

    " check snippet.
    let l:is_snippet = l:completion_item.insertTextFormat == 2
    if !l:is_snippet
      return
    endif

    " clear inserted text.
    call setline('.', self.line)

    echomsg 'aaaaaaaaaaaaa'
  endfunction
  call timer_start(0, { -> l:fn.next_tick() })
endfunction


"
" get_vim_completion_item.
"
function! s:get_vim_completion_item(item, ...) abort
  let l:completed_item = call('lsp#omni#default_get_vim_completion_item', [a:item] + a:000)

  " update user_data.
  let l:user_data = {}
  if has_key(l:completed_item, 'user_data') && type(l:completed_item.user_data) == type('')
    try
      let l:user_data = json_decode(l:completed_item.user_data) 
    catch /.*/
    endtry
  endif
  let l:user_data.vsnip = { 'item': a:item }

  let l:completed_item.user_data = json_encode(l:user_data)

  return l:completed_item
endfunction

"
" get_supported_capabilities.
"
function! s:get_supported_capabilities(server_info) abort
  let l:capabilities = lsp#default_get_supported_capabilities(a:server_info)

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

"
" get_snippet.
"
function! s:get_snippet(text) abort
  return a:text
endfunction

"
" expand_snippet.
"
function! s:expand_snippet(trigger, snippet) abort
  call vsnip#anonymous(a:snippet)
endfunction

