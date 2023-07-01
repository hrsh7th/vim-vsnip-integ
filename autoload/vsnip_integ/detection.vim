let s:definition = {
\   'vimlsp': { -> exists('g:lsp_loaded') },
\   'lsc': { -> exists('g:loaded_lsc') },
\   'lcn': { -> exists('g:LanguageClient_serverCommands') },
\   'asyncomplete': { -> exists('g:asyncomplete_loaded') },
\   'mucomplete': { -> exists('g:loaded_mucomplete') },
\   'easycomplete': { -> exists('g:easycomplete_default_plugin_init') },
\   'yegappan_lsp': { -> s:runtimepath('autoload/lsp/lspserver.vim') },
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

