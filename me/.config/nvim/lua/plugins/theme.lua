return {
	{
		"catppuccin/nvim",
		dependencies = {
			"nvim-lualine/lualine.nvim",
		},
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd("color catppuccin")
			require("lualine").setup({
				options = {
					-- lualine will integrate with catppuccin by name or automatically via `vim.g.colors_name` by setting this to "auto"
					theme = "catppuccin",
					-- ... the rest of your lualine config
				},
			})
		end,
	},
}
