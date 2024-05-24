---@diagnostic disable: undefined-field
local utils = require("binary-peek.utils")
local trigger_event = vim.api.nvim_exec_autocmds
local M = {}
local total_lines
local start_pos
local low
local mid
local high

-- TODO: implement cache
local undo_step = function() end
local redo_step = function() end

local reset_values = function()
	total_lines = nil
	start_pos = nil
	low = nil
	mid = nil
	high = nil
end

local go_to_line = function(line)
	vim.api.nvim_win_set_cursor(0, { line, start_pos and start_pos[2] or 1 })
end

local start_search = function()
	M.set_status(true)
	start_pos = vim.api.nvim_win_get_cursor(0)
	total_lines = vim.fn.line("$")
	low = 1
	high = total_lines
	mid = math.floor(total_lines / 2)
	go_to_line(mid)
	print("Low: " .. low .. "; Mid: " .. mid .. "; High: " .. high)
	utils.notify(" 👀", "BinaryPeek: Start search", vim.log.levels.INFO)
	trigger_event("User", { pattern = "BinPeekStart" })
end

local stop_search = function()
	M.set_status(false)
	reset_values()
	print(" ")
	utils.notify(" 🛑", "BinaryPeek: Stop search", vim.log.levels.WARN)
	trigger_event("User", { pattern = "BinPeekStop" })
end

local abort_search = function()
	M.set_status(false)
	if start_pos then
		go_to_line(start_pos[1])
	end
	reset_values()
	print(" ")
	utils.notify(" 🚫", "BinaryPeek: Abort search", vim.log.levels.ERROR)
	trigger_event("User", { pattern = "BinPeekStop" })
end

local search_left = function()
	high = mid
	local pivot = (high - (low - 1))
	mid = math.floor((pivot / 2) + low)
	go_to_line(mid)
	print("Low: " .. low .. "; Mid: " .. mid .. "; High: " .. high)
end

local search_right = function()
	low = mid
	local pivot = (high - (low - 1))
	mid = math.floor((pivot / 2) + low)
	go_to_line(mid)
	print("Low: " .. low .. "; Mid: " .. mid .. "; High: " .. high)
end

local get_status = function()
	return M.status
end

local set_status = function(new_status)
	M.status = new_status
end

M.status = false
M.get_status = get_status
M.set_status = set_status
M.undo_step = undo_step
M.redo_step = redo_step
M.search_up = search_left
M.search_down = search_right
M.search_start = start_search
M.search_stop = stop_search
M.search_abort = abort_search

return M
