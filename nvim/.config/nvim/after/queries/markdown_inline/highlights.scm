;extends

; Removes annoying backslashes in some LSP hover documentation.
; Source: https://github.com/neovim/neovim/discussions/37118#discussioncomment-15351670
((backslash_escape) @string.escape
  (#offset! @string.escape 0 0 0 -1)
  (#set! conceal ""))
