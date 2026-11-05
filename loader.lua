local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/Codetaker56/VapeV4ForRoblox-fixed/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'newvape', 'newvape/games', 'newvape/profiles', 'newvape/assets', 'newvape/libraries', 'newvape/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not shared.VapeDeveloper then
	local _, subbed = pcall(function()
		return game:HttpGet('https://github.com/Codetaker56/VapeV4ForRoblox-fixed')
	end)

	local assetVer = '1'
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'

	if commit == 'main' or (isfile('newvape/profiles/commit.txt') and readfile('newvape/profiles/commit.txt') or '') ~= commit then
		wipeFolder('newvape')
		wipeFolder('newvape/games')
		wipeFolder('newvape/guis')
		wipeFolder('newvape/libraries')
	end

	if (isfile('newvape/profiles/asset.txt') and readfile('newvape/profiles/asset.txt') or '') ~= assetVer then
		wipeFolder('newvape/assets')
	end

	writefile('newvape/profiles/asset.txt', assetVer)
	writefile('newvape/profiles/commit.txt', commit)

	-- parallel asset prefetch (the GUI would otherwise fetch them one by one)
	local base = 'https://raw.githubusercontent.com/Codetaker56/VapeV4ForRoblox-fixed/'..commit..'/'
	local ok, list = pcall(game.HttpGet, game, base..'assets.txt', true)
	if ok and type(list) == 'string' and list ~= '404: Not Found' then
		if not isfolder('newvape/assets/new') then
			makefolder('newvape/assets/new')
		end
		local pending = 0
		for path in list:gmatch('[^%c]+') do
			local dest = 'newvape/'..path
			if not isfile(dest) then
				pending += 1
				task.spawn(function()
					local suc, res = pcall(game.HttpGet, game, base..path, true)
					if suc and type(res) == 'string' and res ~= '' and res ~= '404: Not Found' then
						writefile(dest, res)
					end
					pending -= 1
				end)
			end
		end
		local started = os.clock()
		while pending > 0 and os.clock() - started < 120 do
			task.wait(0.1)
		end
	end
end

return loadstring(downloadFile('newvape/main.lua'), 'main')()