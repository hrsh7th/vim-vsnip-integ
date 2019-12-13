# vim-vsnip-integ

This plugin provides some other plugins integration.

LSP spec has `textDocument/completion` feature that add ability inteligent completion to vim.
The feature will returns `CompletionItem` that has `textEdit/additionalTextEdits` and support snippet text.

- textEdit
    - To enable complex completion.
    - For example, completion done on `     </div#>` then the server can correct indent size.    
- additionalTextEdits
    - To enable auto-import for some other modules/packages.

This plugins may enables `textEdit/additionalTextEdits` if it possible.

# Requirements

- [vim-vsnip](https://github.com/hrsh7th/vim-vsnip)

# Integrations

### [vim-lsp](https://github.com/prabirshrestha/vim-lsp)
- Support `completionItem/resolve` at `CompleteDone`.
- Support textEdit/additionalTextEdits.


### [vim-lsc](https://github.com/natebosch/vim-lsc)
- Support snippet text expansion.


### [vim-lamp](https://github.com/hrsh7th/vim-lamp)
- Support snippet text expansion.
- vim-lamp has already supported textEdit/additionalTextEdits/executeCommand/floatinw-docs.


### [deoplete.nvim](https://github.com/Shougo/deoplete.nvim)
- Snippet completion.

### [deoplete-lsp](https://github.com/Shougo/deoplete-lsp)
- Support textEdit/additionalTextEdits at CompleteDone.


# Development

### sample vimrc configuration for `deoplete-lsp`

```viml
lua require'nvim_lsp'.gopls.setup{
      \   capabilities = {
      \     textDocument = {
      \       completion = {
      \         completionItem = {
      \           snippetSupport = true
      \         }
      \       }
      \     }
      \   },
      \   init_options = {
      \     usePlaceholders = true,
      \     completeUnimported = true
      \   }
      \ }
```

