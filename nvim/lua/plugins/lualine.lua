return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = function(_, opts)
        return {
            options = {
                globalstatus = true,
            },
            winbar = {
                lualine_c = {
                    'filename',
                    'diagnostics',
                    'navic',
                },
            },
            inactive_winbar = {
                lualine_c = {
                    'filename',
                    'diagnostics',
                },
            },
        }
    end
} 
