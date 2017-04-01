
local click_orig = nil

local escapes = {
    ["|c%x%x%x%x%x%x%x%x"] = "", -- color start
    ["|r"] = "", -- color end
    ["|H.-|h(.-)|h"] = "%1", -- links
    ["|T.-|t"] = "", -- textures
}
local function unescape(str)
    for k, v in pairs(escapes) do
        str = gsub(str, k, v)
    end
    return str
end

local click_target = function()
	local name = getglobal("GameTooltipTextLeft1"):GetText()
	if name then
		name = unescape(name)
		TargetByName(name)
	end
end

local click_new = function()
	local shift = IsShiftKeyDown()
	if SpellIsTargeting() or shift or IsControlKeyDown() or IsAltKeyDown() then
		local x, y = GetCursorPosition()
		x = x / this:GetEffectiveScale()
		y = y / this:GetEffectiveScale()

		local cx, cy = this:GetCenter()
		x = x - cx
		y = y - cy

		if shift then
			x = x * 5
			y = y * 5
		end

		x = x + CURSOR_OFFSET_X
		y = y + CURSOR_OFFSET_Y

		Minimap:PingLocation(x, y)
		--DEFAULT_CHAT_FRAME:AddMessage("Ping: " .. x .. " " .. y)
	else
		click_target()
	end
end

local setup = function()
	click_orig = Minimap_OnClick
	Minimap_OnClick = click_new
end

setup()
