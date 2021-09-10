local PANEL = {}

AccessorFunc(PANEL, "IsToggle", "IsToggle", FORCE_BOOL)
AccessorFunc(PANEL, "Toggle", "Toggle", FORCE_BOOL)

function PANEL:Init()
    self:SetIsToggle(false)
    self:SetToggle(false)
    self:SetMouseInputEnabled(true)

    self:SetCursor("hand")

    local btnSize = 30
    self:SetSize(btnSize, btnSize)

    self.NormalCol = Capital.UI.CopyColor(Capital.UI.Colors.Primary)
    self.HoverCol = Capital.UI.OffsetColor(self.NormalCol, -15)
    self.ClickedCol = Capital.UI.OffsetColor(self.NormalCol, 15)
    self.DisabledCol = Capital.UI.CopyColor(Capital.UI.Colors.Disabled)

    self.BackgroundCol = self.NormalCol
end

function PANEL:DoToggle(...)
    if not self:GetIsToggle() then return end

    self:SetToggle(not self:GetToggle())
    self:OnToggled(self:GetToggle(), ...)
end

local localPly
function PANEL:OnMousePressed(mouseCode)
    if not self:IsEnabled() then return end

    if not localPly then
        localPly = LocalPlayer()
    end

    if self:IsSelectable() and mouseCode == MOUSE_LEFT and (input.IsShiftDown() or input.IsControlDown()) and not (localPly:KeyDown(IN_FORWARD) or localPly:KeyDown(IN_BACK) or localPly:KeyDown(IN_MOVELEFT) or localPly:KeyDown(IN_MOVERIGHT)) then
        return self:StartBoxSelection()
    end

    self:MouseCapture(true)
    self.Depressed = true
    self:OnPressed(mouseCode)

    self:DragMousePress(mouseCode)
end

function PANEL:OnMouseReleased(mouseCode)
    self:MouseCapture(false)

    if not self:IsEnabled() then return end
    if not self.Depressed and dragndrop.m_DraggingMain ~= self then return end

    if self.Depressed then
        self.Depressed = nil
        self:OnReleased(mouseCode)
    end

    if self:DragMouseRelease(mouseCode) then
        return
    end

    if self:IsSelectable() and mouseCode == MOUSE_LEFT then
        local canvas = self:GetSelectionCanvas()
        if canvas then
            canvas:UnselectAll()
        end
    end

    if not self.Hovered then return end

    self.Depressed = true

    if mouseCode == MOUSE_RIGHT then
        self:DoRightClick()
    elseif mouseCode == MOUSE_LEFT then
        self:DoClick()
    elseif mouseCode == MOUSE_MIDDLE then
        self:DoMiddleClick()
    end

    self.Depressed = nil
end

function PANEL:PaintExtra(w, h) end

function PANEL:Paint(w, h)
    if not self:IsEnabled() then
        draw.RoundedBox(4, 0, 0, w, h, self.DisabledCol)
        self:PaintExtra(w, h)
        return
    end

    local bgCol = self.NormalCol

    if self:IsDown() or self:GetToggle() then
        bgCol = self.ClickedCol
    elseif self:IsHovered() then
        bgCol = self.HoverCol
    end

    self.BackgroundCol = Capital.UI.LerpColor(FrameTime() * 12, self.BackgroundCol, bgCol)

    draw.RoundedBox(4, 0, 0, w, h, self.BackgroundCol)

    self:PaintExtra(w, h)
end

function PANEL:IsDown() return self.Depressed end
function PANEL:OnPressed(mouseCode) end
function PANEL:OnReleased(mouseCode) end
function PANEL:OnToggled(enabled) end
function PANEL:DoClick(...) self:DoToggle(...) end
function PANEL:DoRightClick() end
function PANEL:DoMiddleClick() end

vgui.Register("Capital.UI.Button", PANEL, "Panel")

PANEL = {}

AccessorFunc(PANEL, "Text", "Text", FORCE_STRING)
AccessorFunc(PANEL, "TextAlign", "TextAlign", FORCE_NUMBER)
AccessorFunc(PANEL, "TextSpacing", "TextSpacing", FORCE_NUMBER)
AccessorFunc(PANEL, "Font", "Font", FORCE_STRING)

function PANEL:Init()
    self:SetText("Button")
    self:SetTextAlign(TEXT_ALIGN_CENTER)
    self:SetTextSpacing(6)
    self:SetFont("Capital.Font.22")

    self:SetSize(100,30)
end

function PANEL:SizeToText()
    self:SetSize(surface.GetTextSize(self:GetText()) + 14, 30)
end

function PANEL:PaintExtra(w, h)
    local textAlign = self:GetTextAlign()
    local textX = (textAlign == TEXT_ALIGN_CENTER and w / 2) or (textAlign == TEXT_ALIGN_RIGHT and w - self:GetTextSpacing()) or self:GetTextSpacing()

    if not self:IsEnabled() then
        draw.SimpleText(self:GetText(), self:GetFont(), textX, h / 2, Capital.UI.Colors.DisabledText, textAlign, TEXT_ALIGN_CENTER)
        return
    end

    draw.SimpleText(self:GetText(), self:GetFont(), textX, h / 2, Capital.UI.Colors.PrimaryText, textAlign, TEXT_ALIGN_CENTER)
end

vgui.Register("Capital.UI.TextButton", PANEL, "Capital.UI.Button")