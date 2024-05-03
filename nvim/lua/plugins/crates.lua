return {
    'saecki/crates.nvim',
    config = function()
        require('crates').setup({
            src = { cmp = { enabled = true } }
        })
    end,
} 
