return {
  {
    "numToStr/FTerm.nvim",
    keys = {
      { "<m-i>", '<CMD>lua require("FTerm").toggle()<CR>',            desc = "open terminal",  mode = "n" },
      { "<m-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', desc = "close terminal", mode = "t" },
    },
  },
}
