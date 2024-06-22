return {
    {
        "EdenEast/nightfox.nvim",
        enabled = true,
        lazy = false,
        priority = 1000,
        config = function()
            require('nightfox').setup({
                options = {
                    transparent = true,
                    styles = {
                        comments = "italic",
                        keywords = "bold",
                        types = "italic,bold",
                    },
                    modules = {
                        telescope = true,
                        diagnostic = true,
                        native_lsp = true,
                        notify = true,
                        treesitter = true,
                    }
                }
            })
            vim.cmd.colorscheme("nightfox")
        end
    },
}
