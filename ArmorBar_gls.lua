require "base/internal/ui/reflexcore"
require "base/internal/ui/widgets/glswidgets/reflexcore_gls"
 
ArmorBar_gls =
{
};
registerWidget("ArmorBar_gls");

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function ArmorBar_gls:draw()
 
    -- Early out if HUD shouldn't be shown.
    if not shouldShowHUD() then return end;

    -- Find player 
    local player = getPlayer();
 
    -- player.armor = 30 -- for testing
 
    -- Options
    local showFrame = false;
    local showIcon = false;
    local flatBar = true;
    local colorNumber = false;
    local colorIcon = false;
   
    -- Size and spacing
    local frameWidth = 650;
    local frameHeight = 105;
    local framePadding = 10;
    local numberSpacing = 200;
    local iconSpacing;
 
    if showIcon then iconSpacing = 40
    else iconSpacing = 0;
    end
       
    -- Colors
    local frameColor = Color(0,0,0,128);
    local barAlpha = 220;
    local barBgAlpha = 255;
    local iconAlpha = 32;
 
    local barColor;
    if player.armorProtection == 0 then barColor = Color(2,167,46, barAlpha) end
    if player.armorProtection == 1 then barColor = Color(255,176,14, barAlpha) end
    if player.armorProtection == 2 then barColor = Color(236,0,0, barAlpha) end
 
    local barBackgroundColor = Color(0,0,0, barbgAlpha);
 
    -- Helpers
    local frameLeft = frameWidth;
    local frameRight = 0;
    local frameTop = -frameHeight;
    local frameBottom = 0;
 
    local barBottom = frameBottom - framePadding;
 
    local barWidth = frameWidth - numberSpacing - framePadding - iconSpacing;
    local barHeight = (frameHeight - (framePadding * 2)) / 2;
    
    local barLeft = frameRight + framePadding

    local barRight = frameRight - iconSpacing - numberSpacing
    
    local UpperBarTop = frameTop + framePadding
    local LowerBarTop = frameTop + framePadding + barHeight + framePadding;
 
    local UpperBarBottom = frameBottom - framePadding - barHeight - framePadding;
    local LowerBarBottom = frameBottom - framePadding;
 
    local fontX = barRight - (numberSpacing / 1.8);
    local fontY = -(frameHeight / 2);
    local fontSize = frameHeight * 1;
 
    if player.armorProtection == 0 then fillWidth = math.min((barWidth / 100) * player.armor, barWidth);
    elseif player.armorProtection == 1 then fillWidth = math.min((barWidth / 150) * player.armor, barWidth);
    elseif player.armorProtection == 2 then fillWidth = (barWidth / 200) * player.armor;
    end

    -- Background
    nvgBeginPath();
    nvgRect(barRight+3, UpperBarBottom+3, -barWidth, -barHeight);
    nvgRect(barRight-3, UpperBarBottom-3, -barWidth, -barHeight);
    nvgRect(barRight+3, UpperBarBottom-3, -barWidth, -barHeight);
    nvgRect(barRight-3, UpperBarBottom+3, -barWidth, -barHeight);
    nvgFillColor(barBackgroundColor); 
    nvgFill();

    nvgBeginPath();
    nvgRect(barRight+3, barBottom+3, -barWidth, -barHeight);
    nvgRect(barRight-3, barBottom-3, -barWidth, -barHeight);
    nvgRect(barRight+3, barBottom-3, -barWidth, -barHeight);
    nvgRect(barRight-3, barBottom+3, -barWidth, -barHeight);
    nvgFill();

    local UpperArmorBarWidth;
    local LowerArmorBarWidth;

    if player.armor > 100 then
        UpperArmorBarWidth = barWidth;
        LowerArmorBarWidth = (barWidth / 100) * (player.armor - 100);
    else
        UpperArmorBarWidth = (barWidth / 100) * player.armor
        LowerArmorBarWidth = 0
    end
 
    -- Upper Armor Bar
    if UpperArmorBarWidth > 0 then
        nvgBeginPath();
        nvgRect(barRight, UpperBarBottom, -UpperArmorBarWidth, -barHeight);
        nvgFillColor(barColor);
        nvgFill();
    end
 
    -- Lower Armor Bar
    if LowerArmorBarWidth > 0 then
 
        nvgBeginPath();
        nvgRect(barRight, LowerBarBottom, -LowerArmorBarWidth, -barHeight);
        nvgFillColor(barColor);
        nvgFill();
    end
         
    -- Draw numbers
    local fontColor;
    local fontStrokeColor = Color(0,0,0,255);
    if colorNumber then fontColor = barColor
    else fontColor = Color(255,255,255);
    end
    
    nvgFontFace(FONT_NUMBERS);
    nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
    nvgFontSize(fontSize);
    
    nvgFillColor(fontStrokeColor);
    nvgText(fontX+3, fontY+3, player.armor);
    nvgText(fontX-3, fontY-3, player.armor);
    nvgText(fontX-3, fontY+3, player.armor);
    nvgText(fontX+3, fontY-3, player.armor);

    nvgFillColor(fontColor);
    nvgText(fontX, fontY, player.armor);
end