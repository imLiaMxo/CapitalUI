local fontName = "Capital.Font."


function Capital.UI.GenerateFonts(font, start, finish)
    for i = start, finish do
        surface.CreateFont(fontName .. i, {
            font = font,
            size = i,
            weight = 30
        }
    end
end


Capital.UI.GenerateFonts("DermaLarge", 10, 50)