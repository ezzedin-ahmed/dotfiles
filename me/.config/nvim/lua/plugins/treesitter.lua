return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			"rust",
			"javascript",
			"typescript",
			"python",
			"java",
			"lua",
			"fish",
			"bash",
			"json",
			"yaml",
			"dockerfile",
		})
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "<filetype>" },
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
