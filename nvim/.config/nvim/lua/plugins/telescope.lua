return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        keys = {
            { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            { "<leader>g", "<cmd>Telescope live_grep<cr>",  desc = "Live Grep" },
            { "<leader>b", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    file_ignore_patterns = { ".git/", "node_modules/", "__pycache__/" },
                },
            })
            telescope.load_extension("fzf")
        end,
    },
}
