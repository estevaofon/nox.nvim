# nox.nvim

A Neovim plugin for Nox language support with advanced syntax highlighting.

## Features

- 🎨 Advanced syntax highlighting
- 📝 Automatic file type detection for `.nx` files  
- ⚡ Real-time highlighting updates
- 🔧 Customizable highlight groups
- 📦 Zero dependencies

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "yourusername/nox.nvim",
  ft = "nox",
  config = function()
    require("nox").setup({
      -- your configuration
    })
  end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'yourusername/nox.nvim',
  ft = {'nox'},
  config = function()
    require('nox').setup({})
  end
}
```

## Configuration

```lua
require('nox').setup({
  -- Enable debug mode
  debug = false,
  
  -- Custom highlight groups
  highlights = {
    NoxKeyword = { fg = "#ff0080", bold = true },
    NoxType = { fg = "#64c8ff" },
    NoxString = { fg = "#00ffff" },
    -- ... more custom highlights
  },
  
  -- Enable specific features
  features = {
    auto_highlight = true,
    indent_guides = false,
    completion = false,
  }
})
```

## Commands

- `:NoxHighlight` - Force syntax highlighting on current buffer
- `:NoxRefresh` - Refresh highlighting for all Nox buffers
- `:NoxDebug` - Toggle debug mode
- `:NoxStatus` - Show status information
- `:NoxTest` - Create a test buffer with sample Nox code

## License

MIT
