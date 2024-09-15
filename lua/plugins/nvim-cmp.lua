return {
	'hrsh7th/nvim-cmp',
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline',
		'hrsh7th/nvim-cmp',
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',
		'rafamadriz/friendly-snippets',
	},
	config = function()
		local cmp = require('cmp')
		local luasnip = require('luasnip')
		local types = require("cmp.types")
		local compare = require("cmp.config.compare")

		require('luasnip.loaders.from_vscode').lazy_load()

		luasnip.config.setup {}
		---@type table<integer, integer>
		local modified_priority = {
			[types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
			[types.lsp.CompletionItemKind.Snippet] = 0, -- top
			[types.lsp.CompletionItemKind.Keyword] = 0, -- top
			[types.lsp.CompletionItemKind.Text] = 100, -- bottom
		}
		---@param kind integer: kind of completion entry
		local function modified_kind(kind)
			return modified_priority[kind] or kind
		end
		cmp.setup {
			sorting = {
				-- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/compare.lua
				priority_weight = 2,
				comparators = {
					compare.offset,
					compare.exact,
					function(entry1, entry2) -- sort by length ignoring "=~"
						local len1 = string.len(string.gsub(entry1.completion_item.label, "[=~()_]", ""))
						local len2 = string.len(string.gsub(entry2.completion_item.label, "[=~()_]", ""))
						if len1 ~= len2 then
							return len1 - len2 < 0
						end
					end,
					compare.recently_used,
					function(entry1, entry2) -- sort by compare kind (Variable, Function etc)
						local kind1 = modified_kind(entry1:get_kind())
						local kind2 = modified_kind(entry2:get_kind())
						if kind1 ~= kind2 then
							return kind1 - kind2 < 0
						end
					end,
					function(entry1, entry2) -- score by lsp, if available
						local t1 = entry1.completion_item.sortText
						local t2 = entry2.completion_item.sortText
						if t1 ~= nil and t2 ~= nil and t1 ~= t2 then
							return t1 < t2
						end
					end,
					compare.score,
					compare.order,
				},
			}, snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
			completion = {
				completeopt = 'menu,menuone,noinsert',
			},
			mapping = cmp.mapping.preset.insert {
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete {},
				['<CR>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				},
				['<Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { 'i', 's' }),
				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { 'i', 's' }),
			},
			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'path' },
				{ name = 'buffer' },
			},
		}
	end
}
