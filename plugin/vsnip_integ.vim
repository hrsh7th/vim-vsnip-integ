if exists('g:loaded_vsnip_integ')
  finish
endif
let g:loaded_vsnip_integ = v:true

let g:vsnip_integ_debug = get(g:, 'vsnip_integ_debug', v:false)

augroup vsnip_integ
  autocmd!
  autocmd CompleteDone * call vsnip_integ#on_complete_done(v:completed_item)
  autocmd VimEnter * call vsnip_integ#integration#attach()
augroup END

inoremap <silent> <Plug>(vsnip_integ_skip_complete_done) <C-r>=vsnip_integ#skip_complete_done()<CR>

