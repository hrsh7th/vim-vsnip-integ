function! vsnip_integ#mucomplete#enable() abort
  call mucomplete#add_user_mapping('vsnip', "\<C-r>=mucomplete#vsnip#complete()\<CR>")
endfunction

