if exists('g:loaded_vsnip_integ')
  finish
endif
let g:loaded_vsnip_integ = v:true

let g:vsnip_integ_debug = get(g:, 'vsnip_integ_debug', v:false)
let g:vsnip_integ_confirm_behavior = get(g:, 'vsnip_integ_confirm_behavior', 'insert')

augroup vsnip_integ
  autocmd!
  autocmd User vsnip#expand call vsnip_integ#skip_complete_done_after()
  if has('#CompleteDonePre')
    autocmd CompleteDonePre * if complete_info(['mode']).mode !=? '' | call vsnip_integ#on_complete_done(v:completed_item) | endif
  else
    autocmd CompleteDone * call vsnip_integ#on_complete_done(v:completed_item)
  endif
augroup END

