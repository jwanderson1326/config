return {
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("nightfox").setup({
                palettes = {
                    all = {
                        magenta = "#f681ba",
                        green = "#52f0a0",
                        red = "#ed7575",
                    }
                },
            })
            vim.cmd([[colorscheme nightfox]])
        end,
        modules_default = true,
    },
}
