local materials = {}

file.CreateDir("capitalui")

function Capital.GetImgur(id, callback, useproxy, matSettings)
    if materials[id] then return callback(materials[id]) end

    if file.Exists("capitalui/" .. id .. ".png", "DATA") then
        materials[id] = Material("../data/capitalui/" .. id .. ".png", matSettings or "noclamp smooth mips")
        return callback(materials[id])
    end

    http.Fetch(useproxy and "https://proxy.duckduckgo.com/iu/?u=https://i.imgur.com" or "https://i.imgur.com/" .. id .. ".png",
        function(body, len, headers, code)
            if len > 2097152 then
                materials[id] = Material("nil")
                return callback(materials[id])
            end

            file.Write("capitalui/" .. id .. ".png", body)
            materials[id] = Material("../data/capitalui/" .. id .. ".png", matSettings or "noclamp smooth mips")

            return callback(materials[id])
        end,
        function(error)
            if useproxy then
                materials[id] = Material("nil")
                return callback(materials[id])
            end
            return Capital.GetImgur(id, callback, true)
        end
    )
end
