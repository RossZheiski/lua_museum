--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local Clockwork = Clockwork;
local Color = Color;
local vgui = vgui;

local PANEL = {};

-- A function to set the panel's text.
function PANEL:SetText(text, fontName, color, size)
	local label = self.Label;
	local wasCreated = false;
	
	if (not label) then
		label = vgui.Create("DLabel", self);
		wasCreated = true;
		self.Label = label;
	end;
	
	if (not fontName) then
		fontName = Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), size or 20);
	elseif (size) then
		fontName = Clockwork.fonts:GetSize(fontName, size);
	end;
	
	label:SetFont(fontName);
	
	if (type(color) == "string") then
		color = Clockwork.option:GetColor(color);
	end;
	
	if (color) then
		label:SetTextColor(Color(255, 255, 255, 255));
	else
		label:SetTextColor(Color(255, 255, 255, 255));
	end;
	
	label:SetText(text);
	label:SizeToContents();
	label:SetTall(label:GetTall() + 8);
	
	if (wasCreated) then
		self:AddItem(label);
	end;
end;

-- A function to clear (and remove) the form's children.
function PANEL:Clear(shouldDelete)
	for k, panel in pairs(self.Items) do
		if (!IsValid(panel)) then
			continue;
		end
		
		if (panel == self.Label) then
			continue;
		end;

		panel:SetVisible(false);

		if (shouldDelete) then
			panel:Remove();
		end;
	end;

	self.Items = {self.Label};
end

-- A function to add an item (left and right).
function PANEL:AddLeftRight(left, right)
	if (IsValid(right)) then
		local panel = vgui.Create("DSizeToContents", self);
		
		panel:SetSizeX(false);
		panel:InvalidateLayout();
	
		left:SetParent(panel);
		left:Dock(LEFT);
		left:InvalidateLayout(true);
		
		right:SetParent(panel);
		right:SetPos(110, 0);
		right:InvalidateLayout(true);
		
		self:AddItem(panel);
	elseif (IsValid(left)) then
		self:AddItem(left);
	end;
end;

-- A function to create a text entry.
function PANEL:TextEntry(strLabel, strConVar)
	local left = nil;
	
	if (strLabel) then
		left = vgui.Create("DLabel", self);
		left:SetText(strLabel);
		left:SetFont(Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 18));
		left:SetTextColor(Clockwork.option:GetColor("basic_form_color"));
		left:SizeToContents();
		left:SetWide(left:GetWide() + 12);
	end;
	
	local right = vgui.Create("DTextEntry", self);
	
	right:SetConVar(strConVar);
	
	if (left) then
		right:Dock(TOP);
		
		self:AddLeftRight(left, right);
	else
		self:AddLeftRight(right);
	end;

	right.Paint = function(self, w, h)
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 0), Color(255, 180, 80, 150));
		self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
	end;
	
	return right, left;
end

-- A function to create a combo box.
function PANEL:ComboBox(strLabel, strConVar)
	local left = vgui.Create("DLabel", self);
	
	left:SetText(strLabel);
	left:SetFont(Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 18));
	left:SetTextColor(Color(255, 255, 255, 255));
	
	local right = vgui.Create("DComboBox", self);
	
	right:SetConVar(strConVar);
	right:Dock(FILL);
	
	function right:OnSelect(index, value, data)
		if (!self.m_strConVar) then return; end;
		
		RunConsoleCommand(self.m_strConVar, tostring(data or value));
	end;
	
	self:AddLeftRight(left, right);
	
	return right, left;
end;

-- A function to create a number wang.
function PANEL:NumberWang(strLabel, strConVar, numMin, numMax, numDecimals)
	local left = vgui.Create("DLabel", self);
	
	left:SetText(strLabel);
	left:SetFont(Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 18));
	left:SetTextColor(Color(255, 255, 255, 255));
	
	local right = vgui.Create("DNumberWang", self);
	
	right:SetMinMax(numMin, numMax);
	
	if (numDecimals != nil) then
		right:SetDecimals(numDecimals);
	end;
	
	right:SetConVar(strConVar);
	right:Dock(TOP);
	
	self:AddLeftRight(left, right);
	
	return right, left;
