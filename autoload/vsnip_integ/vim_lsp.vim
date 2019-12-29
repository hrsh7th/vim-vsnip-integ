let s:context = {}

function! vsnip_integ#vim_lsp#enable() abort
  let g:lsp_text_edit_enabled = v:true
  let g:lsp_get_supported_capabilities = [function('s:get_supported_capabilities')]
  let g:lsp_get_vim_completion_item = [function('s:get_vim_completion_item')]

  augroup vsnip_integ#vim_lsp
    autocmd!
    autocmd User lsp_complete_done call s:on_complete_done()
  augroup END
endfunction

function! s:on_complete_done() abort
  " check v:completed_item
  if empty(v:completed_item)
    return
  endif

  try
    let l:user_data = json_decode(v:completed_item.user_data)
  catch /.*/
    let l:user_data = {}
  endtry
  if empty(l:user_data) || !has_key(l:user_data, 'vsnip')
    return
  endif

  let s:context.curpos = getcurpos()
  let s:context.line = getline('.')
  let s:context.completed_item = copy(v:completed_item)
  let s:context.server_name  = l:user_data.vsnip.server_name
  let s:context.completion_item = l:user_data.vsnip.item
  call feedkeys(printf("\<C-r>=<SNR>%d_on_complete_done_after()\<CR>", s:SID()), 'n')
endfunction

"
" on_complete_done.
"
function! s:on_complete_done_after() abort
  let l:curpos = s:context.curpos
  let l:line = s:context.line
  let l:completed_item = s:context.completed_item
  let l:server_name = s:context.server_name
  let l:completion_item = s:context.completion_item

  " <BS> or <C-h>
  if strlen(getline('.')) < strlen(l:line)
    return ''
  endif

  let l:completion_item = s:resolve_completion_item(l:server_name, l:completion_item)

  " textEdit or Snippet.
  let l:expand_text = s:get_expand_text(l:completed_item, l:completion_item)
  if strlen(l:expand_text) > 0
    call s:clear_inserted_text(l:curpos, l:line, l:completed_item, l:completion_item)
    call vsnip#anonymous(l:expand_text)
  endif

  " additionalTextEdits.
  if has_key(l:completion_item, 'additionalTextEdits')
    call vsnip#edits#text_edit#apply(bufnr('%'), l:completion_item.additionalTextEdits)
  endif

  return ''
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

  if empty(l:fn.response.result)
    return a:completion_item
  endif

  return l:fn.response.result
endfunction

"
" clear_inserted_text.
"
function! s:clear_inserted_text(curpos, line, completed_item, completion_item) abort
  " remove last inserted characters.
  call setline('.', a:line)

  " remove completed string.
  let l:range = {
        \   'start': {
        \     'line': a:curpos[1] - 1,
        \     'character': (a:curpos[2] + a:curpos[3]) - strlen(a:completed_item.word) - 1
        \   },
        \   'end': {
        \     'line': a:curpos[1] - 1,
        \     'character': (a:curpos[2] + a:curpos[3]) - 1
        \   }
        \ }

  if has_key(a:completion_item, 'textEdit')
    let l:range.start.character = min([
          \   l:range.start.character,
          \   a:completion_item.textEdit.range.start.character
          \ ])
    let l:range.end.character = max([
          \   l:range.end.character,
          \   a:completion_item.textEdit.range.end.character
          \ ])
  endif
  call vsnip#edits#text_edit#apply(bufnr('%'), [{
        \   'range': l:range,
        \   'newText': ''
        \ }])

  " move to complete start position.
  call cursor([l:range.start.line + 1, l:range.start.character + 1])
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

"
" SID
"
function! s:SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction

