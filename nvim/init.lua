local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.list = true
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.mouse = 'a'

require('lazy').setup('plugins')

vim.cmd.colorscheme('catppuccin')
require('focus').setup({})
require("ibl").setup()
require('gitsigns').setup()
require('mini.surround').setup()

local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' }
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                target = os.getenv('LSP_CARGO_TARGET') or nil,
            },
            check = {
                command = 'clippy',
                ignore = {},
            },
            diagnostics = {
                enable = true,
                disabled = {
                    'inactive-code',
                    'unlinked-file',
                },
            },
        },
    },
})

lspconfig.clangd.setup({
    capabilities = capabilities,
})

lspconfig.tsserver.setup({
    capabilities = capabilities,
})

lspconfig.lua_ls.setup({
    capabilities = capabilities,
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                --[[
                library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                }
                ]] --
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                library = vim.api.nvim_get_runtime_file("", true)
            }
        })
    end,
    settings = {
        Lua = {}
    }
})

lspconfig.marksman.setup({
    capabilities = capabilities,
})

lspconfig.nil_ls.setup({
    capabilities = capabilities,
    settings = {
        ['nil'] = {
            formatting = {
                command = { 'nixpkgs-fmt' },
            },
        },
    },
})

-- require('lsp-inlayhints').setup({})
-- vim.api.nvim_create_augroup('LspAttach_inlayhints', {})
-- vim.api.nvim_create_autocmd('LspAttach', {
-- group = 'LspAttach_inlayhints',
-- callback = function(args)
--     if not (args.data and args.data.client_id) then
--         return
--     end
--
--     local bufnr = args.buf
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     require('lsp-inlayhints').on_attach(client, bufnr, true)
-- end
-- })

vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    group = 'YankHighlight',
    desc = 'Highlight yanked text',
    pattern = '*',
    command = 'silent! lua vim.highlight.on_yank()',
})

vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

local navic = require("nvim-navic")
local function on_attach(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

local keymaps = {
    { mode = 'n', key = '<C-S>',      action = ':w<cr>' },
    { mode = 'i', key = '<C-S>',      action = '<esc>:w<cr>' },

    { mode = 'n', key = '<leader>e',  action = ':Oil<cr>' },
    { mode = 'n', key = '<leader>|',  action = ':vsplit<cr>' },
    { mode = 'n', key = '<leader>-',  action = ':split<cr>' },
    { mode = 'n', key = '<leader>fb', action = ':Telescope buffers<cr>' },
    { mode = 'n', key = '<leader>fd', action = ':Telescope diagnostics<cr>' },
    { mode = 'n', key = '<leader>ff', action = ':Telescope find_files<cr>' },
    { mode = 'n', key = '<leader>fg', action = '<cmd>Telescope live_grep<cr>' },
    { mode = 'n', key = '<leader>fr', action = ':Telescope lsp_references<cr>' },
    { mode = 'n', key = '<leader>fs', action = ':Telescope lsp_document_symbols<cr>' },
    { mode = 'n', key = '<leader>fS', action = ':Telescope lsp_dynamic_workspace_symbols<cr>' },
    { mode = 'n', key = '<leader>fw', action = ':Telescope grep_string<cr>' },

    { mode = 'n', key = 'gd',         action = ':lua vim.lsp.buf.definition()<cr>' },
    { mode = 'n', key = '<leader>ca', action = ':lua vim.lsp.buf.actions()<cr>' },
    { mode = 'n', key = '<leader>cd', action = ':lua vim.diagnostic.open_float()<cr>' },
    { mode = 'n', key = '<leader>cn', action = ':Navbuddy<cr>' },
    { mode = 'n', key = '<leader>cr', action = ':lua vim.lsp.buf.rename()<cr>' },

    { mode = 'n', key = '<C-h>',      action = ':wincmd h<cr>' },
    { mode = 'n', key = '<C-j>',      action = ':wincmd j<cr>' },
    { mode = 'n', key = '<C-k>',      action = ':wincmd k<cr>' },
    { mode = 'n', key = '<C-l>',      action = ':wincmd l<cr>' },
    { mode = 'n', key = '<C-Left>',   action = ':wincmd h<cr>' },
    { mode = 'n', key = '<C-Down>',   action = ':wincmd j<cr>' },
    { mode = 'n', key = '<C-Up>',     action = ':wincmd k<cr>' },
    { mode = 'n', key = '<C-Right>',  action = ':wincmd l<cr>' },
    { mode = 'n', key = 'H',          action = ':bnext<cr>' },
    { mode = 'n', key = 'L',          action = ':bprev<cr>' },

    { mode = 'n', key = '<leader>gb', action = ':Gitsigns blame_line<cr>' },
    { mode = 'n', key = '<leader>gl', action = ':Gitsigns prev_hunk<cr>' },
    { mode = 'n', key = '<leader>gn', action = ':Gitsigns next_hunk<cr>' },
    { mode = 'n', key = '<leader>gp', action = ':Gitsigns preview_hunk_inline<cr>' },
    { mode = 'n', key = '<leader>gP', action = ':Gitsigns preview_hunk<cr>' },
    { mode = 'n', key = '<leader>gr', action = ':Gitsigns reset_hunk<cr>' },

    { mode = 'n', key = '<leader>bd', action = ':lua require("mini.bufremove").delete()<cr>' },
    { mode = 'n', key = '<leader>wd', action = '<C-W>c', },
    { mode = 'n', key = '<leader>w|', action = '<C-W>v', },
    { mode = 'n', key = '<leader>|',  action = '<C-W>v', },
    { mode = 'n', key = '<leader>w-', action = '<C-W>s', },
    { mode = 'n', key = '<leader>-',  action = '<C-W>s', },

    { mode = 'n', key = '<leader>ss', action = ':Telescope spell_suggest<cr>' },

    { mode = 'n', key = '<esc>',      action = '<esc>:noh<cr>' },
    { mode = 'i', key = '<esc>',      action = '<esc>:noh<cr>' },
};

for _, keymap in ipairs(keymaps) do
    vim.api.nvim_set_keymap(keymap.mode, keymap.key, keymap.action, { noremap = true, silent = true })
end
