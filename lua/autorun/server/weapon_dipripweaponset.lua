simWeapons = simWeapons or {}

local function hmgfire(ply,vehicle,shootOrigin,shootDirection)
	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= shootOrigin
		bullet.Dir 			= shootDirection
		bullet.Spread 		= Vector(0,0,0)
		bullet.Tracer		= 1
		bullet.TracerName	= "simfphys_tracer"
		bullet.Force		= 12
		bullet.Damage		= 30
		bullet.HullSize		= 5
		bullet.Attacker 	= ply
		
	vehicle:FireBullets( bullet )
end

local function minigunfire(ply,vehicle,shootOrigin,shootDirection)
	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= shootOrigin + shootDirection * 50
		bullet.Dir 			= shootDirection
		bullet.Spread 		= Vector(0.06,0.06,0)
		bullet.Tracer		= 1
		bullet.TracerName	= "simfphys_tracer"
		bullet.Force		= 4
		bullet.Damage		= 25
		bullet.HullSize		= 10
		bullet.Attacker 	= ply
		
	vehicle:FireBullets( bullet )
end

function simWeapons.dipripweaponset( ply, pod, vehicle )
	local curtime = CurTime()
	
	if not IsValid( vehicle ) then return end
	
	if not IsValid(ply) then
		if vehicle.wpn then
			vehicle.wpn:Stop()
			vehicle.wpn = nil
		end
		
		if vehicle.wpn2 then
			vehicle.wpn2:Stop()
			vehicle.wpn2 = nil
		end
		return
	end

	ply:CrosshairEnable()
	
	vehicle.wOldPos = vehicle.wOldPos or Vector(0,0,0)
	local deltapos = vehicle:GetPos() - vehicle.wOldPos
	vehicle.wOldPos = vehicle:GetPos()
	
	local ID = vehicle:LookupAttachment( "machinegun_ref" )
	local Attachment = vehicle:GetAttachment( ID )
	
	local Angles = vehicle:WorldToLocalAngles( ply:EyeAngles() )
	Angles:Normalize()
	
	vehicle.sm_pp_yaw = vehicle.sm_pp_yaw and (vehicle.sm_pp_yaw + (Angles.y - vehicle.sm_pp_yaw) * 0.2) or 0
	vehicle.sm_pp_pitch = vehicle.sm_pp_pitch and (vehicle.sm_pp_pitch + (Angles.p - vehicle.sm_pp_pitch) * 0.2) or 0
	vehicle:SetPoseParameter("vehicle_weapon_yaw", vehicle.sm_pp_yaw )
	vehicle:SetPoseParameter("vehicle_weapon_pitch", -vehicle.sm_pp_pitch )
	
	local tr = util.TraceLine( {
		start = Attachment.Pos,
		endpos = Attachment.Pos + Attachment.Ang:Forward() * 50000,
		filter = {vehicle}
	} )
	local Aimpos = tr.HitPos
	local pos1 = vehicle:GetAttachment( vehicle:LookupAttachment( "machinegun_barell_left" ) ).Pos
	local pos2 = vehicle:GetAttachment( vehicle:LookupAttachment( "machinegun_barell_right" ) ).Pos
	local Aimang = (Aimpos - (pos1 + pos2) * 0.5):Angle()
	local Angles = vehicle:WorldToLocalAngles( Aimang )
	Angles:Normalize()
	
	vehicle:SetPoseParameter("vehicle_minigun_yaw", Angles.y )
	
	local class = vehicle:GetSpawn_List()
	local neg = class == "sim_fphys_ratmobile" and 1 or -1

	vehicle:SetPoseParameter("vehicle_minigun_pitch", Angles.p * neg )
	
	vehicle.missle_ammo = vehicle.missle_ammo or 6
	vehicle.mg_ammo = vehicle.mg_ammo or 600
	
	local keyattack = ply:KeyDown( IN_ATTACK ) and vehicle.mg_ammo > 0
	local alt_fire = ply:KeyDown( IN_ATTACK2 )
	local reload = ply:KeyDown( IN_RELOAD )
	
	if reload and (vehicle.missle_ammo ~= 6 or vehicle.mg_ammo ~= 320)  then
		vehicle:EmitSound("vehicles/tank_readyfire1.wav")
		
		vehicle.missle_ammo = 6
		vehicle.mg_ammo = 320
		vehicle.lockweapons = true
		
		vehicle.NextSecondaryShoot = curtime + 2
		vehicle:SetIsCruiseModeOn( false )
		
		timer.Simple( 2, function()
			if not IsValid( vehicle ) then return end
			vehicle.lockweapons = false
			vehicle:SetIsCruiseModeOn( false )
		end)
	end
	
	local inrange = math.abs( Angles.y ) <= 10
	
	local fire = false
	local fire2 = false
	if not vehicle.lockweapons then
		if inrange then
			fire = false
			fire2 = keyattack
		else
			fire = keyattack
			fire2 = false
		end
	end
	
	vehicle.smoothaltfire = vehicle.smoothaltfire and (vehicle.smoothaltfire + ((fire2 and 20 or 0) - vehicle.smoothaltfire) * 0.1) or 0
	vehicle.minigunspin = vehicle.minigunspin and (vehicle.minigunspin + vehicle.smoothaltfire) or 0
	vehicle:SetPoseParameter("vehicle_minigun_spin", vehicle.minigunspin )
	
	vehicle.NextShoot = vehicle.NextShoot or 0
	
	if fire then
		if vehicle.NextShoot < curtime then
			
			vehicle.mg_ammo = vehicle.mg_ammo - 1
			
			if vehicle.swapMuzzle then
				vehicle.swapMuzzle = false
			else
				vehicle.swapMuzzle = true
			end
		
			local switchPos = vehicle.swapMuzzle and pos1 or pos2
		
			local effectdata = EffectData()
			effectdata:SetOrigin( switchPos )
			effectdata:SetAngles( Attachment.Ang )
			effectdata:SetScale( 1 )
			util.Effect( "MuzzleEffect", effectdata, true, true )
			
			hmgfire( ply, vehicle, switchPos, Attachment.Ang:Forward() )
			vehicle.NextShoot = curtime + 0.08
		end
	end
	
	if fire2 then
		if vehicle.NextShoot < curtime then
			
			vehicle.mg_ammo = vehicle.mg_ammo - 2
			
			local offset = deltapos * engine.TickInterval()
			
			local muzzle_1 = vehicle:GetAttachment( vehicle:LookupAttachment( "minigun_barell_right" ) )
			local muzzle_2 = vehicle:GetAttachment( vehicle:LookupAttachment( "minigun_barell_left" ) )
			local muzzles = {muzzle_1,muzzle_2}
			
			for k, v in pairs( muzzles ) do
				local projeffectdata = EffectData()
					projeffectdata:SetEntity( vehicle )
					projeffectdata:SetScale( 1 )
					projeffectdata:SetMagnitude( 1 )
					projeffectdata:SetRadius( 10 )
					projeffectdata:SetFlags( 3 )
					projeffectdata:SetStart( v.Pos + offset )
					projeffectdata:SetOrigin( v.Pos + offset )
					projeffectdata:SetAngles( v.Ang )
					projeffectdata:SetNormal( v.Ang:Forward() )
				util.Effect( "MuzzleFlash", projeffectdata )
				
				minigunfire( ply, vehicle, v.Pos + offset, v.Ang:Forward() )
			end
			
			vehicle.NextShoot = curtime + 0.03
		end
	end
	
	vehicle.NextSecondaryShoot = vehicle.NextSecondaryShoot or 0
	if alt_fire ~= vehicle.afire_pressed then
		vehicle.afire_pressed = alt_fire
		if alt_fire then
			if vehicle.NextSecondaryShoot < curtime then
				if not IsValid(vehicle.missle) then
					if vehicle.missle_ammo > 0 then
						vehicle:EmitSound("simulated_vehicles/weapons/diprip/rocket.wav")
						
						vehicle.missle_ammo = vehicle.missle_ammo - 1
						
						if vehicle.swapMuzzle then
							vehicle.swapMuzzle = false
						else
							vehicle.swapMuzzle = true
						end
						
						local attach = vehicle.swapMuzzle and vehicle:GetAttachment( vehicle:LookupAttachment( "rocket_barell_right" ) ) or vehicle:GetAttachment( vehicle:LookupAttachment( "rocket_barell_left" ) )
						
						vehicle.missle = ents.Create( "rpg_missile" )
						vehicle.missle:SetPos( attach.Pos + attach.Ang:Up() * 25 )
						vehicle.missle:SetAngles( attach.Ang - Angle(10,0,0) )
						vehicle.missle:SetOwner( vehicle )
						vehicle.missle:SetSaveValue( "m_flDamage", 120 )
						vehicle.missle:Spawn()
						vehicle.missle:Activate()
						
						vehicle.missle.DirVector = vehicle.missle:GetAngles():Forward()
						
						vehicle.NextSecondaryShoot = curtime + 0.5
						vehicle.UnlockMissle = curtime + 0.5
					else
						vehicle:EmitSound("Weapon_Shotgun.Empty")
					end
				end
			end
		end
	end
	
	if IsValid(vehicle.missle) then
		if vehicle.UnlockMissle < curtime then
			local targetdir = Aimpos - vehicle.missle:GetPos()
			targetdir:Normalize()
			
			vehicle.missle.DirVector = vehicle.missle.DirVector + (targetdir - vehicle.missle.DirVector) * 0.1
			
			local vel = -vehicle.missle:GetVelocity() + vehicle.missle.DirVector * 2500 + vehicle:GetVelocity()
			
			vehicle.missle:SetVelocity( vel )
			vehicle.missle:SetAngles( vehicle.missle.DirVector:Angle() )
		end
	end
	
	
	vehicle.OldFire = vehicle.OldFire or false
	vehicle.OldFire2 = vehicle.OldFire2 or false
	if vehicle.OldFire ~= fire then
		vehicle.OldFire = fire
		if fire then
			vehicle.wpn = CreateSound( vehicle, "simulated_vehicles/weapons/diprip/machinegun_loop.wav" )
			vehicle.wpn:Play()
			vehicle:CallOnRemove( "stop_fire1_sounds", function( vehicle )
				if vehicle.wpn then
					vehicle.wpn:Stop()
				end
			end)
		else
			if vehicle.mg_ammo <= 0 then
				vehicle:EmitSound("Weapon_Shotgun.Empty")
			end
			if vehicle.wpn then
				vehicle.wpn:Stop()
				vehicle.wpn = nil
			end
		end
	end
	
	if vehicle.OldFire2 ~= fire2 then
		vehicle.OldFire2 = fire2
		if fire2 then
			vehicle.wpn2 = CreateSound( vehicle, "simulated_vehicles/weapons/diprip/minigun_loop.wav" )
			vehicle.wpn2:Play()
			vehicle:CallOnRemove( "stop_fire2_sounds", function( vehicle )
				if vehicle.wpn2 then
					vehicle.wpn2:Stop()
				end
			end)
		else
			if vehicle.mg_ammo <= 0 then
				vehicle:EmitSound("Weapon_Shotgun.Empty")
			end
			if vehicle.wpn2 then
				vehicle.wpn2:Stop()
				vehicle.wpn2 = nil
			end
		end
	end
end
