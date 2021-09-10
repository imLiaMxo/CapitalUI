Capital = {}
Capital.UI = {}
Capital.UI.Version = "0.2-pa"

// Auto Includer
function Capital.IncludeDirectory(dir)
    local files, folders = file.Find(dir .. "/*", "LUA")

    for _, file in ipairs(files) do
        local fileDir = dir.. "/" .. file

        if CLIENT then
            include(fileDir)
        else
            if file:StartWith("cl_") then
                AddCSLuaFile(fileDir)
                MsgC(Color(0,255,0), "[Capital UI] Loaded " .. fileDir .. " [CLIENT]\n")
            elseif file:StartWith("sh_") then
                AddCSLuaFile(fileDir)
                include(fileDir)
                MsgC(Color(229,255,0), "[Capital UI] Loaded " .. fileDir .. " [SHARED]\n")
            else
                include(fileDir)
                MsgC(Color(38,0,255), "[Capital UI] Loaded " .. fileDir .. " [SERVER]\n")
            end
        end
    end

    return files, folders
end

function Capital.LoadDirectory(path)
	local _, folders = Capital.IncludeDirectory(path)
	for _, folderName in ipairs(folders) do
		Capital.LoadDirectory(path .. "/" .. folderName)
	end
end

// Load CapitalUI folder.
Capital.LoadDirectory("capitalui")

// Once all is loaded, we run a hook to let everything else know we loaded.
hook.Run("Capital.UI.HasLoaded")



// Update Checker
hook.Add("Think", "Capital.UI.VersionChecker", function()
	hook.Remove("Think", "Capital.UI.VersionChecker")

	http.Fetch("https://raw.githubusercontent.com/imLiaMxo/CapitalUI/main/VERSION", function(body)
		if Capital.UI.Version ~= string.Trim(body) then
			local red = Color(192, 27, 27)

			MsgC(red, "[Capital UI] There is an update available.\n")
			MsgC(red, "\n[Capital UI] Your version: " .. Capital.UI.Version .. "\n")
			MsgC(red, "[Capital UI] New  version: " .. body .. "\n")
			return
		end
	end)
end)