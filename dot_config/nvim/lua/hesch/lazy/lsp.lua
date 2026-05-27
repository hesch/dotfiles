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
        "linrongbin16/lsp-progress.nvim",
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        vim.lsp.config['apigee-ls'] = {
            cmd = { "apigee-ls-dev" },
            filetypes = { "xml" },
            root_markers = { ".apigee-ls" },
            on_attach = function (client, bufnr)
                print('apigee-ls attached', client.name, bufnr)
                vim.keymap.set("n", "<leader>r", RestartLsp)
            end
        }

        vim.lsp.enable('apigee-ls')
        require('lsp-progress').setup()

        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end)
        vim.keymap.set("n", "[d", function() vim.diagnostic.jump({count = -1}) end)
        vim.keymap.set("n", "]d", function() vim.diagnostic.jump({count = 1 }) end)

        local telescope = require("telescope.builtin")
        local themes = require("telescope.themes")
        local function telescope_results(options)
            vim.fn.setqflist({}, ' ', options)
            if #options.items == 1 then
                vim.cmd.cfirst()
                return
            end

            telescope.quickfix(
                themes.get_dropdown({
                    initial_mode = "normal",
                })
            );
        end

        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'LSP actions',
            callback = function(event)
                local opts = {buffer = event.buf}

                -- these will be buffer-local keybindings
                -- because they only work if you have an active language server
                local function outgoing_calls(callHierarchyPreparationResult)
                    vim.lsp.buf_request(
                        event.buf,
                        vim.lsp.protocol.Methods.callHierarchy_outgoingCalls,
                        { item = callHierarchyPreparationResult[1] },
                        function(err, calls, ctx)
                            if err or not calls or vim.tbl_isempty(calls) then
                                return
                            end

                            local locations = {}
                            for _, callsite in ipairs(calls) do
                                local to = callsite.to
                                table.insert(locations, {
                                    filename = vim.uri_to_fname(to.uri),
                                    lnum = to.selectionRange.start.line + 1,
                                    col = to.selectionRange.start.character,
                                    end_lnum = to.selectionRange["end"].line + 1,
                                    end_col = to.selectionRange["end"].character,
                                    text = to.name,
                                })
                            end

                            telescope_results({
                                title = "Outgoing calls",
                                items = locations,
                            })

                        end)
                end
                
                local function incoming_calls(callHierarchyPreparationResult)
                    vim.lsp.buf_request(
                        event.buf,
                        vim.lsp.protocol.Methods.callHierarchy_incomingCalls,
                        { item = callHierarchyPreparationResult[1] },
                        function(err, calls, ctx)
                            if err or not calls or vim.tbl_isempty(calls) then
                                return
                            end


                            local locations = {}
                            for _, callsite in ipairs(calls) do
                                for _, range in ipairs(callsite.fromRanges) do
                                    table.insert(locations, {
                                        filename = vim.uri_to_fname(callsite.from.uri),
                                        lnum = range.start.line + 1,
                                        col = range.start.character,
                                        end_lnum = range["end"].line + 1,
                                        end_col = range["end"].character,
                                        text = callsite.from.name,
                                    })
                                end
                            end

                            telescope_results({
                                title = "Incoming calls",
                                items = locations,
                            })

                        end)
                end

                local function ch_helper(callback)
                    return function()
                        local params = vim.lsp.util.make_position_params()

                        vim.lsp.buf_request(
                            event.buf,
                            vim.lsp.protocol.Methods.textDocument_prepareCallHierarchy,
                            params,
                            function(err, result, ctx)
                                if err or not result or vim.tbl_isempty(result) then
                                    return
                                end
                                callback(result)
                            end
                        )
                    end
                end

                vim.keymap.set("n", "gh", ch_helper(incoming_calls), opts)
                vim.keymap.set("n", "gH", ch_helper(outgoing_calls), opts)

                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition({ on_list = telescope_results }) end, opts)
                vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration({ on_list = telescope_results }) end, opts)
                vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation({ on_list = telescope_results }) end, opts)
                vim.keymap.set("n", "gr", function() vim.lsp.buf.references(nil, { on_list = telescope_results }) end, opts)
                --vim.keymap.set("n", "gh", function() vim.lsp.buf.incoming_calls() end, opts)
                --vim.keymap.set("n", "gH", function() vim.lsp.buf.outgoing_calls() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>cr", function() vim.lsp.buf.rename() end, opts)
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
