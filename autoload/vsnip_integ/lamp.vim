function! vsnip_integ#lamp#enable() abort
  call lamp#config('feature.completion.snippet.expand', { option ->
        \   vsnip#anonymous(option.body)
        \ })
endfunction

