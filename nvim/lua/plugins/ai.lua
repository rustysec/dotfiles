return {
    enabled = true,
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        'hrsh7th/nvim-cmp',
    },
    opts = {
        strategies = {
            -- Change the default chat adapter
            chat = {
                adapter = {
                    name = "llama.cpp",
                    model = 'Qwen3.6-it',
                },
            },
            inline = {
                adapter = {
                    name = "llama.cpp",
                    model = 'Qwen3.6-it',
                },
            },
            cmd = {
                adapter = {
                    name = "llama.cpp",
                    model = 'Qwen3.6-it',
                },
            },
        },
        opts = {
            -- Set debug logging
            log_level = "DEBUG",
        },
    },
}
