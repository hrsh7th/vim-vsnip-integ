"
" asyncomplete#sources#vsnip#get_source_options
"
function! asyncomplete#sources#vsnip#get_source_options(opts)
  let l:defaults = {
        \   'name': 'vsnip',
        \   'completor': function('asyncomplete#sources#vsnip#completor'),
        \   'whitelist': ['*']
        \ }
  return extend(l:defaults, a:opts)
endfunction

"
" asyncomplete#sources#vsnip#completor
"
function! asyncomplete#sources#vsnip#completor(opts, ctx)
  let l:before_line = getline('.')
  let l:idx = min([strlen(l:before_line), col('.') - 2])
  let l:idx = max([l:idx, 0])
  let l:before_line =  l:before_line[0 : l:idx]

  if len(matchstr(l:before_line, s:get_keyword_pattern() . '$')) < 1
    return
  endif

  let l:candidates = []

  for l:source in vsnip#source#find(&filetype)
    for l:snippet in l:source
      for l:prefix in l:snippet.prefix
        let l:candidate = {
              \   'word': l:prefix,
              \   'abbr': l:prefix,
              \   'kind': 'Snippet',
              \   'menu': l:snippet.label,
              \   'user_data': json_encode({
              \     'vsnip_integ': {
              \       'snippet': l:snippet.body
              \     }
              \   })
              \ }

        if has_key(l:snippet, 'description') && strlen(l:snippet.description) > 0
          let l:candidate.menu .= printf(': %s', l:snippet.description)
        endif

        call add(l:candidates, l:candidate)
      endfor
    endfor
  endfor

  call asyncomplete#complete(
        \   a:opts.name,
        \   a:ctx,
        \   a:ctx.col - strlen(matchstr(a:ctx.typed, '\k*$')),
        \   l:candidates
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

