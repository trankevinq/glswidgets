require "base/internal/ui/reflexcore"
require "base/internal/ui/widgets/glswidgets/reflexcore_gls"

DuelFragMessages =
{
	-- Settings
	messageDisplayTime = 2.5;	-- excluding fade
	messageFadeIn = 0;
	messageFadeOut = 1;
	fontSize = 50;
	fontFace = FONT_HUD;
	fontColor = Color(230,230,230);
	fontShadowColor = Color(0,0,0);
};
registerWidget("DuelFragMessages");

------------------------------------------
------------------------------------------
local lastScore = {};
local lastFragMessage = "";
local displayFor = 0;
local displayTime = DuelFragMessages.messageFadeIn + DuelFragMessages.messageDisplayTime + DuelFragMessages.messageFadeOut;

local function setFragMessage(killerPlayerIndex, victimPlayerIndex)
	local killerName;
	local victimName;
	local verb;

	if victimPlayerIndex == playerIndexLocalPlayer then return else victimName = players[victimPlayerIndex].name end
	if killerPlayerIndex == playerIndexLocalPlayer then killerName = "You" else killerName = players[killerPlayerIndex].name end

	if players[killerPlayerIndex].weaponIndexSelected == 1 then verb = "humiliated" else verb = fragged end;

	lastFragMessage = killerName.." "..verb.." "..victimName.."!";
	displayFor = displayTime;
end

local function PrintLastFragMessage()
	local fontAlpha;
	local fontShadowAlpha;
	if DuelFragMessages.messageFadeIn > displayTime - displayFor then
		fontAlpha = 255 * (displayTime - displayFor) / DuelFragMessages.messageFadeIn;
		fontShadowAlpha = 255 * (displayTime - displayFor) / DuelFragMessages.messageFadeIn;
	elseif DuelFragMessages.messageFadeOut > displayFor then
		fontAlpha = 255 * displayFor / DuelFragMessages.messageFadeOut;
		fontShadowAlpha = 255 * displayFor / DuelFragMessages.messageFadeOut;
	else
		fontAlpha = 255;
		fontShadowAlpha = 255;
	end
	nvgBeginPath();
	nvgFontSize(DuelFragMessages.fontSize);
	nvgFontFace(DuelFragMessages.fontFace);
	nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
	nvgFontBlur(2);
	nvgFillColor(Color(DuelFragMessages.fontShadowColor.r,DuelFragMessages.fontShadowColor.g,DuelFragMessages.fontShadowColor.b,fontShadowAlpha));
	nvgText(0,1,lastFragMessage);
	nvgFontBlur(0);
	nvgFillColor(Color(DuelFragMessages.fontColor.r,DuelFragMessages.fontColor.g,DuelFragMessages.fontColor.b,fontAlpha));
	nvgText(0,0,lastFragMessage);
end

function DuelFragMessages:draw()
	if getPlayer() == nil
		or getPlayer().state == PLAYER_STATE_EDITOR
		or world.gameModeIndex ~= 2
		or world.gameState ~= GAME_STATE_ACTIVE
		or consoleGetVariable("cl_show_hud") == 0
		or isInMenu()
		or not getPlayer().connected then
			if displayFor > 0 then displayFor = displayFor - deltaTimeRaw;
			elseif next(lastScore) then lastScore = {}; displayFor = 0; lastFragMessage = ""; end;
			return;
	else
		for p,player in pairs(players) do
			if player.connected and player.state == PLAYER_STATE_INGAME then
				if lastScore[p] ~= nil and lastScore[p] < player.score then
					for o,opponent in pairs(players) do
						if o ~= p and opponent.connected and opponent.state == PLAYER_STATE_INGAME then setFragMessage(p,o); break end
					end
				end
				lastScore[p] = player.score;
			end
		end
		if displayFor > 0 then
			displayFor = displayFor - deltaTimeRaw;
			PrintLastFragMessage();
		end
	end
end
