return {
    {
        'mfussenegger/nvim-dap',
        config = function ()
            local dap = require("dap")
            dap.set_log_level("DEBUG")

            vim.keymap.set("n", "<F9>", dap.continue, { desc = "Debug: Continue" })
            vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
            vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
            vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
            vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>B", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, { desc = "Debug: Set Conditional Breakpoint" })

            require("dap").adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "node",
                    args = {"/Users/henri/.local/scripts/js-debug/src/dapDebugServer.js", "${port}"},
                }
            }

            require("dap").configurations.javascript = {
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                },
            }
        end
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },
        config = function ()
            require("dapui").setup()
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.before.attach.dapui_config = function()
                  dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                  dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                  dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                  dapui.close()
            end
        end
    }
}
