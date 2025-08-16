# nox.nvim

A simple and efficient syntax highlighting plugin for the Nox programming language in Neovim.

<img height="300" alt="image" src="https://github.com/user-attachments/assets/88ecc84c-0d52-4f99-8445-ea3c43537734" />


## Features

- 🎨 Syntax highlighting for Nox language constructs
- 🚀 Automatic filetype detection for `.nx` files
- ⚡ Fast and lightweight
- 🔧 Zero configuration required

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "estevaofon/nox.nvim",
  ft = "nox",  -- Lazy load on Nox files
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "estevaofon/nox.nvim",
  ft = {"nox"},
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'estevaofon/nox.nvim'
```

## Usage

The plugin works automatically for any file with the `.nx` extension. No configuration needed!

### Commands

- `:NoxHighlight` - Force refresh syntax highlighting for current buffer
- `:NoxRefresh` - Refresh highlighting for all open Nox buffers

### Manual Setup (Optional)

If you want to customize the setup:

```lua
require("nox").setup({
  -- Currently no options, but reserved for future use
})
```

## Supported Syntax

### Keywords
`struct`, `end`, `let`, `func`, `return`, `if`, `then`, `else`, `while`, `do`, `for`, `in`, `ref`, `void`

### Types
`int`, `string`, `bool`, `void`

### Built-in Functions
`print`, `strlen`, `ord`, `to_str`

### Literals
- Strings: `"..."` or `'...'`
- Numbers: `123`, `-456`, `3.14`
- Booleans: `true`, `false`
- Null: `null`

### Comments
Single-line comments: `// comment`

## File Structure

```
nox.nvim/
├── lua/
│   └── nox/
│       ├── init.lua       # Main plugin logic
│       └── highlights.lua # Color definitions
├── plugin/
│   └── nox.lua           # Auto-loading
├── ftdetect/
│   └── nox.lua           # File type detection
├── ftplugin/
│   └── nox.lua           # File type settings
└── README.md
```

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
