local cwOption = Clockwork.option;
local cwConfig = Clockwork.config;
local blip = "hl1/fvox/buzz.wav"

/* -------------------------------------------------------------------------- */
/*                                 Chat Class                                 */
/* -------------------------------------------------------------------------- */

Clockwork.chatBox:RegisterClass("staffpm", nil, function(info)
	local color = cwOption:GetColor("cp_color") or Color(0, 114, 188, 255)
    local white = Color(255,255,255,255)
    local red = Color(200,55,55,255)
    local blue = Color(80,150,200)
    local icon = "icon16/information.png"
    local target = info.data.target
    
    if (IsValid(target)) then
        if info.data.codename then
            Clockwork.chatBox:Add(info.filtered, icon, color, "[STAFF] ", red, info.data.codename, white, " -> ", blue, target, white, ": ", info.text);    
        else
            Clockwork.chatBox:Add(info.filtered, icon, color, "[STAFF]", white, " -> ", blue, target, white, ": ", info.text);    
        end
    else
        if info.data.codename then
            Clockwork.chatBox:Add(info.filtered, icon, color, "[STAFF] ", red, info.data.codename, white, ": ", info.text);    
        else
            Clockwork.chatBox:Add(info.filtered, icon, color, "[STAFF] ", white, info.text);
        end
    end

    surface.PlaySound(blip)
end);