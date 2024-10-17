local M = {}
local function find_probe()
	local vstuc_path = vim.fn.fnameescape(vim.fn.stdpath('data') .. '/vstuc/extension/bin')
	local system_obj = vim.system({ 'dotnet', vstuc_path .. '/UnityAttachProbe.dll' }, { text = true })
	local probe_result = system_obj:wait(2000).stdout
	if probe_result == nil or #probe_result == 0 then
		print('No endpoint found (is unity running?)')
		return nil
	end
	for json in vim.gsplit(probe_result, '\n') do
		if json ~= '' then
			local probe = vim.json.decode(json)
			for _, p in pairs(probe) do
				if p.isBackground == false then
					return p
				end
			end
		end
	end
	return nil
end
local function request(tbl)
	local probe = find_probe()
	if probe == nil then
		vim.print('not find unity endpoint')
		return
	end
	local uv = vim.uv
	local udp = uv.new_udp()
	local json = vim.fn.json_encode(tbl)
	uv.udp_send(udp, json, probe.address, probe.messagerPort, function(err)
		if err then
			print('error:', err)
		else
			uv.close(udp)
		end
	end)
	uv.run()
end
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
function M.setup()
	local functionTbl = {
		'Refresh',
		'Play',
		'Pause',
		'Stop',
	}
	for _, v in ipairs(functionTbl) do
		vim.api.nvim_create_user_command('Unity' .. v, function()
			request({ Type = v, Value = '' })
		end, {})
	end
	local vstuc = {
		url =
		'https://marketplace.visualstudio.com/_apis/public/gallery/publishers/VisualStudioToolsForUnity/vsextensions/vstuc/1.0.4/vspackage',
		out = vim.fn.fnameescape(vim.fn.stdpath('data') .. '/vstuc'),
	}
	-- old debugger
	-- local unity_debugger = {
	-- 	url =
	-- 	'https://marketplace.visualstudio.com/_apis/public/gallery/publishers/deitry/vsextensions/unity-debug/3.0.11/vspackage',
	-- 	out = vim.fn.fnameescape(vim.fn.stdpath('data') .. '/unity-debug')
	-- }
	vim.api.nvim_create_user_command('VstucInstall', function() dl_debugger(vstuc) end, {})
end

return M
