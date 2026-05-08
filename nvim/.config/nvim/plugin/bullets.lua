return {
	"bullets-vim/bullets.vim",
	ft = { "markdown", "gitcommit" },
	init = function()
		vim.g.bullets_outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std-" }
		vim.g.bullets_delete_last_bullet_if_empty = 2

		vim.g.bullets_custom_mappings = {
			{ "imap", "<cr>", "<Plug>(bullets-newline)" },
			{ "nmap", "o", "<Plug>(bullets-newline)" },
			{ "inoremap", "<C-cr>", "<cr>" },

			{ "vmap", "gN", "<Plug>(bullets-renumber)" },
			{ "nmap", "gN", "<Plug>(bullets-renumber)" },

			{ "nmap", "gX", "<Plug>(bullets-toggle-checkbox)" },

			{ "imap", "<C-t>", "<Plug>(bullets-demote)" },
			{ "imap", "<Tab>", "<Plug>(bullets-demote)" },
			{ "nmap", ">>", "<Plug>(bullets-demote)" },
			{ "vmap", ">", "<Plug>(bullets-demote)" },
			{ "imap", "<C-d>", "<Plug>(bullets-promote)" },
			{ "imap", "<S-Tab>", "<Plug>(bullets-promote)" },
			{ "nmap", "<<", "<Plug>(bullets-promote)" },
			{ "vmap", "<", "<Plug>(bullets-promote)" },
		}
	end,
}
