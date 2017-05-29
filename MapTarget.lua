
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

local function getlines(text)
	text = text .. "\n"
	local lines = {}
	local index = 1
	local pos = 0
	while true do
		local newpos = strfind(text, "\n", pos, true)
		if not newpos then
			break
		end
		local line = strsub(text, pos, newpos - 1)
		if line ~= "" then
			lines[index] = line
			index = index + 1
		end
		pos = newpos + 1
	end
	return lines
end

local function filter(name)
	if strfind(name, " ") then
		return false
	end
	return true
end

local click_target = function()
	local text = getglobal("GameTooltipTextLeft1"):GetText()
	if not text then return end
	local names = getlines(text)

	local selected = 1

	for i, name in names do
		local uname = unescape(name)
		names[i] = uname
		if filter(uname) then
			selected = i
		end
	end

	TargetByName(names[selected], true)
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
