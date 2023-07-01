# vim-vsnip-integ

This plugin provides some plugins integration.

- Snippet completion
- Snippet expansion


# Requirements

- [vim-vsnip](https://github.com/hrsh7th/vim-vsnip)
	- You should set [mapping](https://github.com/hrsh7th/vim-vsnip/blob/master/README.md#2-setting).


# Integrations

### LSP

#### [vim-lsp](https://github.com/prabirshrestha/vim-lsp)
- Support snippet text expansion.

#### [vim-lsc](https://github.com/natebosch/vim-lsc)
- Support snippet text expansion.

#### [yegappan/lsp](https://github.com/yegappan/lsp)
- Support snippet text expansion.

#### [LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim)
- Support snippet text expansion.

#### [nvim builtin-lsp omnifunc](https://github.com/neovim/neovim)
- Support snippet text expansion.
- Support textEdit/additionalTextEdits at CompleteDone.


### Completion

#### [asyncomplete.vim](https://github.com/prabirshrestha/asyncomplete.vim)
- Snippet completion.

#### [vim-mucomplete](https://github.com/lifepillar/vim-mucomplete)
- Snippet completion.

#### [vim-easycompletion](https://github.com/jayli/vim-easycomplete)
- Snippet completion.

#### [ddc.vim](https://github.com/Shougo/ddc.vim)
- This plugin doesn't support ddc.vim.
- Users of ddc.vim should use [ddc-source-vsnip](https://github.com/uga-rosa/ddc-source-vsnip).
