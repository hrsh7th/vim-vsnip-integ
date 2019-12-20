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
  let l:candidates = []

  for l:source in vsnip#source#find(&filetype)
    for l:snippet in l:source
      for l:prefix in l:snippet.prefix
        let l:candidate = {
              \   'word': l:prefix,
              \   'abbr': l:prefix,
              \   'kind': 'Snippet',
              \   'menu': l:snippet.label
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

