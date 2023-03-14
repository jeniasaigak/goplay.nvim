# ▶️  Goplay.nvim

**goplay.nvim** is a local go playground for Neovim. Goplay.nvim uses locally installed [Go tool](https://pkg.go.dev/cmd/go) to prepare and run the code from the playground.

## ⚡️ Requirements

- [Go tool](https://pkg.go.dev/cmd/go)

## 📦 Installation

Install the plugin via your favorite plugins manager, e.g.:

```lua
use "jeniasaigak/goplay.nvim"
```

Then you may add the following Lua code to setup the plugin:

<!-- bootstrap:start -->

```lua
require('goplay').setup()
```

<!-- bootstrap:end -->

## ⚙️  Configuration

**goplay.nvim** comes with the following defaults:

<!-- config:start -->

```lua
{
  template = require("goplay.templates").default, -- template which will be used as the default content for the playground
  mode = "vsplit", -- current/split/[vsplit] specifies where the playground will be opened
  playgroundDirName = "goplayground", -- a name of the directory under GOPATH/src where the playground will be saved
  tempPlaygroundDirName = "goplayground_temp", -- a name of the directory under GOPATH/src where the temporary playground will be saved. This option is used when you need to execute a file
  output_mode = "formatted", -- [formatted]/raw mode to display output
}
```

<!-- config:end -->

## 🚀 Usage

<!-- commands:start -->

| Command                   | Lua                                          | Description                                                                                  |
| ------------------------- | -------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `:GPOpen`                 | `require("goplay").goPlaygroundOpen()`       | opens a playground; this command will prepare playground directory & files if needed         |
| `:GPToggle`               | `require("goplay").goPlaygroundToggle()`     | executes open command if the playground is closed, or close command otherwise                |
| `:GPExec`                 | `require("goplay").goExecPlayground()`       | executes the code at the playground and prints the results                                   |
| `:GPClose`                | `require("goplay").goPlaygroundClose()`      | close a playground                                                                           |
| `:GPClear`                | `require("goplay").deletePlayground()`       | removes the playground folder                                                                |
| `:GPExecFile`             | `require("goplay").goExecFileAsPlayground()` | simply execute lines from currently opened buffer as go file and show the results            |

<!-- commands:end -->

## ⌨️  Gopaly Key Mappings

Here are recommended keybindings to use:

```lua
vim.api.nvim_set_keymap('n', '<leader>gpt', ':GPToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gpe', ':GPExec<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gpf', ':GPExecFile<CR>', { noremap = true, silent = true })
```
