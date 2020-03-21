"
" compete#source#vsnip#register
"
function! compete#source#vsnip#register() abort
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
  let l:candidates = []

  for l:source in vsnip#source#find(&filetype)
    for l:snippet in l:source
      for l:prefix in l:snippet.prefix
        let l:candidate = {
              \   'word': l:prefix,
              \   'abbr': l:prefix,
              \   'kind': join(['Snippet', l:snippet.label, l:snippet.description], ' '),
              \   'menu': '[v]',
              \   'dup': 1,
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

  call a:callback({
  \   'items': l:candidates
  \ })
endfunction

