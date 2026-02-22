return {
    {
        "rcasia/neotest-java",
        ft = "java",
        dependencies = {
            "mfussenegger/nvim-jdtls",
            "mfussenegger/nvim-dap", -- for the debugger
            "rcarriga/nvim-dap-ui", -- recommended
            "theHamsta/nvim-dap-virtual-text", -- recommended
        },
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "codymikol/neotest-kotlin",
            "rcasia/neotest-java",
            "nvim-neotest/neotest-jest",
        },
        config = function ()
            require("neotest").setup({
                adapters = {
                    require("neotest-kotlin"),
                    require("neotest-java")({
                        -- config here
                    }),
                    require("neotest-jest")({
                        jestCommand = "npm test --",
                        jestArguments = function(defaultArguments, context)
                            return defaultArguments
                        end,
                        jestConfigFile = "jest.config.ts",
                        env = {},
                        cwd = function(path)
                            return vim.fn.getcwd()
                        end,
                        isTestFile = require("neotest-jest.jest-util").defaultIsTestFile,
                    }),
                }
            })
            vim.keymap.set("n", "<leader>tr", function()
                require("neotest").run.run({
                    suite = false,
                    testify = true,
                })
            end, { desc = "Debug: Running Nearest Test" })

            vim.keymap.set("n", "<leader>tv", function()
                require("neotest").summary.toggle()
            end, { desc = "Debug: Summary Toggle" })

            vim.keymap.set("n", "<leader>ts", function()
                require("neotest").run.run({
                    suite = true,
                    testify = true,
                })
            end, { desc = "Debug: Running Test Suite" })

            vim.keymap.set("n", "<leader>td", function()
                require("neotest").run.run({
                    suite = false,
                    testify = true,
                    strategy = "dap",
                })
            end, { desc = "Debug: Debug Nearest Test" })

            vim.keymap.set("n", "<leader>to", function()
                require("neotest").output.open()
            end, { desc = "Debug: Open test output" })

            vim.keymap.set("n", "<leader>tl", function()
                require("neotest").output_panel.open()
            end, { desc = "Debug: Open test panel" })


            vim.keymap.set("n", "<leader>ta", function()
                require("neotest").run.run(vim.fn.getcwd())
            end, { desc = "Debug: Run all tests" })
        end
    }
}
