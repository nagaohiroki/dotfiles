local M = {}
local function execute_win(tbl)
	if vim.fn.has('python3') == 0 then
		return
	end
	local json = vim.fn.json_encode(tbl)
	local winctrl_py = vim.fn.fnameescape(vim.fn.stdpath('config') .. '/python3/winctrl.py')
	vim.cmd('py3 sys.argv = [\'' .. json .. '\']')
	vim.cmd('py3file ' .. winctrl_py)
end
local function resize(width, height)
	execute_win({ window = "NVIM", method = 'resize', width = width, height = height })
end
local function win_resize(map, width, height)
	vim.keymap.set('n', map, function() resize(width, height) end)
end
function M.activate(window)
	execute_win({ window = window, method = 'activate' })
end

function M.setup()
	local size = 200
	win_resize('<M-UP>', 0, -size)
	win_resize('<M-Down>', 0, size)
	win_resize('<M-Left>', -size, 0)
	win_resize('<M-Right>', size, 0)
end

return M
