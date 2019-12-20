function! vsnip_integ#asyncomplete#enable() abort
  call asyncomplete#register_source(
        \   asyncomplete#sources#vsnip#get_source_options({
        \     'name': 'vsnip',
        \     'whitelist': ['*'],
        \     'completor': function('asyncomplete#sources#vsnip#completor'),
        \   })
        \ )
endfunction

