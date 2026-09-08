return {
  {
    "rcasia/neotest-java",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
  },
  {
    "nvim-neotest/neotest",
    cmd = { "Neotest" },
    -- Lazy-loads the entire plugin tree only when pressing a test keymap
    keys = {
      { "<leader>tr", function() require("neotest").run.run({ suite = false, testify = true }) end, desc = "Debug: Running Nearest Test" },
      { "<leader>tv", function() require("neotest").summary.toggle() end, desc = "Debug: Summary Toggle" },
      { "<leader>ts", function() require("neotest").run.run({ suite = true, testify = true }) end, desc = "Debug: Running Test Suite" },
      { "<leader>td", function() require("neotest").run.run({ suite = false, testify = true, strategy = "dap" }) end, desc = "Debug: Debug Nearest Test" },
      { "<leader>to", function() require("neotest").output.open() end, desc = "Debug: Open test output" },
      { "<leader>tl", function() require("neotest").output_panel.open() end, desc = "Debug: Open test panel" },
      { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Debug: Run all tests" },
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "codymikol/neotest-kotlin",
      "rcasia/neotest-java",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({
            jestCommand = "npm test --",
            jestArguments = function(defaultArguments)
              return defaultArguments
            end,
            jestConfigFile = "jest.config.ts",
            env = {},
            cwd = function()
              return vim.fn.getcwd()
            end,
            -- Safe function wrapper: Defers module import until an actual test check runs
            isTestFile = function(file_path)
              return require("neotest-jest.jest-util").defaultIsTestFile(file_path)
            end,
          }),
          require("neotest-vitest"),
          require("neotest-kotlin"),
          require("neotest-java")({}),
        },
      })
    end,
  },
}
