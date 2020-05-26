"
" vsnip_integ#integration#lamp#attach
"
function! vsnip_integ#integration#lamp#attach() abort
  call lamp#config('feature.completion.snippet.expand', { option ->
  \   vsnip#anonymous(option.body)
  \ })
endfunction

