function CheckSingleton()
	local my_server = vim.fn.has('win32') == 1 and
		[[\\.\pipe\nvim-server]] or vim.env.HOME .. [[/.local/state/nvim/nvim226]]
	if my_server == vim.v.servername then
		return false
	end
	local result, _ = pcall(vim.fn.serverstart, my_server)
	if result then
		vim.fn.serverstop(vim.v.servername)
		return false
	end
	vim.o.swapfile = false
	vim.o.shada = ''
	vim.o.loadplugins = false
	vim.api.nvim_create_autocmd('VimEnter',
		{
			once = true,
			callback = function()
				local cmd = string.format(
					'"%s" --server "%s" --remote-send "<Esc>:lua require(\'singleton\').editFile([[%s]],%s,%s)<CR>"',
					vim.v.progpath, my_server, vim.api.nvim_buf_get_name(0), vim.fn.line('.'), vim.fn.col('.'))
				vim.cmd('enew')
				vim.fn.jobstart(cmd, { on_exit = function() vim.cmd('q') end })
			end
		})
	return true
end

function Foreground()
	if vim.g.GuiLoaded == 1 then
		vim.cmd('py3file ' .. vim.env.HOME .. '/dotfiles/scripts/foreground.py')
	end
end

function EditFile(fname, line, col)
	if fname == '' then
		vim.cmd('enew')
	else
		vim.cmd('edit ' .. fname)
		vim.fn.cursor(line, col)
	end
	Foreground()
end

return {
	singleton = CheckSingleton,
	editFile = EditFile
}
