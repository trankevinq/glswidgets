require "base/internal/ui/reflexcore"
require "base/internal/ui/widgets/glswidgets/reflexcore_gls"

Timer_gls =
{
};
registerWidget("Timer_gls");

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function Timer_gls:draw()

    -- Early out if HUD shouldn't be shown.
    if not shouldShowHUD() then return end;
    
    if  (world.gameState == GAME_STATE_ACTIVE) or
        (world.gameState == GAME_STATE_WARMUP) or
        (world.gameState == GAME_STATE_ROUNDACTIVE) then

        local timeRemaining = world.gameTimeLimit - world.gameTime;
        if timeRemaining < 0 then
            timeRemaining = 0;
        end
        
        local t = FormatTime(timeRemaining); --local t = FormatTime(world.gameTime); Counting up
         
        local textTime = string.format("%d:%02d", t.minutes, t.seconds);        
        
        -- Options
        local showFrame = false;
        
        -- Size and spacing
        local frameWidth = 200;
        local frameHeight = 80;
        local framePadding = 0;
        local numberSpacing = 0;
        
        -- Helpers
        local frameLeft = 100;
        local frameTop = 40;
        local frameRight = -100;
        local frameBottom = -40;
        
        local fontX = frameLeft -100;
        local fontY = frameBottom -5  
        local fontSize = frameHeight * 1.15;

        -- Colors
        local frameColor = Color(0,0,0,100);
        local fontColor = Color(255,255,255,255);
        --local lowTimeFrameColor = Color(0,0,0,128);
        local lowTimeTextColor = Color(255,255,255);
    
        -- Options
        local lowTime = 300000; -- in milliseconds

        if timeRemaining < lowTime then
            --frameColor = lowTimeFrameColor;
            fontColor = lowTimeTextColor;
        end

        -- Background
        if showFrame then
        nvgBeginPath();
        nvgRoundedRect(frameRight, frameBottom, frameWidth, frameHeight, 5);
        nvgFillColor(frameColor);
        nvgFill();
        end
        
        -- Text
        local fontColor1 = Color(0,0,0,255);
        
        nvgFontSize(fontSize);
        nvgFontFace(FONT_HUD);
        nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_TOP);
        
        nvgFontBlur(0);
        nvgFillColor(fontColor1);
        nvgText(fontX+3, fontY+3, textTime);
        
        nvgFontSize(fontSize);
        nvgFontFace(FONT_HUD);
        nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_TOP);
        
        nvgFontBlur(0);
        nvgFillColor(fontColor);
        nvgText(fontX, fontY, textTime);
    end
    
end
