# vim-vsnip-integ

This plugin provides some plugins integration.

- Snippet completion
- Snippet expansion


# Requirements

- [vim-vsnip](https://github.com/hrsh7th/vim-vsnip)


# Integrations

### LSP

#### [vim-lsp](https://github.com/prabirshrestha/vim-lsp)
- Support snippet text expansion.

#### [vim-lsc](https://github.com/natebosch/vim-lsc)
- Support snippet text expansion.

#### [vim-lamp](https://github.com/hrsh7th/vim-lamp)
- Support snippet text expansion.

#### [deoplete-lsp](https://github.com/Shougo/deoplete-lsp)
- Support snippet text expansion.
- Support textEdit/additionalTextEdits at CompleteDone.

#### [LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim)
- Support snippet text expansion.


### Completion

#### [deoplete.nvim](https://github.com/Shougo/deoplete.nvim)
- Snippet completion.

#### [asyncomplete.vim](https://github.com/prabirshrestha/asyncomplete.vim)
- Snippet completion.

#### [vim-mucomplete](https://github.com/lifepillar/vim-mucomplete)
- Snippet completion.


# Development

### vimrc configuration for nvim builtin lsp

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

