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
M.activate = function()
	execute_win({ method = 'activate' })
end
M.resize = function(width, height)
	execute_win({ method = 'resize', width = width, height = height })
end
return M
