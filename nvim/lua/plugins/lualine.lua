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
                    {
                        'filename',
                        path = 1,
                    },
                    'diagnostics',
                    'navic',
                },
            },
            inactive_winbar = {
                lualine_c = {
                    {
                        'filename',
                        path = 1,
                    },
                    'diagnostics',
                },
            },
        }
    end
} 
