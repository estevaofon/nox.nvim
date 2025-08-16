-- ftdetect/nox.lua - Detect .nx files as nox filetype
vim.filetype.add({
  extension = {
    nx = "nox",
  },
  pattern = {
    [".*%.nx$"] = "nox",
  },
})
