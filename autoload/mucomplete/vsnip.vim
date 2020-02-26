function! mucomplete#vsnip#complete() abort
  let l:before_line = getline('.')
  let l:idx = min([strlen(l:before_line), col('.') - 2])
  let l:idx = max([l:idx, 0])
  let l:before_line =  l:before_line[0 : l:idx]
  let l:keyword = matchstr(l:before_line, '\k\+$')

  if l:keyword == ''
    return ''
  endif

  let l:candidates = []

  for l:source in vsnip#source#find(&filetype)
    for l:snippet in l:source
      for l:prefix in l:snippet.prefix
        if l:prefix !~# '^' . l:keyword
          continue
        endif

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

  if !empty(l:candidates)
    call complete(col('.') - strlen(l:keyword), l:candidates)
  endif

  return ''
endfunction

