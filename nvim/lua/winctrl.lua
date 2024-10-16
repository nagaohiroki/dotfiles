local M = {}
M.setup = function()
	local size = 200
	local function win_resize(map, width, height)
		vim.keymap.set('n', map, function() M.resize(width, height) end)
	end
	win_resize('<M-UP>', 0, -size)
	win_resize('<M-Down>', 0, size)
	win_resize('<M-Left>', -size, 0)
	win_resize('<M-Right>', size, 0)
end
local function execute_win(tbl)
	if vim.fn.has('python3') == 0 then
		return
	end
	local json = vim.fn.json_encode(tbl)
	local winctrl_py = vim.fn.fnameescape(vim.fn.stdpath('config') .. '/python3/winctrl.py')
	vim.cmd('py3 sys.argv = [\'' .. json .. '\']')
	vim.cmd('py3file ' .. winctrl_py)
end
M.activate_window = function(window)
	execute_win({ window = window, method = 'activate' })
end
M.activate = function()
	execute_win({ window = "NVIM", method = 'activate' })
end
M.resize = function(width, height)
	execute_win({ window = "NVIM", method = 'resize', width = width, height = height })
end
return M
