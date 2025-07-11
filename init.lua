-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true -- Set to true if you have a Nerd Font installed and selected in the terminal

-- [[ Setting options ]] See `:help vim.opt`. For more options, you can see `:help option-list`

vim.opt.number = true -- Make line numbers default
vim.opt.relativenumber = true

vim.opt.tabstop = 4 -- tabs
vim.opt.shiftwidth = 4

vim.opt.mouse = 'a' -- Enable mouse mode, can be useful for resizing splits for example!

vim.opt.showmode = false -- Don't show the mode, since it's already in the status line

vim.schedule(function()
	vim.opt.clipboard = 'unnamedplus' --  Remove this option if you want your OS clipboard to remain independent. See `:help 'clipboard'`
end)

vim.opt.breakindent = true -- Enable break indent

vim.opt.undofile = true -- Save undo history

vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes' -- Keep signcolumn on by default

vim.opt.updatetime = 250 -- Decrease update time

vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time

vim.opt.splitright = true -- Configure how new splits should be opened
vim.opt.splitbelow = true

vim.opt.list = true --  See `:help 'list'`
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' } --  and `:help 'listchars'`

vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!

vim.opt.cursorline = true -- Show which line your cursor is on

vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

vim.keymap.set('n', '<leader>x', function()
	local ft = vim.bo.filetype
	vim.cmd 'redraw!'
	if ft == 'python' then
		vim.cmd '!python3 %'
	elseif ft == 'rust' then
		vim.cmd '!cargo run'
	else
		print 'No run command for this filetype'
	end
end, { noremap = true, silent = true })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- Clear highlights on search when pressing <Esc> in normal mode See `:help hlsearch`

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
	if vim.v.shell_error ~= 0 then
		error('Error cloning lazy.nvim:\n' .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
	-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
	-- NOTE: enable sleuth if you want whitespaces instead of tabs for some reason
	-- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
	{
		'rebelot/kanagawa.nvim',
		lazy = false,
		priority = 1000,
		-- configuration is optional!
		opts = {
			-- your settings here
		},
		init = function()
			-- vim.cmd.colorscheme 'ashen'
			vim.cmd.colorscheme 'kanagawa'
			-- vim.cmd.colorscheme 'lucy'
		end,
	},
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		},
	},
	{ -- Useful plugin to show you pending keybinds.
		'folke/which-key.nvim',
		event = 'VimEnter', -- Sets the loading event to 'VimEnter'
		opts = {
			delay = 0,
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = '<Up> ',
					Down = '<Down> ',
					Left = '<Left> ',
					Right = '<Right> ',
					C = '<C-…> ',
					M = '<M-…> ',
					D = '<D-…> ',
					S = '<S-…> ',
					CR = '<CR> ',
					Esc = '<Esc> ',
					ScrollWheelDown = '<ScrollWheelDown> ',
					ScrollWheelUp = '<ScrollWheelUp> ',
					NL = '<NL> ',
					BS = '<BS> ',
					Space = '<Space> ',
					Tab = '<Tab> ',
					F1 = '<F1>',
					F2 = '<F2>',
					F3 = '<F3>',
					F4 = '<F4>',
					F5 = '<F5>',
					F6 = '<F6>',
					F7 = '<F7>',
					F8 = '<F8>',
					F9 = '<F9>',
					F10 = '<F10>',
					F11 = '<F11>',
					F12 = '<F12>',
				},
			},

			-- Document existing key chains
			spec = {
				{ '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
				{ '<leader>d', group = '[D]ocument' },
				{ '<leader>r', group = '[R]ename' },
				{ '<leader>s', group = '[S]earch' },
				{ '<leader>w', group = '[W]orkspace' },
				{ '<leader>t', group = '[T]oggle' },
				{ '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
			},
		},
	},

	{ -- Fuzzy Finder (files, lsp, etc)
		'nvim-telescope/telescope.nvim',
		event = 'VimEnter',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
			{ 'nvim-telescope/telescope-ui-select.nvim' },
			{ 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
		},
		config = function()
			require('telescope').setup {
				extensions = {
					['ui-select'] = {
						require('telescope.themes').get_dropdown(),
					},
				},
			}
			pcall(require('telescope').load_extension, 'fzf')
			pcall(require('telescope').load_extension, 'ui-select')

			local builtin = require 'telescope.builtin'
			vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
			vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
			vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
			vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
			vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
			vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
			vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
			vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
			vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

			vim.keymap.set('n', '<leader>/', function()
				builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
					winblend = 10,
					previewer = false,
				})
			end, { desc = '[/] Fuzzily search in current buffer' })

			vim.keymap.set('n', '<leader>s/', function()
				builtin.live_grep {
					grep_open_files = true,
					prompt_title = 'Live Grep in Open Files',
				}
			end, { desc = '[S]earch [/] in Open Files' })

			vim.keymap.set('n', '<leader>sn', function()
				builtin.find_files { cwd = vim.fn.stdpath 'config' }
			end, { desc = '[S]earch [N]eovim files' })
		end,
	},

	-- LSP Plugins
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ 'williamboman/mason.nvim', opts = {} },
			'williamboman/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim',

			-- Useful status updates for LSP
			{ 'j-hui/fidget.nvim', opts = {} },

			-- Allows extra capabilities provided by nvim-cmp
			'hrsh7th/cmp-nvim-lsp',
		},
		config = function()
			-- Set up Mason before anything else
			require('mason').setup()
			require('mason-lspconfig').setup {
				ensure_installed = {
					'rust_analyzer', -- Rust
					'pyright', -- Python
					'lua_ls', -- Lua
					'ts_ls', -- TypeScript
				},
				automatic_installation = true,
			}

			-- Also ensure formatters and linters are installed
			require('mason-tool-installer').setup {
				ensure_installed = {
					'stylua', -- Lua formatter
					'black', -- Python formatter
					'ruff', -- Python linter
					'prettier', -- TypeScript formatter
					'eslint_d', -- TypeScript linter
					'rustfmt', -- Rust formatter
				},
			}

			-- LSP settings
			local lspconfig = require 'lspconfig'
			local capabilities = require('cmp_nvim_lsp').default_capabilities()

			-- Global mappings
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
					-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
					vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set('n', '<leader>wl', function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
					vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
					vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
				end,
			})

			-- Setup each language server

			-- Rust
			lspconfig.rust_analyzer.setup {
				capabilities = capabilities,
				settings = {
					['rust-analyzer'] = {
						checkOnSave = {
							command = 'clippy',
						},
						-- avoid locks on windows
						cargo = {
							targetDir = 'target/analyzer',
						},
					},
				},
			}

			-- Python
			lspconfig.pyright.setup {
				capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = 'workspace',
						},
					},
				},
			}

			-- Lua
			lspconfig.lua_ls.setup {
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = 'LuaJIT',
						},
						diagnostics = {
							globals = { 'vim' },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file('', true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			}
			-- TypeScript
			lspconfig.ts_ls.setup {
				on_attach = function(client, bufnr)
					-- Set up keybindings here for TypeScript
					local opts = { noremap = true, silent = true }
					vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
					vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
					vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
				end,
				settings = {
					documentFormatting = true,
				},
			}

			-- Update the "formatters_by_ft" in the conform.nvim configuration
			local conform = require 'conform'
			conform.setup {
				formatters_by_ft = {
					lua = { 'stylua' },
					python = { 'black', 'ruff' },
					javascript = { 'prettier' },
					typescript = { 'prettier' },
					typescriptreact = { 'prettier' },
					rust = { 'rustfmt' },
				},
			}
		end,
	},

	{
		'folke/lazydev.nvim',
		ft = 'lua',
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = 'luvit-meta/library', words = { 'vim%.uv' } },
			},
		},
	},
	{ 'Bilal2453/luvit-meta', lazy = true },
	{ -- Autoformat
		'stevearc/conform.nvim',
		event = { 'BufWritePre' },
		cmd = { 'ConformInfo' },
		keys = {
			{
				'<leader>f',
				function()
					require('conform').format { async = true, lsp_format = 'fallback' }
				end,
				mode = '',
				desc = '[F]ormat buffer',
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				local lsp_format_opt
				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = 'never'
				else
					lsp_format_opt = 'fallback'
				end
				return {
					timeout_ms = 500,
					lsp_format = lsp_format_opt,
				}
			end,
			formatters_by_ft = {
				lua = { 'stylua' },
			},
		},
	},
	{ -- Autocompletion
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				'L3MON4D3/LuaSnip',
				build = (function()
					if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
						return
					end
					return 'make install_jsregexp'
				end)(),
				dependencies = {},
			},
			'saadparwaiz1/cmp_luasnip',

			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
		},
		config = function()
			-- See `:help cmp`
			local cmp = require 'cmp'
			local luasnip = require 'luasnip'
			luasnip.config.setup {}

			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = 'menu,menuone,noinsert' },

				mapping = cmp.mapping.preset.insert {
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-y>'] = cmp.mapping.confirm { select = true },
					['<C-Space>'] = cmp.mapping.complete {},
					['<C-l>'] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { 'i', 's' }),
					['<C-h>'] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { 'i', 's' }),
				},
				sources = {
					{
						name = 'lazydev',
						group_index = 0,
					},
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'path' },
				},
			}
		end,
	},

	-- Highlight todo, notes, etc in comments
	{ 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

	{ -- Collection of various small independent plugins/modules
		'echasnovski/mini.nvim',
		config = function()
			require('mini.ai').setup { n_lines = 500 }
			require('mini.surround').setup()
			local statusline = require 'mini.statusline'
			statusline.setup { use_icons = vim.g.have_nerd_font }
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return '%2l:%-2v'
			end

			-- ... and there is more!
			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},
	{ -- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		main = 'nvim-treesitter.configs', -- Sets main module to use for opts
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { 'ruby' },
			},
			indent = { enable = true, disable = { 'ruby' } },
		},
		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	},

	-- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
	-- init.lua. If you want these files, they are in the repository, so you can just download them and
	-- place them in the correct locations.

	-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
	--
	--  Here are some example plugins that I've included in the Kickstart repository.
	--  Uncomment any of the lines below to enable them (you will need to restart nvim).
	--
	-- require 'kickstart.plugins.debug',
	-- require 'kickstart.plugins.indent_line',
	-- require 'kickstart.plugins.lint',
	-- require 'kickstart.plugins.autopairs',
	require 'kickstart.plugins.neo-tree',
	-- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

	-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    This is the easiest way to modularize your config.
	--
	--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	-- { import = 'custom.plugins' },
	--
	-- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
	-- Or use telescope!
	-- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
	-- you can continue same window with `<space>sr` which resumes last telescope search
}, {
		ui = {
			-- If you are using a Nerd Font: set icons to an empty table which will use the
			-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
			icons = vim.g.have_nerd_font and {} or {
				cmd = '⌘',
				config = '🛠',
				event = '📅',
				ft = '📂',
				init = '⚙',
				keys = '🗝',
				plugin = '🔌',
				runtime = '💻',
				require = '🌙',
				source = '📄',
				start = '🚀',
				task = '📌',
				lazy = '💤 ',
			},
		},
	})

