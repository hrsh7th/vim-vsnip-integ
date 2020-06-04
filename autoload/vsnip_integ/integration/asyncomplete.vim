function! vsnip_integ#integration#asyncomplete#attach() abort
  call asyncomplete#register_source(
  \   s:get_source_option({
  \     'name': 'vsnip',
  \     'whitelist': ['*'],
  \     'completor': function('s:completor'),
  \   })
  \ )
endfunction

"
" get_source_option
"
function! s:get_source_option(opts) abort
  let l:defaults = {
  \   'name': 'vsnip',
  \   'completor': function('s:completor'),
  \   'whitelist': ['*']
  \ }
  return extend(l:defaults, a:opts)
endfunction

"
" completor
"
function! s:completor(opts, ctx) abort
  let l:before_line = getline('.')
  let l:idx = min([strlen(l:before_line), col('.') - 2])
  let l:idx = max([l:idx, 0])
  let l:before_line =  l:before_line[0 : l:idx]

  if len(matchstr(l:before_line, s:get_keyword_pattern() . '$')) < 1
    return
  endif


  call asyncomplete#complete(
  \   a:opts.name,
  \   a:ctx,
  \   a:ctx.col - strlen(matchstr(a:ctx.typed, '\k*$')),
  \   vsnip#get_complete_items(bufnr('%'))
  \ )
endfunction

"
" get_keyword_pattern
"
function! s:get_keyword_pattern() abort
  let l:keywords = split(&iskeyword, ',')
  let l:keywords = filter(l:keywords, { _, k -> match(k, '\d\+-\d\+') == -1 })
  let l:keywords = filter(l:keywords, { _, k -> k !=# '@' })
  let l:pattern = '\%(' . join(map(l:keywords, { _, v -> '\V' . escape(v, '\') . '\m' }), '\|') . '\|\w\)*'
  return l:pattern
endfunction

