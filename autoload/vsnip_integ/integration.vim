let s:attached = v:false

"
" vsnip_integ#integration#attach
"
" TODO: improve initialization.
"
function! vsnip_integ#integration#attach() abort
  if s:attached
    return
  endif
  let s:attached = v:true

  for l:name in keys(vsnip_integ#detection#definition())
    try
      if vsnip_integ#detection#exists(l:name)
        call vsnip_integ#integration#{l:name}#attach()
      endif
    catch /.*/
      if g:vsnip_integ_debug
        echomsg string([v:exception, v:throwpoint])
      endif
    endtry
  endfor
endfunction

