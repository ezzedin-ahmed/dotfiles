return {
	{
		"hrsh7th/cmp-nvim-lsp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/nvim-cmp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{
						name = "lazydev",
						group_index = 0, -- set group index to 0 to skip loading LuaLS completions
					},
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- For luasnip users.
				}, {
					{ name = "buffer" },
				}),
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local function opts(desc)
						return { desc = "LSP: " .. desc, remap = false }
					end
					-- Use telescope for lsp navigation
					local builtin = require("telescope.builtin")
					-- Uncomment to disable LSP semantic highlighting if it looks ugly!
					--client.server_capabilities.semanticTokensProvider = nil
					vim.keymap.set("n", "gd", builtin.lsp_definitions, opts("goto definition"))
					vim.keymap.set("n", "gy", builtin.lsp_type_definitions, opts("goto type definition"))
					vim.keymap.set("n", "gi", builtin.lsp_implementations, opts("goto implementation"))

					vim.keymap.set(
						"n",
						"gr",
						builtin.lsp_references,
						{ desc = "LSP: find references", silent = true, noremap = false }
					)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("hover over symbol under cursor"))
					vim.keymap.set("n", "<leader>s", builtin.lsp_dynamic_workspace_symbols, opts("dynamic LSP symbols"))
					vim.keymap.set("n", "<leader>vd", function()
						builtin.diagnostics({ bufnr = 0 })
					end, opts("local buffer diagnostics"))
					vim.keymap.set("n", "<leader>vwd", builtin.diagnostics, opts("workspace diagnostics"))
					vim.keymap.set("n", "[d", function()
						vim.diagnostic.goto_next()
					end, opts("next diagnostic"))
					vim.keymap.set("n", "]d", function()
						vim.diagnostic.goto_prev()
					end, opts("prev diagnostic"))
					vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts("code actions"))
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("rename"))
					vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts("signature help"))

					vim.api.nvim_set_option_value("formatexpr", "v:lua.vim.lsp.formatexpr()", { buf = bufnr })
					vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
					vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })
				end,
			})
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"basedpyright",
					"ruff",
					"jdtls",
					"yamlls",
					"texlab",
				},
				automatic_enable = false,
			})
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			vim.lsp.enable("texlab")
			vim.lsp.enable("lua_ls")
			vim.lsp.config["jdtls"] = {
				settings = {
					java = {
						configuration = {
							-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
							-- And search for `interface RuntimeOption`
							-- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
							runtimes = {
								{
									name = "JavaSE-17",
									path = "/var/corretto-17",
								},
							},
						},
					},
				},
			}
			vim.lsp.enable("jdtls")
			vim.lsp.config("yamlls", {
				cmd = { "yaml-language-server", "--stdio" },
				filetypes = { "yaml", "yml" },
				settings = {
					yaml = {
						validate = true,
						completion = true,
						hover = true,

						format = { enable = true },

						schemaStore = {
							enable = true,
							url = "https://www.schemastore.org/api/json/catalog.json",
						},

						schemas = {
							kubernetes = {
								"k8s/*.yaml",
								"**/kubernetes/*.yaml",
								"**/manifests/*.yaml",
							},
							["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.0/all.json"] = {
								"*.k8s.yaml",
							},
						},
					},
				},
			})

			vim.lsp.enable("yamlls")
			vim.lsp.enable("yamlls")
			vim.lsp.config["basedpyright"] = {
				cmd = { "basedpyright-langserver", "--stdio" },
				root_markers = { "pyproject.toml", "pyrightconfig.json", ".git" },
				settings = {
					basedpyright = {
						analysis = {
							ignore = { "*" },
						},
					},
				},
				capabilities = capabilities,
			}
			vim.lsp.enable("basedpyright")

			vim.lsp.config["ruff"] = {
				cmd = { "ruff", "server", "--preview" }, -- or just 'ruff-lsp' if you prefer
				root_markers = { "pyproject.toml", ".git" },
				settings = {
					ruff = {
						organizeImports = true,
						fixAll = true,
					},
				},
				capabilities = capabilities,
			}
			vim.lsp.enable("ruff")
		end,
	},
	{ "mfussenegger/nvim-jdtls" },
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false,
	},
	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		opts = {}, -- required, even if empty
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup()
			vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
		end,
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			-- options
		},
	},
}
