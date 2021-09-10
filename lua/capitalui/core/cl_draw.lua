local progressMat

local drawProgressWheel
local setMaterial = surface.SetMaterial
local setDrawColor = surface.SetDrawColor

do
    local min = math.min
    local curTime = CurTime
    local drawTexturedRectRotated = surface.DrawTexturedRectRotated

    function Capital.UI.DrawProgressWheel(x, y, w, h, col)
        local progSize = min(w, h)
        setMaterial(progressMat)
        setDrawColor(col.r, col.g, col.b, col.a)
        drawTexturedRectRotated(x + w * .5, y + h * .5, progSize, progSize, -curTime() * 100)
    end
    drawProgressWheel = Capital.UI.DrawProgressWheel
end

local materials = {}
local grabbingMaterials = {}

local getImgur = Capital.GetImgur
getImgur(Capital.UI.ImgurLoader, function(mat)
    progressMat = mat
end)

local drawTexturedRect = surface.DrawTexturedRect
function Capital.UI.DrawImgur(x, y, w, h, imgurId, col)
    if not materials[imgurId] then
        drawProgressWheel(x, y, w, h, col)

        if grabbingMaterials[imgurId] then return end
        grabbingMaterials[imgurId] = true

        getImgur(imgurId, function(mat)
            materials[imgurId] = mat
            grabbingMaterials[imgurId] = nil
        end)

        return
    end

    setMaterial(materials[imgurId])
    setDrawColor(col.r, col.g, col.b, col.a)
    drawTexturedRect(x, y, w, h)
end

local drawTexturedRectRotated = surface.DrawTexturedRectRotated
function Capital.UI.DrawImgurRotated(x, y, w, h, rot, imgurId, col)
    if not materials[imgurId] then
        drawProgressWheel(x - w * .5, y - h * .5, w, h, col)

        if grabbingMaterials[imgurId] then return end
        grabbingMaterials[imgurId] = true

        getImgur(imgurId, function(mat)
            materials[imgurId] = mat
            grabbingMaterials[imgurId] = nil
        end)

        return
    end

    setMaterial(materials[imgurId])
    setDrawColor(col.r, col.g, col.b, col.a)
    drawTexturedRectRotated(x, y, w, h, rot)
end