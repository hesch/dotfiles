local root_files = {
  '.git',
}

function RestartLsp()
    local bufnr = vim.api.nvim_get_current_buf()
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
        local config = client.config
        client.stop()
        vim.lsp.start(config)  -- start it again with same config
    end
end

return {
    "neovim/nvim-lspconfig",
    branch = "master",
    dependencies = {
        'linrongbin16/lsp-progress.nvim',
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip"
    },
    config = function()
        vim.lsp.config['apigee-ls'] = {
            cmd = { "apigee-ls-dev" },
            filetypes = { "xml" },
            root_markers = { ".git" },
            on_attach = function (client, bufnr)
                print('apigee-ls attached', client.name, bufnr)
                vim.keymap.set("n", "<leader>r", RestartLsp)
            end
        }

        vim.lsp.enable('apigee-ls')
        require('lsp-progress').setup()

        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'LSP actions',
            callback = function(event)
                local opts = {buffer = event.buf}

                -- these will be buffer-local keybindings
                -- because they only work if you have an active language server

                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
                vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
                vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            end
        })
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

        local default_setup = function(server)
            vim.lsp.config(server, {
                capabilities = lsp_capabilities,
            })
        end

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = {},
            handlers = {
                default_setup,
                lua_ls = function()
                    vim.lsp.config("lua_ls", {
                        capabilities = lsp_capabilities,
                        settings = {
                            Lua = {
                                runtime = {
                                    version = 'LuaJIT'
                                },
                                diagnostics = {
                                    globals = {'vim'},
                                },
                                workspace = {
                                    library = {
                                        vim.env.VIMRUNTIME,
                                    }
                                }
                            }
                        }
                    })
                end
            },
        })

        local cmp = require('cmp')

        cmp.setup({
            sources = {
                {name = 'nvim_lsp'},
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
        })
    end
}
