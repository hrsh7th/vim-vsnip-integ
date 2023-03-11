function! vsnip_integ#integration#easycomplete#attach() abort
  call easycomplete#RegisterSource({
        \ 'name': 'vsnip',
        \ 'whitelist': ['*'],
        \ 'completor': function('s:completor'),
        \ })
endfunction

"
" completor
"
function! s:completor(opt, ctx) abort
  if index(['.', '/', ':'], a:ctx['char']) >= 0
    call easycomplete#complete(a:opt['name'], a:ctx, a:ctx['startcol'], [])
    return v:true
  endif

  let l:typing = a:ctx['typing']
  if strlen(l:typing) == 0
    call easycomplete#complete(a:opt['name'], a:ctx, a:ctx['startcol'], [])
    return v:true
  endif

  if len(matchstr(a:ctx['line'], s:get_keyword_pattern() . '$')) < 1
    call easycomplete#complete(a:opt['name'], a:ctx, a:ctx['startcol'], [])
    return v:true
  endif

  call easycomplete#util#AsyncRun(
        \ function('s:complete_handler'),
        \ [l:typing, a:opt['name'], a:ctx, a:ctx['startcol']],
        \ 1)
  return v:true
endfunction

let s:kindflag_snip = get(g:, 'easycomplete_kindflag_snip', 's')
let s:menuflag_snip = get(g:, 'easycomplete_menuflag_snip', '[S]')

function! s:complete_handler(typing, name, ctx, startcol) abort
  let suggestions = vsnip#get_complete_items(a:ctx['bufnr'])
  for snippet in suggestions
    let menu = substitute(snippet.menu, '^\[.*\] ', '', '')
    call extend(snippet, {
          \ 'abbr': snippet.abbr . '~',
          \ 'kind': s:kindflag_snip,
          \ 'menu': s:menuflag_snip . ' ' . menu,
          \ 'info': ['Snippet: ' . menu, '-----'] + json_decode(snippet.user_data).vsnip.snippet,
          \ })
  endfor
  call easycomplete#complete(a:name, a:ctx, a:startcol, suggestions)
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
