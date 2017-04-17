CreateClientConVar( "cl_simfphys_crosshair", "1", true, false )


local show_crosshair = false
cvars.AddChangeCallback( "cl_simfphys_crosshair", function( convar, oldValue, newValue ) show_crosshair = tonumber( newValue )~=0 end)
show_crosshair = GetConVar( "cl_simfphys_crosshair" ):GetBool()



local xhair = Material( "sprites/hud/v_crosshair1" )

local function traceAndDrawCrosshair( startpos, endpos, vehicle )
	local trace = util.TraceLine( {
		start = startpos,
		endpos = endpos,
		filter = {vehicle}
	} )

	local hitpos = trace.HitPos
	
	local scr = hitpos:ToScreen()
	
	if scr.visible then
		surface.SetMaterial( xhair )
		surface.SetDrawColor( 255, 235, 0, 255 ) 
		surface.DrawTexturedRect( scr.x - 17,scr.y - 17, 34, 34)
		surface.SetDrawColor( 255, 255, 255, 255 )
		draw.NoTexture()
	end
end

hook.Add( "HUDPaint", "simfphys_crosshair", function()
	if not show_crosshair then return end
	
	local ply = LocalPlayer()
	local veh = ply:GetVehicle()
	if not IsValid( veh ) then return end
	
	local isgunner = veh:GetNWBool( "IsGunnerSeat" ) 
	
	if not isgunner then return end
	
	local vehicle = veh.vehiclebase
	if not IsValid( vehicle ) then return end
	
	if ply:GetViewEntity() ~= ply then return end

	if veh:GetNWBool( "IsAPCSeat" ) then
		local attach_l = vehicle:LookupAttachment( "machinegun_barell_left" )
		local attach_r = vehicle:LookupAttachment( "machinegun_barell_right" )
		local attach_ref = vehicle:LookupAttachment( "machinegun_ref" )
		if attach_l > 0 and attach_r > 0 and attach_ref > 0 then
			local pos1 = vehicle:GetAttachment( attach_l ).Pos
			local pos2 = vehicle:GetAttachment( attach_r ).Pos
			
			local startpos = (pos1 + pos2) * 0.5
			local endpos = startpos + vehicle:GetAttachment( attach_ref ).Ang:Forward() * 999999
			
			traceAndDrawCrosshair( startpos, endpos, vehicle )
		end
		return
	end
	
	local ID = vehicle:LookupAttachment( "muzzle" )
	local Attachment = vehicle:GetAttachment( ID )
	
	local startpos = Attachment.Pos
	local endpos = startpos + Attachment.Ang:Forward() * 999999
	
	traceAndDrawCrosshair( startpos, endpos, vehicle )
end )
