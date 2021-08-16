"
" vsnip_integ#integration#ddc#attach
"
let s:script = expand('<sfile>')

function! vsnip_integ#integration#ddc#attach() abort
  let g:loaded_ddc_vsnip = 1

  silent! call ddc#register_source({
  \   'name': 'vsnip',
  \   'path': printf('%s/denops/ddc/sources/vsnip.ts',
  \                  fnamemodify(s:script, ':h:h:h:h')),
  \ })
endfunction
