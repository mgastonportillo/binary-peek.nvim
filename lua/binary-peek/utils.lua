local M = {}

M.notify = function(icon, msg, type)
	vim.notify.dismiss() ---@diagnostic disable-line
	vim.notify(msg, type, { icon = icon, timeout = 500, render = "compact" })
end

return M
