# vim-vsnip-integ.

This plugin provides below integrations.

# Requirements.

- [vim-vsnip](https://github.com/hrsh7th/vim-vsnip)

# Integrations.

### [vim-lsp](https://github.com/prabirshrestha/vim-lsp)
- Support `completionItem/resolve` at `CompleteDone`.
- Support textEdit/insertText.


### [vim-lsc](https://github.com/natebosch/vim-lsc)
- Support `v:completed_item.user_data.snippet`.


### [vim-lamp](https://github.com/hrsh7th/vim-lamp)
- Snippet support.
- vim-lamp has already supported textEdit/additionalTextEdit/executeCommand/floatinw-docs.


### [deoplete.nvim](https://github.com/Shougo/deoplete.nvim)
- Snippet completion.

### [deoplete-lsp](https://github.com/Shougo/deoplete-lsp)
- Support textEdit/insertText at CompleteDone.


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

