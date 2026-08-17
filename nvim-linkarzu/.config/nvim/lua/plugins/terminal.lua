return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = { "ToggleTerm", "TermExec" },
		keys = {
			{ "<leader>T", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal: pływający" },
			{ "<leader>t", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal: poziomy split" },
			{ "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Terminal: pionowy split" },
		},
		opts = {
			-- Ctrl+\ przełącza (otwiera/chowa) ostatnio używany terminal z dowolnego miejsca,
			-- nawet z trybu wstawiania - bardzo wygodne przy szybkim odpaleniu np. `npm run dev`
			open_mapping = [[<C-\>]],
			direction = "float",
			float_opts = {
				border = "rounded",
			},
			shell = vim.o.shell,
			-- Zamyka okno terminala od razu po wyjściu z powłoki (exit code 0),
			-- zamiast zostawiać "martwy" bufor z napisem [Process exited 0]
			close_on_exit = true,
			start_in_insert = true,
			persist_size = true,
		},
	},
}
