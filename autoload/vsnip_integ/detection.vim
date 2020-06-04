let s:definition = {
\   'vimlsp': { -> exists('g:lsp_loaded') },
\   'nvimlsp': { -> s:runtimepath('lua/vim/lsp.lua') },
\   'lsc': { -> exists('g:loaded_lsc') },
\   'lcn': { -> exists('g:LanguageClient_serverCommands') },
\   'lamp': { -> exists('g:loaded_lamp') },
\   'asyncomplete': { -> exists('g:asyncomplete_loaded') },
\   'mucomplete': { -> exists('g:loaded_mucomplete') },
\   'compete': { -> exists('g:loaded_compete') },
\   'deoplete-lsp': { -> s:runtimepath('lua/deoplete.lua') },
\   'completion-nvim': { -> exists('g:loaded_completion') },
\ }

let s:cache = {}

"
" vsnip_integ#detection#definition
"
function! vsnip_integ#detection#definition() abort
  return copy(s:definition)
endfunction

"
" vsnip_integ#detection#exists
"
function! vsnip_integ#detection#exists(id) abort
  if !has_key(s:cache, a:id)
    let s:cache[a:id] = s:definition[a:id]()
  endif
  return s:cache[a:id]
endfunction

"
" runtimepath
"
function! s:runtimepath(path) abort
  return !empty(globpath(&runtimepath, a:path))
endfunction