-- iso no keyboard :ToggleCustomKeymaps

-- Toggle flag
vim.g.custom_key_remaps_enabled = true

-- Function to apply key mappings if enabled
local function apply_custom_keymaps()
	if vim.g.custom_key_remaps_enabled then
		vim.api.nvim_set_keymap('i', '¤', '$', { noremap = true })
		vim.api.nvim_set_keymap('i', 'å', '{', { noremap = true })
		vim.api.nvim_set_keymap('i', 'æ', '}', { noremap = true })
		vim.api.nvim_set_keymap('i', 'Å', '[', { noremap = true })
		vim.api.nvim_set_keymap('i', 'Æ', ']', { noremap = true })
		vim.api.nvim_set_keymap('i', 'ø', ':', { noremap = true })
		vim.api.nvim_set_keymap('i', 'Ø', ';', { noremap = true })

		vim.api.nvim_set_keymap('n', '¤', '$', { noremap = true })
		vim.api.nvim_set_keymap('n', 'å', '{', { noremap = true })
		vim.api.nvim_set_keymap('n', 'æ', '}', { noremap = true })
		vim.api.nvim_set_keymap('n', 'Å', '[', { noremap = true })
		vim.api.nvim_set_keymap('n', 'Æ', ']', { noremap = true })
		vim.api.nvim_set_keymap('n', 'ø', ':', { noremap = true })
		vim.api.nvim_set_keymap('n', 'Ø', ';', { noremap = true })

		vim.api.nvim_set_keymap('v', '¤', '$', { noremap = true })
		vim.api.nvim_set_keymap('v', 'å', '{', { noremap = true })
		vim.api.nvim_set_keymap('v', 'æ', '}', { noremap = true })
		vim.api.nvim_set_keymap('v', 'Å', '[', { noremap = true })
		vim.api.nvim_set_keymap('v', 'Æ', ']', { noremap = true })
		vim.api.nvim_set_keymap('v', 'ø', ':', { noremap = true })
		vim.api.nvim_set_keymap('v', 'Ø', ';', { noremap = true })
	else
		-- Clear mappings
		vim.api.nvim_del_keymap('i', '¤')
		vim.api.nvim_del_keymap('i', 'å')
		vim.api.nvim_del_keymap('i', 'æ')
		vim.api.nvim_del_keymap('i', 'Å')
		vim.api.nvim_del_keymap('i', 'Æ')
		vim.api.nvim_del_keymap('i', 'ø')
		vim.api.nvim_del_keymap('i', 'Ø')

		vim.api.nvim_del_keymap('n', '¤')
		vim.api.nvim_del_keymap('n', 'å')
		vim.api.nvim_del_keymap('n', 'æ')
		vim.api.nvim_del_keymap('n', 'Å')
		vim.api.nvim_del_keymap('n', 'Æ')
		vim.api.nvim_del_keymap('n', 'ø')
		vim.api.nvim_del_keymap('n', 'Ø')
	end
end

-- Apply key mappings on startup
apply_custom_keymaps()

-- Command to toggle mappings on the fly
vim.api.nvim_create_user_command('ToggleCustomKeymaps', function()
	vim.g.custom_key_remaps_enabled = not vim.g.custom_key_remaps_enabled
	apply_custom_keymaps()
	print('Custom key mappings ' .. (vim.g.custom_key_remaps_enabled and 'enabled' or 'disabled'))
end, {})

-- Move lines up and down with Alt+j/k
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { silent = true })
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { silent = true })
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { silent = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { silent = true })

--
vim.keymap.set('i', '¨', '<Esc>', { noremap = true })
vim.keymap.set('v', '¨', '<Esc>', { noremap = true })
vim.keymap.set('n', '¨', '<Esc>', { noremap = true })

vim.keymap.set('n', '<leader>t', ':Neotree toggle<CR>', { noremap = true, silent = true })

-- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
vim.keymap.set('n', 'K', function()
	vim.lsp.buf.hover()
	-- Wait a tiny bit for the hover window to open, then set the mapping
	vim.defer_fn(function()
		local hover_buf = vim.api.nvim_get_current_buf()
		vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = hover_buf })
	end, 10)
end, { buffer = bufnr })