end

-- A function to create a number slider.
function PANEL:NumSlider(strLabel, strConVar, numMin, numMax, numDecimals)
	local left = vgui.Create("DNumSlider", self);
	
	left:SetText(strLabel);
	left:SetMinMax(numMin, numMax);
	left.Label:SetFont(Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 18));
	left.Label:SetTextColor(Color(255, 255, 255));
	
	if (numDecimals != nil) then
		left:SetDecimals(numDecimals);
	end;
	
	left:SetConVar(strConVar);
	left:SizeToContents();
	
	self:AddLeftRight(left, nil);
	
	return left;
end;

-- A function to create a check box.
function PANEL:CheckBox(strLabel, strConVar)
	local left = vgui.Create("DCheckBoxLabel", self);
	
	left:SetText(strLabel);
	left:SetTextColor(Color(255, 255, 255, 255));
	left.Label:SetFont(Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 18));
	--left.Label:SetTextColor(Color(255, 255, 255, 255));
	left:SetConVar(strConVar);

	self:AddLeftRight(left, nil);
	
	return left;
end;

-- A function to create help text.
function PANEL:Help(strHelp)
	local left = vgui.Create("DLabel", self);

	left:SetWrap(true);
	left:SetTextInset(0, 0);
	left:SetText(strHelp);
	left:SetContentAlignment(7);
	left:SetAutoStretchVertical(true);
	left:DockMargin(8, 0, 8, 8);
	left:SetFont(Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 18));
	left:SetTextColor(Color(255, 255, 255, 255));
	
	self:AddLeftRight(left, nil);
	
	left:InvalidateLayout(true);
	
	return left;
end;

-- A function to create a control help.
function PANEL:ControlHelp(strHelp)
	local panel = vgui.Create("DSizeToContents", self);
	
	panel:SetSizeX(false);
	panel:Dock(TOP);
	panel:SetColor(Color(255, 255, 255))
	--panel:SetTextColor(Color(255, 255, 255))
	panel:InvalidateLayout();

	local left = vgui.Create("DLabel", panel);
	
	left:SetDark(false);
	left:SetWrap(true);
	left:SetTextInset(0, 0);
	left:SetText(strHelp);
	left:SetContentAlignment(5);
	left:SetAutoStretchVertical(true);
	left:DockMargin(32, 0, 32, 8);
	left:Dock(TOP);
	left:SetFont(Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 18));
	left:SetTextColor(Color(255, 255, 255));

	table.insert(self.Items, panel);

	return left;
end;

-- A function to create a button.
function PANEL:Button(strName, strConCommand, ...)
	local left = vgui.Create("DButton", self);

	if (strConCommand) then
		left:SetConsoleCommand(strConCommand, ...);
	end;
	
	left:SetText(strName);
	self:AddLeftRight(left);
	
	return left;
end;

-- A function to create a panel select.
function PANEL:PanelSelect()
	local left = vgui.Create("DPanelSelect", self);
	
	self:AddLeftRight(left);
	
	return left;
end;

-- A function to create a list box.
function PANEL:ListBox(strLabel)
	if (strLabel) then
		local left = vgui.Create("DLabel", self);
		
		left:SetText(strLabel);
		left:SetFont(Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 18));
		left:SetTextColor(Color(255, 255, 255, 255));
		
		self:AddLeftRight(left);
	end
	
	local right = vgui.Create("DListBox", self);
	
	right.Stretch = true;
	
	self:AddLeftRight(right);
	
	return right, left;
end;

function PANEL:Paint(w, h)
end;

vgui.Register("cwBasicForm", PANEL, "DPanelList");