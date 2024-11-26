return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        dependencies = {
            "EdenEast/nightfox.nvim",
        },
        opts = {
            use_treesitter = true,
            show_current_context = true,
            show_current_context_start = true,
        },
        config = function()
            require("ibl").setup({
                indent = { highlight = "IblIndent" },
            })
        end,
    },
}
