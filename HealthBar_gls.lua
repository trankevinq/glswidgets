require "base/internal/ui/reflexcore"
require "base/internal/ui/widgets/glswidgets/reflexcore_gls"

HealthBar_gls =
{
};
registerWidget("HealthBar_gls");

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function HealthBar_gls:draw()
 
    -- Early out if HUD shouldn't be shown.
    if not shouldShowHUD() then return end;

    -- Find player 
    local player = getPlayer();

    -- player.health = 20 -- for testing

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

    if showIcon then iconSpacing = 30
    else iconSpacing = 0;
    end
	
    -- Colors
    local frameColor = Color(0,0,0,128);
    local barAlpha = 220;
	local barBgAlpha = 255;
    local iconAlpha = 32;

    local barColor;
    if player.health > 100 then barColor = Color(16,116,217, barAlpha) end
    if player.health <= 100 then barColor = Color(192,167,20, barAlpha) end
    if player.health <= 50 then barColor = Color(236,0,0, barAlpha) end
    if player.hasMega then barColor = Color(80,0,142, barAlpha) end

    local barBackgroundColor = Color(0,0,0, barbgAlpha);

    -- Helpers
    local frameLeft = 0;
    local frameRight = frameWidth;
    local frameTop = -frameHeight;
    local frameBottom = 0;
    
    local barBottom = frameBottom - framePadding;

    local barWidth = frameWidth - numberSpacing - framePadding - iconSpacing;
    local barHeight = (frameHeight - (framePadding * 2)) / 2;
 
    local barLeft = frameLeft + iconSpacing + numberSpacing

    local barRight = frameRight - framePadding

    local UpperBarTop = frameTop + framePadding
    local LowerBarTop = frameTop + framePadding + barHeight + framePadding;
    
    local UpperBarBottom = frameBottom - framePadding - barHeight - framePadding;
    local LowerBarBottom = frameBottom - framePadding;
 
    local fontX = barLeft + (numberSpacing / 1.8);
    local fontY = -(frameHeight / 2);
    local fontSize = frameHeight * 1;

    local fillWidth;
    if player.health > 100 then fillWidth = (barWidth / 100) * (player.health - 100);
    else fillWidth = (barWidth / 100) * player.health; end

-- Background 
    nvgBeginPath();
    nvgFillColor(barBackgroundColor); 
    nvgRect(barRight+3, UpperBarBottom+3, -barWidth, -barHeight);
    nvgRect(barRight+3, UpperBarBottom-3, -barWidth, -barHeight);
    nvgRect(barRight-3, UpperBarBottom+3, -barWidth, -barHeight);
    nvgRect(barRight-3, UpperBarBottom-3, -barWidth, -barHeight);
    nvgFill();

    nvgBeginPath();
    nvgRect(barRight+3, barBottom+3, -barWidth, -barHeight);
    nvgRect(barRight-3, barBottom-3, -barWidth, -barHeight);
    nvgRect(barRight+3, barBottom-3, -barWidth, -barHeight);
    nvgRect(barRight-3, barBottom+3, -barWidth, -barHeight);
    nvgFill();

    local UpperHealthBarWidth;
    local LowerHealthBarWidth;

    if player.health > 100 then 
        UpperHealthBarWidth = barWidth;
        LowerHealthBarWidth = (barWidth / 100) * (player.health - 100);
    else
        UpperHealthBarWidth = (barWidth / 100) * player.health
        LowerHealthBarWidth = 0
    end

    -- Upper Health Bar
    if UpperHealthBarWidth > 0 then
        nvgBeginPath();
        nvgRect(barLeft, UpperBarBottom, UpperHealthBarWidth, -barHeight);
        nvgFillColor(barColor); 
        nvgFill();
    end

    -- Lower Health Bar
    if LowerHealthBarWidth > 0 then
        nvgBeginPath();
        nvgRect(barLeft, LowerBarBottom, LowerHealthBarWidth, -barHeight);
        nvgFillColor(barColor); 
        nvgFill();
    end
          
    -- Draw numbers
    local fontColor;
    local fontStrokeColor = Color(0,0,0,255);
    if colorNumber then fontColor = barColor
    else fontColor = Color(255,255,255)
    end

    nvgFontFace(FONT_NUMBERS);
    nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
    nvgFontSize(fontSize);    

    nvgFillColor(fontStrokeColor);
    nvgText(fontX+3, fontY+3, player.health);    
    nvgText(fontX-3, fontY-3, player.health);
    nvgText(fontX+3, fontY-3, player.health);
    nvgText(fontX-3, fontY+3, player.health);

    nvgFillColor(fontColor);
    nvgText(fontX, fontY, player.health);
end
