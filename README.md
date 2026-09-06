# Install Steps

## 1. Winget

Install Neovim itself plus the CLI tools this config expects on `PATH`:

```powershell
winget install Neovim.Neovim
winget install Git.Git
winget install BurntSushi.ripgrep.MSVC
winget install sharkdp.fd
winget install JesseDuffield.lazygit
winget install OpenJS.NodeJS.LTS
winget install zig.zig
winget install Python.Python.3.13
winget install Microsoft.WindowsTerminal
```

> Restart your terminal (or sign out/in) afterward so the new installs are picked up on `PATH`. Verify with `nvim --version` — you need **0.12+** for `vim.pack` and the `ui2` cmdline used by this config.

## 2. Clone this repo

Neovim reads its config from `stdpath('config')`, which on Windows is `%LOCALAPPDATA%\nvim` (i.e. `~\AppData\Local\nvim`). Clone directly into that folder:

```powershell
git clone https://github.com/ChristopherElwell/nvim $env:LOCALAPPDATA\nvim
```


## 3. First launch

```powershell
nvim
```

This config uses Neovim's built-in `vim.pack` package manager, so plugins (including `tiny-cmdline.nvim`) are fetched automatically the first time you launch — no separate install/sync command needed. Give it a moment to download everything on that first run, then quit and reopen Neovim once it settles.

## 4. Verify

```powershell
:checkhealth
```

This flags anything still missing from `PATH` (`rg`, `fd`, `git`, `lazygit`, etc.) so you can catch a bad winget install.
