require "base/internal/ui/widgets/glswidgets/reflexcore_gls"

ScreenEffects_gls =
{
};
registerWidget("ScreenEffects_gls");

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function ScreenEffects_gls:draw()
 
    -- Find player
    local player = getPlayer();

    -- Early out if possible
    if player == nil or
       player.state == PLAYER_STATE_EDITOR or 
       player.state == PLAYER_STATE_SPECTATOR or 
       world.gameState == GAME_STATE_GAMEOVER or
       isInMenu() 
       then return false end;

    if not player.connected then return end;
    
    local x = -(viewport.width / 2);
    local y = -(viewport.height / 2);
    local width = viewport.width;
    local height = viewport.height;
    local innerRadius = width / 3;
    local textY = (height / 2) - 110;
    
    local bloodOuterColor = Color(0,0,0,0);
    local bloodInnerColor = Color(0,0,0,0);
    local deathInnerColor = Color(0,0,0,0);
    local deathOuterColor = Color(0,0,0,0);

    if player.health > 0 and player.health <= 30 then
        nvgBeginPath();
        nvgRect(x, y, width, height);
        nvgFillRadialGradient(0, 0, innerRadius, width, bloodInnerColor, bloodOuterColor);
        nvgFill();
    end

    if player.health <= 0 and gamemodes[world.gameModeIndex].canRespawn == true then
        nvgBeginPath();
        nvgRect(x, y, width, height);
        nvgFillRadialGradient(0, 0, innerRadius, width, deathInnerColor, deathOuterColor);
        nvgFill();

        nvgFontSize(0);
	    nvgFontFace("titilliumWeb-regular");
	    nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);

        nvgFontBlur(10);
        nvgFillColor(Color(180,0,0,255));
        nvgText(0, textY, "I will not die until I achieve something. Even though the ideal is high, I never give in. Therefore, I never die with regrets.");

        nvgFontBlur(0);
        nvgFillColor(Color(230,0,0,255));
        nvgText(0, textY, "I will not die until I achieve something. Even though the ideal is high, I never give in. Therefore, I never die with regrets.");

        nvgFontSize(26);
	    nvgFontFace("titilliumWeb-regular");
	    nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_BASELINE);
        nvgFillColor(Color(230,230,230,255));
        nvgText(0, textY + 50, "Press jump or attack to respawn");

        --nvgFontSize(20);
	    --nvgFontFace("titilliumWeb-regular");
	    --nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_BASELINE);
        --nvgFillColor(Color(230,230,230,255));
        --nvgText(0, textY + 70, "Forced respawn in X");
    end

    if player.health <= 0 and gamemodes[world.gameModeIndex].canRespawn == false then

        nvgFontSize(50);
	    nvgFontFace(FONT_HUD);
	    nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);

        nvgFontBlur(10);
        nvgFillColor(Color(180,0,0,255));
        nvgText(0, textY, "I will not die until I achieve something. Even though the ideal is high, I never give in. Therefore, I never die with regrets.");

        nvgFontBlur(0);
        nvgFillColor(Color(230,0,0,255));
        nvgText(0, textY, "I will not die until I achieve something. Even though the ideal is high, I never give in. Therefore, I never die with regrets.");

        nvgFontSize(26);
	    nvgFontFace("titilliumWeb-regular");
	    nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_BASELINE);
        nvgFillColor(Color(230,230,230,255));
        nvgText(0, textY + 50, "Waiting for next round..");

        --nvgFontSize(20);
	    --nvgFontFace("titilliumWeb-regular");
	    --nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_BASELINE);
        --nvgFillColor(Color(230,230,230,255));
        --nvgText(0, textY + 70, "Forced respawn in X");
    end
end
