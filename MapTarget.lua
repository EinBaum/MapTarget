
local click_orig = nil

local click_target = function()
	local name = getglobal("GameTooltipTextLeft1"):GetText()
	if name then
		TargetByName(name)
	end
end

local click_new = function()
	if SpellIsTargeting() or IsShiftKeyDown() or IsControlKeyDown() or IsAltKeyDown() then
		click_orig()
	else
		click_target()
	end
end

local setup = function()
	click_orig = Minimap_OnClick
	Minimap_OnClick = click_new
end

setup()
