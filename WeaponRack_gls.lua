require "base/internal/ui/widgets/glswidgets/reflexcore_gls"

WeaponRack_gls =
{
};
registerWidget("WeaponRack_gls");

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function WeaponRack_gls:draw()

    -- Early out if HUD shouldn't be shown.
    if not shouldShowHUD() then return end;

	local translucency = 192;
	
   	-- Find player
	local player = getPlayer();

    local weaponCount = 8; -- table.maxn(player.ammo);
    local spaceCount = weaponCount;
    
    -- Options
    local verticalRack = false;
    local weaponWidth = 32;
    local weaponHeight = 32;
    local weaponPadding = 60; -- 0 or -1 to remove spacing
    
    -- Helpers
    local rackWidth = (weaponWidth * 7) + (weaponPadding * spaceCount);
    local rackLeft = -(rackWidth / 3);
    local weaponX = rackLeft;
    local weaponY = 0;

    for weaponIndex = 3, weaponCount do

        local weapon = player.weapons[weaponIndex];
		local color = weapon.color;
    
		-- if the weapon is out of ammo, colour it grey
        -- Do we need to add an exception for the axe?
        if weapon.ammo == 0 then
            color.r = 128;
            color.g = 128;
            color.b = 128;
        end

        local backgroundColor = Color(0,0,0,128)
        
        if weapon.pickedup then

            -- Frame background
            nvgBeginPath();
            nvgCircle(weaponX,weaponY-5,weaponWidth-5,weaponHeight-5);
            if weaponIndex == player.weaponIndexSelected then 
                backgroundColor.r = lerp(backgroundColor.r, color.r, player.weaponSelectionIntensity);
                backgroundColor.g = lerp(backgroundColor.g, color.g, player.weaponSelectionIntensity);
                backgroundColor.b = lerp(backgroundColor.b, color.b, player.weaponSelectionIntensity);
                backgroundColor.a = lerp(backgroundColor.a, 100, player.weaponSelectionIntensity);

    			local outlineColor = Color(
    				color.r,
    				color.g,
                    color.b,
    				lerp(0, 255, player.weaponSelectionIntensity));

                nvgStrokeWidth(0);
                nvgStrokeColor(outlineColor);
                nvgStroke();
            end

            nvgFillColor(backgroundColor);
            nvgFill();

            -- Icon
    	    local iconRadius = weaponHeight * 1;
            local iconX = weaponX + (weaponWidth / 25);
            local iconY = (weaponHeight / 25);
            local iconColor = color;
            local shadowColor = Color(0,0,0);

-- turn weapons white when selected
            if weaponIndex == player.weaponIndexSelected then 
    			iconColor.r = lerp(iconColor.r, 255, player.weaponSelectionIntensity);
    			iconColor.g = lerp(iconColor.g, 255, player.weaponSelectionIntensity);
    			iconColor.b = lerp(iconColor.b, 255, player.weaponSelectionIntensity);
    			iconColor.a = lerp(iconColor.a, 255, player.weaponSelectionIntensity);
    		end
            
            local svgName = "internal/ui/icons/weapon"..weaponIndex;
            nvgFillColor(shadowColor);
            nvgSvg(svgName, iconX, iconY, iconRadius);
            nvgFillColor(iconColor);
            nvgSvg(svgName, iconX-3, iconY-3, iconRadius);

            -- Ammo
    	    local ammoX = weaponX + (weaponWidth / 25);
            local ammoCount = player.weapons[weaponIndex].ammo;

            if weaponIndex == 1 then ammoCount = "-" end
            nvgFontSize(32);
            nvgFontFace(FONT_HUD);
    	    nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_TOP);

    	    nvgFontBlur(0);
    	    nvgFillColor(Color(0,0,0));
            if (ammoCount <= 5) then
                nvgFillColor(Color(255,0,0));
            end       
    	    nvgText(ammoX+3, 35+3, ammoCount);
            nvgFillColor(Color(255,255,255));
            nvgText(ammoX, 35, ammoCount);

            if verticalRack == true then
                weaponY = weaponY + weaponHeight + weaponPadding;
            else
                weaponX = weaponX + weaponWidth + weaponPadding;
            end
        end
       
    end

end