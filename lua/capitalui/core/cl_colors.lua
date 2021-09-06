do
    local format = string.format
    function Capital.UI.DecToHex(dec, zeros)
        return format("%0" .. (zeros or 2) .. "x", dec)
    end

    local max = math.max
    local min = math.min
    function Capital.UI.ColorToHex(color)
        return format("#%02X%02X%02X",
            max(min(color.r, 255), 0),
            max(min(color.g, 255), 0),
            max(min(color.b, 255), 0)
        )
    end
end

function Capital.UI.ColorToHSL(col)
    local r = col.r / 255
    local g = col.g / 255
    local b = col.b / 255
    local max, min = math.max(r, g, b), math.min(r, g, b)
    b = max + min

    local h = b / 2
    if max == min then return 0, 0, h end

    local s, l = h, h
    local d = max - min
    s = l > .5 and d / (2 - b) or d / b

    if max == r then
        h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
        h = (b - r) / d + 2
    elseif max == b then
        h = (r - g) / d + 4
    end

    return h * .16667, s, l
end

local createColor = Color
do
    local function hueToRgb(p, q, t)
        if t < 0 then t = t + 1 end
        if t > 1 then t = t - 1 end
        if t < 1 / 6 then return p + (q - p) * 6 * t end
        if t < 1 / 2 then return q end
        if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
        return p
    end

    function Capital.UI.HSLToColor(h, s, l, a)
        local r, g, b
        local t = h / (2 * math.pi)

        if s == 0 then
            r, g, b = l, l, l
        else
            local q
            if l < 0.5 then
                q = l * (1 + s)
            else
                q = l + s - l * s
            end

            local p = 2 * l - q
            r = hueToRgb(p, q, t + 1 / 3)
            g = hueToRgb(p, q, t)
            b = hueToRgb(p, q, t - 1 / 3)
        end

        return createColor(r * 255, g * 255, b * 255, (a or 1) * 255)
    end
end

function Capital.UI.CopyColor(col)
    return createColor(col.r, col.g, col.b, col.a)
end

function Capital.UI.OffsetColor(col, offset)
    return createColor(col.r + offset, col.g + offset, col.b + offset)
end

do
    local match = string.match
    local tonumber = tonumber

    function Capital.UI.HexToColor(hex)
        local r, g, b = match(hex, "#(..)(..)(..)")
        return createColor(
            tonumber(r, 16),
            tonumber(g, 16),
            tonumber(b, 16)
        )
    end
end

do
    local curTime = CurTime
    local hsvToColor = HSVToColor

    local lastUpdate = 0
    local lastCol = createColor(0, 0, 0)

    function Capital.UI.GetRainbowColor()
        local time = curTime()
        if lastUpdate == time then return lastCol end

        lastUpdate = time
        lastCol = hsvToColor((time * 50) % 360, 1, 1)

        return lastCol
    end
end

do
    local colorToHSL = ColorToHSL

    function Capital.UI.IsColorLight(col)
        local _, _, lightness = colorToHSL(col)
        return lightness >= .5
    end
end

function Capital.UI.LerpColor(t, from, to)
    return createColor(from.r, from.g, from.b, from.a):Lerp(t, to)
end

function Capital.UI.IsColorEqualTo(from, to)
    return from.r == to.r and from.g == to.g and from.b == to.b and from.a == to.a
end

local colorMeta = FindMetaTable("Color")
colorMeta.Copy = Capital.UI.CopyColor
colorMeta.IsLight = Capital.UI.IsColorLight
colorMeta.EqualTo = Capital.UI.IsColorEqualTo

function colorMeta:Offset(offset)
    self.r = self.r + offset
    self.g = self.g + offset
    self.b = self.b + offset
    return self
end

local lerp = Lerp
function colorMeta:Lerp(t, to)
    self.r = lerp(t, self.r, to.r)
    self.g = lerp(t, self.g, to.g)
    self.b = lerp(t, self.b, to.b)
    self.a = lerp(t, self.a, to.a)
    return self
end