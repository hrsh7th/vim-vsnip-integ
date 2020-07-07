if exists('g:loaded_vsnip_integ')
  finish
endif
let g:loaded_vsnip_integ = v:true

let g:vsnip_integ_debug = get(g:, 'vsnip_integ_debug', v:false)

augroup vsnip_integ
  autocmd!
  autocmd CompleteDone * call vsnip_integ#on_complete_done(v:completed_item)
augroup END

