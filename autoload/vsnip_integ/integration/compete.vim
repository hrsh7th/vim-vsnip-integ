"
" vsnip_integ#integration#compete#attach
"
function! vsnip_integ#integration#compete#attach() abort
  call compete#source#register({
  \   'name': 'vsnip',
  \   'complete': function('s:complete'),
  \   'priority': 10,
  \   'filetypes': ['*'],
  \ })
endfunction

"
" complete
"
function! s:complete(context, callback) abort
  call a:callback({
  \   'items': vsnip#get_complete_items(a:context.bufnr)
  \ })
endfunction

