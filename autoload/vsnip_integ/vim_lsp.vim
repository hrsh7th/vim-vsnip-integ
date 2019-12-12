function! vsnip_integ#vim_lsp#enable() abort
  let g:lsp_text_edit_enabled = v:true
  let g:lsp_get_supported_capabilities = [function('s:get_supported_capabilities')]
  let g:lsp_get_vim_completion_item = [function('s:get_vim_completion_item')]

  augroup vsnip_integ#vim_lsp
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
  function! l:fn.next_tick(lazyredraw) abort
    " parse user_data.
    let l:completion_item = {}
    try
      let l:user_data = json_decode(self.completed_item.user_data).vsnip
      let l:server_name = get(l:user_data, 'server_name', v:null)
      let l:completion_item = get(l:user_data, 'item', {})
    catch /.*/
    endtry
    if empty(l:completion_item)
      return
    endif
    let l:completion_item = s:resolve_completion_item(l:server_name, l:completion_item)

    " textEdit or snippet.
    let l:expand_text = s:get_expand_text(self.completed_item, l:completion_item)
    if strlen(l:expand_text) > 0
      call s:clear_inserted_text(self.line, self.completed_item, l:completion_item)
      call vsnip#anonymous(l:expand_text)
    endif

    " additionalTextEdits.
    if has_key(l:completion_item, 'additionalTextEdits')
      call vsnip#edits#text_edit#apply(bufnr('%'), l:completion_item.additionalTextEdits)
    endif

    let &lazyredraw = a:lazyredraw
  endfunction
  let l:lazyredraw = &lazyredraw
  let &lazyredraw = 1
  call timer_start(0, { -> l:fn.next_tick(l:lazyredraw) })
endfunction

"
" s:resolve_completion_item
"
function! s:resolve_completion_item(server_name, completion_item) abort
  if empty(a:server_name)
    return a:completion_item
  endif

  let l:capabilities = lsp#get_server_capabilities(a:server_name)
  if !has_key(l:capabilities, 'completionProvider')
        \ || !has_key(l:capabilities.completionProvider, 'resolveProvider')
    return a:completion_item
  endif

  let l:fn = {}
  let l:fn.response = {}
  function! l:fn.callback(data) abort
    let self.response = a:data['response']
  endfunction

  call lsp#send_request(a:server_name, {
        \   'method': 'completionItem/resolve',
        \   'params': a:completion_item,
        \   'sync': 1,
        \   'on_notification': function(l:fn.callback, [], l:fn)
        \ })

  " can not retrieve response.
  if empty(l:fn.response)
    return a:completion_item
  endif

  " response is error.
  if lsp#client#is_error(l:fn.response)
    return a:completion_item
  endif

  return l:fn.response.result
endfunction

"
" clear_inserted_text.
"
function! s:clear_inserted_text(line, completed_item, completion_item) abort
  let l:before_text = a:line[0 : col('.') - 3]
  let l:remove_start = strlen(l:before_text) - strlen(a:completed_item.word) - 1
  let l:remove_end = strlen(l:before_text)

  if has_key(a:completion_item, 'textEdit')
    let l:remove_start = min([l:remove_start, a:completion_item.textEdit.range.start.character])
    let l:remove_end = max([l:remove_end, a:completion_item.textEdit.range.end.character])
  endif

  let l:line = ''
  let l:line .= a:line[0 : l:remove_start]
  let l:line .= a:line[l:remove_end : - 1]

  call setline('.', l:line)
  call cursor('.', l:remove_start + 2)
endfunction

"
" get_expand_text.
"
function! s:get_expand_text(completed_item, completion_item) abort
  let l:text = a:completed_item.word
  if has_key(a:completion_item, 'textEdit')
    let l:text = a:completion_item.textEdit.newText
  elseif has_key(a:completion_item, 'insertText')
    let l:text = a:completion_item.insertText
  endif
  return l:text != a:completed_item.word ? l:text : ''
endfunction

"
" get_vim_completion_item.
"
function! s:get_vim_completion_item(item, ...) abort
  let l:completed_item = call('lsp#omni#default_get_vim_completion_item', [a:item] + a:000)

  " create override user_data.
  let l:user_data = {}
  let l:user_data.vsnip = {
        \   'server_name': get(a:000, 0, v:null),
        \   'item': a:item
        \ }

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

