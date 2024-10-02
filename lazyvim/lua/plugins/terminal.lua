return {
  {
    "numToStr/FTerm.nvim",
    keys = {
      { "<c-t>", '<CMD>lua require("FTerm").toggle()<CR>',            desc = "open terminal",  mode = "n" },
      { "<c-t>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', desc = "close terminal", mode = "t" },
    },
  },
}
