return {
    'jmederosalvarado/roslyn.nvim',
    enabled = false,
    config = function()
        require('roslyn').setup()
    end
}
