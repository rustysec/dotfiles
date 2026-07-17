return {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    opts = {},
    enabled = not os.getenv("NO_LLAMA"),
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
}
