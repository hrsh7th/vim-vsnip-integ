let s:TextEdit = vital#vsnip#import('VS.LSP.TextEdit')

"
" vsnip_integ#_#on_complete_done_after
"
function! vsnip_integ#_#on_complete_done_after(curpos, line, completed_item, completion_item) abort
  " Check <BS> or <C-h>
  if strlen(getline('.')) < strlen(a:line)
    return ''
  endif

  let l:expand_text = vsnip_integ#_#get_expand_text(a:completed_item, a:completion_item)
  if strlen(l:expand_text) > 0
    call vsnip_integ#_#clear_inserted_text(a:curpos, a:line, a:completed_item, a:completion_item)
  endif

  if has_key(a:completion_item, 'additionalTextEdits')
    call s:TextEdit.apply(bufnr('%'), a:completion_item.additionalTextEdits)
  endif

  if strlen(l:expand_text) > 0
    call vsnip#anonymous(l:expand_text)
  endif

  return ''
endfunction

"
" vsnip_integ#_#clear_inserted_text
"
function! vsnip_integ#_#clear_inserted_text(curpos, line, completed_item, ...) abort
  let l:completion_item = get(a:000, 0, {})

  " remove last inserted characters.
  call setline('.', a:line)

  " remove completed string.
  let l:range = {
        \   'start': {
        \     'line': a:curpos[1] - 1,
        \     'character': (a:curpos[2] + a:curpos[3]) - strlen(a:completed_item.word) - 1
        \   },
        \   'end': {
        \     'line': a:curpos[1] - 1,
        \     'character': (a:curpos[2] + a:curpos[3]) - 1
        \   }
        \ }

  if !empty(l:completion_item) && has_key(l:completion_item, 'textEdit')
    let l:range.start.character = l:completion_item.textEdit.range.start.character
    let l:range.end.character = max([
          \   l:range.end.character,
          \   l:completion_item.textEdit.range.end.character
          \ ])
  endif

  call s:TextEdit.apply(bufnr('%'), [{
        \   'range': l:range,
        \   'newText': ''
        \ }])

  " move to complete start position.
  call cursor([l:range.start.line + 1, l:range.start.character + 1])
endfunction

"
" vsnip_integ#_#get_expand_text
"
function! vsnip_integ#_#get_expand_text(completed_item, completion_item) abort
  let l:text = a:completed_item.word
  if has_key(a:completion_item, 'textEdit')
    let l:text = a:completion_item.textEdit.newText
  elseif has_key(a:completion_item, 'insertText')
    let l:text = a:completion_item.insertText
  endif

  if l:text !=# a:completed_item.word
    return l:text
  endif
  if get(a:completion_item, 'insertTextFormat', 1) == 2
    return l:text
  endif
  return ''
endfunction

