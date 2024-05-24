---@diagnostic disable: unused-local
local cmd = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local api = require("binary-peek.api")
local M = {}

local create_cmds = function()
	cmd("BinaryPeek", function(opts)
		local arg = opts.fargs[1]

		if not arg then
			if api.get_status() then
				api.search_stop()
			else
				api.search_start()
			end
		else
			if arg == "start" then
				if not api.status then
					api.search_start()
				else
					print("BinarySearchPeek has already started")
				end
			elseif arg == "stop" then
				if api.status then
					api.search_stop()
				else
					print("BinarySearchPeek is already stopped")
				end
			elseif arg == "abort" then
				if api.status then
					api.search_abort()
				else
					print("BinarySearchPeek is already stopped")
				end
			elseif arg == "undo" then
				if api.status then
					print("BinarySearchPeek: Unimplemented")
					-- api.undo_step()
				else
					print("BinarySearchPeek is stopped")
				end
			elseif arg == "redo" then
				if api.status then
					print("BinarySearchPeek: Unimplemented")
					-- api.redo_step()
				else
					print("BinarySearchPeek is stopped")
				end
			elseif arg == "down" then
				if api.status then
					api.search_down()
				else
					print("BinarySearchPeek is stopped")
				end
			elseif arg == "up" then
				if api.status then
					api.search_up()
				else
					print("BinarySearchPeek is stopped")
				end
			end
		end
	end, {
		desc = "Start BinarySearchPeek",
		nargs = "?",
		complete = function(ArgLead, CmdLine, CursorPos)
			return { "start", "stop", "abort", "undo", "redo", "down", "up" }
		end,
	})
end

local create_autocmds = function()
	autocmd("User", {
		desc = "Add keymaps to current buffer on BinaryPeek start",
		pattern = "BinPeekStart",
		group = augroup("BinaryPeekKeymaps", { clear = true }),
		callback = function()
			local map = vim.api.nvim_buf_set_keymap

			map(0, "n", "k", "<cmd>BinaryPeek up<CR>", { desc = "BinaryPeek search left" })
			map(0, "n", "j", "<cmd>BinaryPeek down<CR>", { desc = "BinaryPeek search right" })
			map(0, "n", "x", "<cmd>BinaryPeek abort<CR>", { desc = "BinaryPeek search cancel" })
			map(0, "n", "q", "<cmd>BinaryPeek stop<CR>", { desc = "BinaryPeek search stop" })
			map(0, "n", "u", "<cmd>BinaryPeek undo<CR>", { desc = "BinaryPeek step undo" })
			map(0, "n", "r", "<cmd>BinaryPeek redo<CR>", { desc = "BinaryPeek step redo" })
		end,
	})

	autocmd("User", {
		desc = "Remove keymaps from current buffer on BinaryPeek stop",
		pattern = "BinPeekStop",
		group = augroup("BinaryPeekKeymaps", { clear = false }),
		callback = function()
			local del = vim.api.nvim_buf_del_keymap

			del(0, "n", "k")
			del(0, "n", "j")
			del(0, "n", "x")
			del(0, "n", "q")
			del(0, "n", "u")
			del(0, "n", "r")
		end,
	})
end

M.setup = function()
	-- TODO: add config to change default mappings
	create_cmds()
	create_autocmds()
end

return M
