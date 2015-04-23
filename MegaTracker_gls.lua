require "base/internal/ui/reflexcore"
require "base/internal/ui/widgets/glswidgets/reflexcore_gls"

MegaTracker_gls =
{
     draw = function()

        -- Early out if HUD shouldn´t be shown.
        if not shouldShowHUD() then return end;

        -- Find player
        local player = getPlayer();

        local textColor = Color(255,255,255,255);
        if player.hasMega then

        local time = 60
        local function decreaseTime()
            time = time - 1
            print(time)
        end
                nvgFontSize(52);
        nvgFontFace("TitilliumWeb-Bold");
        nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_TOP);
        nvgFontBlur(0);
        nvgFillColor(textColor);
        nvgText (0,0, time)
    end


        nvgFontSize(52);
        nvgFontFace("TitilliumWeb-Bold");
        nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_TOP);
        nvgFontBlur(0);
        nvgFillColor(textColor);
--[[
        local armorProtection = player.armorProtection + 1;

        local maxDamage =
            math.min(player.armor, player.health * armorProtection) +
            player.health;

        nvgText(0, 0, maxDamage);]]--

    end
};
registerWidget("MegaTracker_gls");