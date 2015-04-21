require "base/internal/ui/reflexcore"
require "base/internal/ui/widgets/glswidgets/reflexcore_gls"

Crosshairs_gls =
{
	canHide = false;
	canPosition = false;
	
	-- user data, we'll save this into engine so it's persistent across loads
	userData = {};
};
registerWidget("Crosshairs_gls");

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function Crosshairs_gls:show()
	-- load data stored in engine
	self.userData = loadUserData();
	
	-- ensure it has what we need
	CheckSetDefaultValue(self, "userData", "table", {});
	CheckSetDefaultValue(self.userData, "colorFillByHealth", "boolean", false);
	CheckSetDefaultValue(self.userData, "colorStrokeByHealth", "boolean", false);
	CheckSetDefaultValue(self.userData, "crosshairSize", "number", 64);
	CheckSetDefaultValue(self.userData, "crosshairWeight", "number", 1);
	CheckSetDefaultValue(self.userData, "crosshairStrokeWeight", "number", 5);
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function Crosshairs_gls:hide()
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function Crosshairs_gls:draw(forceDraw, x, y)
	-- player health, updated if we actually have a player
	local playerHealth = 100;
	
	if not forceDraw then
		-- no player => no crosshair
		local player = getPlayer();
		if player == nil then return end;
		playerHealth = player.health;
		
		-- menu => no crosshair
		if isInMenu() then return end;

		-- editor => no crosshair
		if player.state == PLAYER_STATE_EDITOR then
			return;
		end

		-- spectator => no crosshair
		if player.state == PLAYER_STATE_SPECTATOR then
			return;
		end

		-- dead => no crosshair
		if player.health <= 0 then
			return;
		end
	end
    
    -- Colors
    local crosshairFillColor = Color(255,0,255,255);
    local crosshairStrokeColor = Color(0,0,0,255);

	-- pull out of self
    local colorFillByHealth = self.userData.colorFillByHealth;
    local colorStrokeByHealth = self.userData.colorStrokeByHealth;
    local crosshairSize = self.userData.crosshairSize;
    local crosshairWeight = self.userData.crosshairWeight;
    local crosshairStrokeWeight = self.userData.crosshairStrokeWeight;

    if colorFillByHealth then
        if playerHealth > 100 then crosshairFillColor = Color(16,116,217, barAlpha) end
        if playerHealth <= 100 then crosshairFillColor = Color(2,167,46, barAlpha) end
        if playerHealth <= 80 then crosshairFillColor = Color(255,176,14, barAlpha) end
        if playerHealth <= 30 then crosshairFillColor = Color(236,0,0, barAlpha) end
    end

    if colorStrokeByHealth then
        if playerHealth > 100 then crosshairStrokeColor = Color(16,116,217, barAlpha) end
        if playerHealth <= 100 then crosshairStrokeColor = Color(2,167,46, barAlpha) end
        if playerHealth <= 80 then crosshairStrokeColor = Color(255,176,14, barAlpha) end
        if playerHealth <= 30 then crosshairStrokeColor = Color(236,0,0, barAlpha) end
    end

	nvgSave();
	if x ~= nil and y ~= nil then
		nvgTranslate(x, y);
	end

    -- Helpers
    local crosshairHalfSize = crosshairSize / 2;
    local crosshairHalfWeight = crosshairWeight / 2;
        --[[nvgBeginPath();
        nvgRect(-crosshairHalfWeight, crosshairHalfSize, crosshairWeight, crosshairSize) -- vertical
        nvgFillColor(Color(255,255,255,128)); 
        nvgFill();]]--
    -- Crosshair 1
    if consoleGetVariable("cl_crosshair") == 1 then
        nvgBeginPath();
        nvgRect(-crosshairHalfSize, -crosshairHalfWeight, crosshairSize, crosshairWeight) -- horizontal
        nvgRect(-crosshairHalfWeight, -crosshairHalfSize, crosshairWeight, crosshairSize) -- vertical
        nvgStrokeColor(crosshairStrokeColor);
        nvgStrokeWidth(crosshairStrokeWeight);
        nvgStroke();
        nvgFillColor(crosshairFillColor); 
        nvgFill();
    end

    -- Crosshair 2
    if consoleGetVariable("cl_crosshair") == 2 then
        local innerSpace = 0.65;
        nvgBeginPath();
        nvgRect(-crosshairHalfSize, -crosshairHalfWeight, crosshairHalfSize * innerSpace, crosshairWeight) -- left
        nvgRect(-crosshairHalfWeight, -crosshairHalfSize, crosshairWeight, crosshairHalfSize * innerSpace) -- top
        nvgRect(crosshairHalfSize, crosshairHalfWeight, -crosshairHalfSize * innerSpace, -crosshairWeight) -- right
        nvgRect(crosshairHalfWeight, crosshairHalfSize, -crosshairWeight, -crosshairHalfSize * innerSpace) -- bottom
        nvgStrokeColor(crosshairStrokeColor);
        nvgStrokeWidth(crosshairStrokeWeight);
        nvgStroke();
        nvgFillColor(crosshairFillColor); 
        nvgFill();
    end

    -- Crosshair 3
    if consoleGetVariable("cl_crosshair") == 3 then
        local innerSpace = 0.65;
        nvgBeginPath();
        nvgRect(-crosshairHalfSize, -crosshairHalfWeight, crosshairSize, crosshairWeight) -- horizontal
        nvgRect(-crosshairHalfWeight, -crosshairHalfSize/3, crosshairWeight, crosshairSize/3) -- vertical
        nvgStrokeColor(crosshairStrokeColor);
        nvgStrokeWidth(crosshairStrokeWeight);
        nvgStroke();
        nvgFillColor(crosshairFillColor); 
        nvgFill();
    end

    -- Crosshair 4
    if consoleGetVariable("cl_crosshair") == 4 then
        nvgBeginPath();
        nvgCircle(0, 0, crosshairSize / 8)
        nvgStrokeColor(crosshairStrokeColor);
        nvgStrokeWidth(crosshairStrokeWeight);
        nvgStroke();
        nvgFillColor(crosshairFillColor); 
        nvgFill();
    end

    -- Crosshair 5
    if consoleGetVariable("cl_crosshair") == 5 then
        nvgBeginPath();
        nvgCircle(0, 0, crosshairSize / 4)
        nvgStrokeColor(crosshairFillColor);
        nvgStrokeWidth(crosshairStrokeWeight / 2);
        nvgStroke();
    end

    -- Crosshair 6-16
    if consoleGetVariable("cl_crosshair") >= 6 and consoleGetVariable("cl_crosshair") <= 16 then
        local crosshair = consoleGetVariable("cl_crosshair");
        nvgBeginPath();
        nvgFillColor(crosshairFillColor);
        nvgSvg("internal/ui/crosshairs/crosshair" .. crosshair, 0, 0, crosshairSize);
    end

	nvgRestore();
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function Crosshairs_gls:drawOptions(x, y)
	local sliderWidth = 200;
	local sliderStart = 140;
	
	uiLabel("Preview:", x + 10, y);
	self:draw(true, x + 80, y + 80);
	y = y + 130;

	local user = self.userData;

	user.colorFillByHealth = uiCheckBox(user.colorFillByHealth, "Color Fill By Health", x, y);
	y = y + 30;

	user.colorStrokeByHealth = uiCheckBox(user.colorStrokeByHealth, "Color Stroke By Health", x, y);
	y = y + 40;
	
	uiLabel("Size:", x, y);
	user.crosshairSize = clampTo2Decimal(uiSlider(x + sliderStart, y, sliderWidth, 1, 90, user.crosshairSize));
	user.crosshairSize = clampTo2Decimal(uiEditBox(user.crosshairSize, x + sliderStart + sliderWidth + 10, y, 60));
	y = y + 40;

	uiLabel("Weight:", x, y);
	user.crosshairWeight = clampTo2Decimal(uiSlider(x + sliderStart, y, sliderWidth, 1, 10, user.crosshairWeight));
	user.crosshairWeight = clampTo2Decimal(uiEditBox(user.crosshairWeight, x + sliderStart + sliderWidth + 10, y, 60));
	y = y + 40;

	uiLabel("Stroke Weight:", x, y);
	user.crosshairStrokeWeight = clampTo2Decimal(uiSlider(x + sliderStart, y, sliderWidth, 1, 10, user.crosshairStrokeWeight));
	user.crosshairStrokeWeight = clampTo2Decimal(uiEditBox(user.crosshairStrokeWeight, x + sliderStart + sliderWidth + 10, y, 60));
	y = y + 40;

	saveUserData(user);
end
