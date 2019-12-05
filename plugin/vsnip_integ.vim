if exists('g:loaded_vsnip_integ')
  finish
endif
let g:loaded_vsnip_integ = v:true

function! s:on_next_tick()
  if exists('g:loaded_vsnip')
    call vsnip_integ#vim_lsp()
  endif
endfunction

call timer_start(0, { -> s:on_next_tick() })

