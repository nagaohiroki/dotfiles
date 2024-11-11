local M = {}

local function find_path(target)
	local path = vim.fn.expand('%:p')
	while true do
		local new_path = vim.fn.fnamemodify(path, ':h')
		if new_path == path then
			return ''
		end
		path = new_path
		local target_path = vim.fn.glob(path .. target)
		if target_path ~= '' then
			return target_path
		end
	end
end
local function find_ue_path(uproject)
	local game_user_settings = vim.env.LOCALAPPDATA .. '/EpicGamesLauncher/Saved/Config/Windows/GameUserSettings.ini'
	local file = io.open(game_user_settings, 'r')
	if file == nil then
		return nil
	end
	local engine_dir = ''
	for line in file:lines() do
		local install_location = '^DefaultAppInstallLocation='
		if string.find(line, install_location) == 1 then
			engine_dir = string.gsub(line, install_location, '')
			break
		end
	end
	file:close()
	local file_uproject = io.open(uproject, 'r')
	if file_uproject == nil then
		return nil
	end
	local text = file_uproject:read('a')
	file_uproject:close()
	local json = vim.json.decode(text)
	return engine_dir .. '/UE_' .. json.EngineAssociation
end
local function ue_build()
	local uproject = find_path('/*.uproject')
	local ue_dir = find_ue_path(uproject)
	local bat = ue_dir .. '/Engine/Build/BatchFiles/Build.bat'
	local prj = '-project=' .. uproject
	local sln = {
		bat,
		'-projectfiles',
		prj,
		'-game',
		'-engine'
	}
	local database = {
		bat,
		'-mode=GenerateClangDatabase',
		'-game',
		'-engine',
		prj,
		vim.fn.fnamemodify(uproject, ':t:r') .. 'Editor',
		'Development',
		'Win64',
		'-OutputDir=' .. vim.fn.fnamemodify(uproject, ':h'),
	}
	vim.print('generate..')
	vim.system(sln, nil, function(_)
		vim.system(database, nil, function(_)
			vim.print('done')
		end)
	end)
end
function M.setup()
	vim.api.nvim_create_user_command('UETest', function()
		ue_build()
	end, {})
end

return M
