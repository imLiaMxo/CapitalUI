Capital = {}
Capital.UI = {}
Capital.UI.Version = "0.1-pa"



hook.Add("Think", "Capital.UI.VersionChecker", function()
	hook.Remove("Think", "Capital.UI.VersionChecker")

	http.Fetch("VER URL", function(body)
		if Capital.UI.Version ~= string.Trim(body) then
			local red = Color(192, 27, 27)

			MsgC(red, "[Capital UI] There is an update available, please download it at: UPDATE HERE\n")
			MsgC(red, "\nYour version: " .. Capital.UI.Version .. "\n")
			MsgC(red, "New  version: " .. body .. "\n")
			return
		end
	end)
end)