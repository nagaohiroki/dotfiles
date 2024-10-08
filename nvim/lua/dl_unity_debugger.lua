local M = {}
local function dl_debugger(tbl)
	if vim.fn.has('python3') == 0 then
		return
	end
	local json = vim.fn.json_encode(tbl)
	local py = vim.fn.fnameescape(vim.fn.stdpath('config') .. '/python3/dl_unity_debugger.py')
	vim.cmd('py3 sys.argv = [\'' .. json .. '\']')
	vim.cmd('py3file ' .. py)
	vim.notify('download\n' .. json)
end
M.dl_vstuc = function()
	dl_debugger({
		url =
		"https://marketplace.visualstudio.com/_apis/public/gallery/publishers/VisualStudioToolsForUnity/vsextensions/vstuc/1.0.4/vspackage",
		out = vim.fn.fnameescape(vim.fn.stdpath('data') .. '/vstuc')
	})
end
M.dl_unity_debugger = function()
	dl_debugger({
		url =
		"https://marketplace.visualstudio.com/_apis/public/gallery/publishers/deitry/vsextensions/unity-debug/3.0.11/vspackage",
		out = vim.fn.fnameescape(vim.fn.stdpath('data') .. '/unity-debug')
	})
end

return M
