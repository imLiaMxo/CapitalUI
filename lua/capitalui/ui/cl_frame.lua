// Frame+

local PANEL = {}

AccessorFunc(PANEL, "Draggable", "Draggable", FORCE_BOOL)
AccessorFunc(PANEL, "Sizable", "Sizable", FORCE_BOOL)
AccessorFunc(PANEL, "MinWidth", "MinWidth", FORCE_NUMBER)
AccessorFunc(PANEL, "MinHeight", "MinHeight", FORCE_NUMBER)
AccessorFunc(PANEL, "ScreenLock", "ScreenLock", FORCE_BOOL)
AccessorFunc(PANEL, "RemoveOnClose", "RemoveOnClose", FORCE_BOOL)

AccessorFunc(PANEL, "Title", "Title", FORCE_STRING)
AccessorFunc(PANEL, "ImgurID", "ImgurID", FORCE_STRING)

function PANEL:Init()
	self.CloseButton = vgui.Create("Capital.UI.ImgurButton", self)
	self.CloseButton:SetImgurID("z1uAU0b")
	self.CloseButton:SetNormalColor(Capital.UI.Colors.PrimaryText)
	self.CloseButton:SetHoverColor(Capital.UI.Colors.Negative)
	self.CloseButton:SetClickColor(Capital.UI.Colors.Negative)
	self.CloseButton:SetDisabledColor(Capital.UI.Colors.DisabledText)

	self.CloseButton.DoClick = function(s)
		self:Close()
	end

	self.ExtraButtons = {}

	self:SetTitle("Frame")

	self:SetDraggable(true)
	self:SetScreenLock(true)
	self:SetRemoveOnClose(true)

	local size = 200
	self:SetMinWidth(size)
	self:SetMinHeight(size)

	local oldMakePopup = self.MakePopup
	function self:MakePopup()
		oldMakePopup(self)
		self:Open()
	end
end

function PANEL:LayoutContent(w, h) end

function PANEL:PerformLayout(w, h)
	local headerH = 30
	local btnPad = 6
	local btnSpacing = 6

	if IsValid(self.CloseButton) then
		local btnSize = headerH * .45
		self.CloseButton:SetSize(btnSize, btnSize)
		self.CloseButton:SetPos(w - btnSize - btnPad, (headerH - btnSize) / 2)

		btnPad = btnPad + btnSize + btnSpacing
	end

	for _, btn in ipairs(self.ExtraButtons) do
		local btnSize = headerH * btn.HeaderIconSize
		btn:SetSize(btnSize, btnSize)
		btn:SetPos(w - btnSize - btnPad, (headerH - btnSize) / 2)
		btnPad = btnPad + btnSize + btnSpacing
	end

	if IsValid(self.SideBar) then
		self.SideBar:SetPos(0, headerH)
		self.SideBar:SetSize(200, h - headerH)
	end

	local padding = 6
	self:DockPadding(self.SideBar and 200 + padding or padding, headerH + padding, padding, padding)

	self:LayoutContent(w, h)
end

function PANEL:Open()
	self:SetAlpha(0)
	self:SetVisible(true)
	self:AlphaTo(255, .1, 0)
end

function PANEL:Close()
	self:AlphaTo(0, .1, 0, function(anim, pnl)
		if not IsValid(pnl) then return end
		pnl:SetVisible(false)
		pnl:OnClose()
		if pnl:GetRemoveOnClose() then pnl:Remove() end
	end)
end

function PANEL:OnClose() end

function PANEL:PaintHeader(x, y, w, h)
    draw.RoundedBoxEx(6, x, y, w, h, Capital.UI.Colors.Header, true, true)

	local imgurID = self:GetImgurID()
	if imgurID then
		local iconSize = h * .6
		Capital.UI.DrawImgur(6, x + (h - iconSize) / 2, y + iconSize, iconSize, imgurID, color_white)
		draw.SimpleText(self:GetTitle(), "Capital.Font.20", x + 12 + iconSize, y + h / 2, Capital.UI.Colors.PrimaryText, nil, TEXT_ALIGN_CENTER)
		return
	end

	local iconSize = h * .1
	draw.SimpleText(self:GetTitle(), "Capital.Font.20", x + 6 + iconSize, y + h / 2, Capital.UI.Colors.PrimaryText, nil, TEXT_ALIGN_CENTER)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, Capital.UI.Colors.Background)
	self:PaintHeader(0, 0, w, 30)
end

vgui.Register("Capital.UI.Frame", PANEL, "EditablePanel")

concommand.Add("cui_test", function()
    if not IsValid(frm) then
        frm = vgui.Create("Capital.UI.Frame")
        frm:SetSize(600,600)
        frm:Center()
        frm:MakePopup()

		scrller = vgui.Create("Capital.UI.ScrollPanel", frm)
		scrller:Center()
		scrller:Dock(FILL)


		local bts = {}
		for i = 1, 45 do
			bts[i] = scrller:Add("Capital.UI.Button")
			bts[i]:SetSize(500,40)
			bts[i]:SetText("I am button: " .. i)
		end
    else
        frm:Remove()
    end
end)