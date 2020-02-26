if exists('g:loaded_vsnip_integ')
  finish
endif
let g:loaded_vsnip_integ = v:true

let g:vsnip_integ_config = get(g:, 'vsnip_integ_config', {})

" snippet expansion integration.
let g:vsnip_integ_config.vim_lsp = get(g:vsnip_integ_config, 'vim_lsp', v:true)
let g:vsnip_integ_config.vim_lsc = get(g:vsnip_integ_config, 'vim_lsc', v:true)
let g:vsnip_integ_config.lamp = get(g:vsnip_integ_config, 'lamp', v:true)
let g:vsnip_integ_config.deoplete_lsp = get(g:vsnip_integ_config, 'deoplete_lsp', v:true)
let g:vsnip_integ_config.nvim_lsp = get(g:vsnip_integ_config, 'nvim_lsp', v:true)

call vsnip_integ#vim_lsp()
call vsnip_integ#vim_lsc()
call vsnip_integ#lamp()
call vsnip_integ#deoplete_lsp()
call vsnip_integ#nvim_lsp()

" snippet completion interation.
let g:vsnip_integ_config.asyncomplete = get(g:vsnip_integ_config, 'asyncomplete', v:true)
let g:vsnip_integ_config.deoplete = get(g:vsnip_integ_config, 'deoplete', v:true)
let g:vsnip_integ_config.mucomplete = get(g:vsnip_integ_config, 'mucomplete', v:true)

call vsnip_integ#asyncomplete()
call vsnip_integ#mucomplete()

" NOTE: Checking enabled of deoplete is in vsnip.py

