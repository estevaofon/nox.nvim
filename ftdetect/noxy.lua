-- ftdetect/noxy.lua - Detect .nx files as noxy filetype
vim.filetype.add({
  extension = {
    nx = "noxy",
  },
  pattern = {
    [".*%.nx$"] = "noxy",
  },
})
