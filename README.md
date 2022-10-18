# fcitx.nvim

A plugin to auto-restore fcitx input method on entering INSERT mode in neovim.

It deactivates fcitx/fcitx5 in NORMAL mode, which should leave you in English input state. It re-activates fcitx/fcitx5 on entering INSERT mode if it was activated the last time you were in INSERT mode.

## Requirement

1. neovim >= 0.7: for the lua APIs
1. fcitx-remote or fcitx5-remote: they are installed as part of the fcitx/fcitx5 package in archlinux/debian/ubuntu
1. a Linux/GNU distro: I don't have a macOS/Windows for testing, maybe the plugin works there too

## Installation

Using [packer](https://github.com/wbthomason/packer.nvim):

```lua
use({
  "smartding/fcitx.nvim",
  config = function()
    require("fcitx").setup()
  end,
})
```
