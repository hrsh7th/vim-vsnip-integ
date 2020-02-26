let s:enable_snippet_expansion = v:false

function! vsnip_integ#vim_lsp() abort
  if !s:enable_snippet_expansion
    if g:vsnip_integ_config.vim_lsp && s:exists('autoload/lsp.vim')
      call vsnip_integ#vim_lsp#enable()
      let s:enable_snippet_expansion = v:true
    endif
  endif
endfunction

function! vsnip_integ#vim_lsc() abort
  if !s:enable_snippet_expansion
    if g:vsnip_integ_config.vim_lsc && s:exists('plugin/lsc.vim')
      call vsnip_integ#vim_lsc#enable()
      let s:enable_snippet_expansion = v:true
    endif
  endif
endfunction

function! vsnip_integ#lamp() abort
  if !s:enable_snippet_expansion
    if g:vsnip_integ_config.lamp && s:exists('autoload/lamp.vim')
      call vsnip_integ#lamp#enable()
      let s:enable_snippet_expansion = v:true
    endif
  endif
endfunction

function! vsnip_integ#deoplete_lsp() abort
  if !s:enable_snippet_expansion
    try
      if g:vsnip_integ_config.deoplete_lsp && has('nvim') && luaeval('require("deoplete").request_candidates ~= nil')
        call vsnip_integ#deoplete_lsp#enable()
        let s:enable_snippet_expansion = v:true
      endif
    catch /.*/
    endtry
  endif
endfunction

function! vsnip_integ#nvim_lsp() abort
  if !s:enable_snippet_expansion
    if g:vsnip_integ_config.nvim_lsp && s:exists('lua/vim/lsp.lua')
      call vsnip_integ#nvim_lsp#enable()
      let s:enable_snippet_expansion = v:true
    endif
  endif
endfunction

function! vsnip_integ#asyncomplete() abort
  if g:vsnip_integ_config.asyncomplete && s:exists('autoload/asyncomplete.vim')
    call vsnip_integ#asyncomplete#enable()
  endif
endfunction

function! vsnip_integ#mucomplete() abort
  if g:vsnip_integ_config.mucomplete && s:exists('autoload/mucomplete.vim')
    call vsnip_integ#mucomplete#enable()
  endif
endfunction

function! s:exists(filepath) abort
  return !empty(globpath(&runtimepath, a:filepath))
endfunction

