local M = {}

local function get_editor_instance_json()
	local path = vim.fn.expand('%:p')
	while true do
		local new_path = vim.fn.fnamemodify(path, ':h')
		if new_path == path then
			print('Not found EditorInstance.json')
			return ''
		end
		path = new_path
		local editor_instance = vim.fn.glob(path .. '/Library/EditorInstance.json')
		if editor_instance ~= '' then
			return editor_instance
		end
	end
end
local function get_process_id()
	local editor_instance = get_editor_instance_json()
	if editor_instance == '' then
		return nil
	end
	local file = io.open(editor_instance, 'r')
	if file == nil then
		return nil
	end
	local text = file:read('a')
	local json = vim.json.decode(text)
	file:close()
	return json.process_id
end
local function unity_debugger_port()
	local process_id = get_process_id()
	if process_id == nil then
		return nil
	end
	return 56000 + (process_id % 1000)
end
local function unity_message_port()
	local debugger_port = unity_debugger_port()
	if debugger_port == nil then
		return nil
	end
	return debugger_port + 2
end
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
	-- not required UnityAttachProbe.dll. but it's slow
	-- local messager_port = unity_message_port()
	-- if messager_port == nil then
	-- 	return
	-- end
	local uv = vim.uv
	local udp = uv.new_udp()
	local json = vim.fn.json_encode(tbl)
	-- uv.udp_send(udp, json, '127.0.0.1', messager_port, function(err)
	uv.udp_send(udp, json, probe.address, probe.messagerPort, function(err)
		if err then
			print('error:', err)
		else
			uv.close(udp)
		end
	end)
	uv.run()
end

local function download_debugger(dir, url)
	if vim.fn.isdirectory(dir) == 1 then
		vim.print('vstuc already downloaded ' .. dir)
		return
	end
	local out = dir .. '/tmp.zip'
	vim.fn.mkdir(dir, 'p')
	vim.system({ 'curl', '--compressed', '-L', url, '-o', out }, { text = true }, function(_)
		vim.print('done download')
		vim.print('start extract')
		vim.system({ 'tar', 'xf', out, '-C', dir }, { text = true }, function(_)
			vim.print('done extract')
		end)
	end)
end

function M.setup()
	local functionTbl = {
		'Refresh',
		'Play',
		'Pause',
		'Unpause',
		'Stop',
	}
	for _, v in ipairs(functionTbl) do
		vim.api.nvim_create_user_command('U' .. v, function()
			request({ Type = v, Value = '' })
		end, {})
	end
	vim.api.nvim_create_user_command('InstallUnityDebugger', function()
		download_debugger(vim.fn.fnameescape(vim.fn.stdpath('data') .. '/vstuc'),
			'https://marketplace.visualstudio.com/_apis/public/gallery/publishers/VisualStudioToolsForUnity/vsextensions/vstuc/1.0.4/vspackage')
	end, {})
	vim.api.nvim_create_user_command('InstallUnityDebuggerOld', function()
		download_debugger(vim.fn.fnameescape(vim.fn.stdpath('data') .. '/unity-debug'),
			'https://marketplace.visualstudio.com/_apis/public/gallery/publishers/deitry/vsextensions/unity-debug/3.0.11/vspackage')
	end, {})
end

return M
