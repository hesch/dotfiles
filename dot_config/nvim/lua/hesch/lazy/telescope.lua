return {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ui-select.nvim'
    },
    config = function()
        require('telescope').setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-s>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
                    }
                }
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                        -- even more opts
                    }

                    -- pseudo code / specification for writing custom displays, like the one
                    -- for "codeactions"
                    -- specific_opts = {
                    --   [kind] = {
                    --     make_indexed = function(items) -> indexed_items, width,
                    --     make_displayer = function(widths) -> displayer
                    --     make_display = function(displayer) -> function(e)
                    --     make_ordinal = function(e) -> string
                    --   },
                    --   -- for example to disable the custom builtin "codeactions" display
                    --      do the following
                    --   codeactions = false,
                    -- }
                }
            },
        })
        require("telescope").load_extension("ui-select")

        local builtin = require('telescope.builtin')

        local my_find_files
        my_find_files = function(opts, no_ignore)
            opts = opts or {}
            no_ignore = vim.F.if_nil(no_ignore, false)
            opts.attach_mappings = function(_, map)
                map({ "n", "i" }, "<C-h>", function(prompt_bufnr) -- <C-h> to toggle modes
                    local prompt = require("telescope.actions.state").get_current_line()
                    require("telescope.actions").close(prompt_bufnr)
                    no_ignore = not no_ignore
                    my_find_files({ default_text = prompt }, no_ignore)
                end)
                return true
            end

            if no_ignore then
                opts.no_ignore = true
                opts.hidden = true
                opts.prompt_title = "Find Files <ALL>"
                builtin.find_files(opts)
            else
                opts.prompt_title = "Find Files"
                builtin.find_files(opts)
            end
        end

        vim.keymap.set('n', '<leader>pf', function() my_find_files({}, false) end, {})
        vim.keymap.set('n', '<leader>pF', function() my_find_files({}, true) end, {})
        vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
        vim.keymap.set('n', '<leader>pr', builtin.resume, {})
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})


        vim.keymap.set('n', '<leader>gh', builtin.git_bcommits_range, {})
        vim.keymap.set('n', '<leader>gsw', builtin.git_branches, {})
    end
}
