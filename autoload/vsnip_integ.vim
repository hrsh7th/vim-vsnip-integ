let s:context = {}

"
" context.completed_item ... v:completed_item
" context.completion_item ... CompletionItem
"
function! vsnip_integ#on_complete_done(context) abort
  let s:context = {}
  let s:context.curpos = getcurpos()
  let s:context.line = getline('.')
  let s:context.completed_item = a:context.completed_item
  let s:context.completion_item = a:context.completion_item
  call feedkeys("\<Plug>(vsnip_integ:on_complete_done_after)")
endfunction

"
" s:on_complete_done_after
"
inoremap <silent> <Plug>(vsnip_integ:on_complete_done_after) <C-r>=<SID>on_complete_done_after()<CR>
function! s:on_complete_done_after() abort
  " Check <BS> or <C-h>
  if strlen(getline('.')) < strlen(s:context.line)
    return ''
  endif

  let l:expand_text = vsnip_integ#_#get_expand_text(s:context.completed_item, s:context.completion_item)
  if strlen(l:expand_text) > 0
    call vsnip_integ#_#clear_inserted_text(s:context.curpos, s:context.line, s:context.completed_item, s:context.completion_item)
    call vsnip#anonymous(l:expand_text)
  endif
  return ''
endfunction

"
" --- TODO Organize public api ... ---
"

function! vsnip_integ#auto_expand() abort
  if g:vsnip_integ_config.auto_expand
    call vsnip_integ#auto_expand#enable()
  endif
endfunction

function! vsnip_integ#vim_lsp() abort
  if g:vsnip_integ_config.vim_lsp && s:exists('autoload/lsp.vim')
    call vsnip_integ#vim_lsp#enable()
  endif
endfunction

function! vsnip_integ#vim_lsc() abort
  if g:vsnip_integ_config.vim_lsc && s:exists('plugin/lsc.vim')
    call vsnip_integ#vim_lsc#enable()
  endif
endfunction

function! vsnip_integ#lamp() abort
  if g:vsnip_integ_config.lamp && s:exists('autoload/lamp.vim')
    call vsnip_integ#lamp#enable()
  endif
endfunction

function! vsnip_integ#deoplete_lsp() abort
  try
    if g:vsnip_integ_config.deoplete_lsp && has('nvim') && luaeval('require("deoplete").request_candidates ~= nil')
      call vsnip_integ#deoplete_lsp#enable()
    endif
  catch /.*/
  endtry
endfunction

function! vsnip_integ#nvim_lsp() abort
  if g:vsnip_integ_config.nvim_lsp && s:exists('lua/vim/lsp.lua')
    call vsnip_integ#nvim_lsp#enable()
  endif
endfunction

function! vsnip_integ#language_client_neovim() abort
  if g:vsnip_integ_config.language_client_neovim && s:exists('autoload/LanguageClient.vim')
    call vsnip_integ#language_client_neovim#enable()
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

function! vsnip_integ#compete() abort
  if g:vsnip_integ_config.compete && s:exists('autoload/compete.vim')
    call vsnip_integ#compete#enable()
  endif
endfunction

function! s:exists(filepath) abort
  return !empty(globpath(&runtimepath, a:filepath))
endfunction

