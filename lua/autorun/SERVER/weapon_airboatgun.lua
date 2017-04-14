simWeapons = simWeapons or {}

local function AirboatFire(ply,vehicle,shootOrigin,Attachment,damage)
	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= shootOrigin
		bullet.Dir 			= Attachment.Ang:Forward()
		bullet.Spread 		= Vector(0.04,0.04,0)
		bullet.Tracer		= 1
		bullet.TracerName 	= (damage > 10 and "AirboatGunHeavyTracer" or "AirboatGunTracer")
		bullet.Force		= damage
		bullet.Damage		= damage
		bullet.HullSize		= 1
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetOrigin(  tr.HitPos + tr.HitNormal )
				effectdata:SetNormal( tr.HitNormal )
				effectdata:SetRadius( (damage > 1) and 8 or 3 )
			util.Effect( "cball_bounce", effectdata, true, true )
		end
		bullet.Attacker 	= ply
		
	vehicle:FireBullets( bullet )
end

function simWeapons.airboatgun( ply, pod, vehicle )
	local curtime = CurTime()
	
	if !IsValid(ply) then 
		if vehicle.wpn then
			vehicle.wpn:Stop()
			vehicle.wpn = nil
		end
		return
	end

	ply:CrosshairEnable()
	
	local tr = util.TraceLine( {
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:GetAimVector() * 10000,
		filter = {vehicle}
	} )
	local Aimpos = tr.HitPos
	
	local ID = vehicle:LookupAttachment( "muzzle" )
	local Attachment = vehicle:GetAttachment( ID )
	
	vehicle.wOldPos = vehicle.wOldPos or Vector(0,0,0)
	local deltapos = vehicle:GetPos() - vehicle.wOldPos
	vehicle.wOldPos = vehicle:GetPos()

	local shootOrigin = Attachment.Pos + deltapos * engine.TickInterval()
	
	local Aimang = (Aimpos - shootOrigin):Angle()
	
	local Angles = vehicle:WorldToLocalAngles( Aimang ) - Angle(0,90,0)
	Angles:Normalize()
	
	vehicle.sm_pp_yaw = vehicle.sm_pp_yaw and (vehicle.sm_pp_yaw + (Angles.y - vehicle.sm_pp_yaw) * 0.2) or 0
	vehicle.sm_pp_pitch = vehicle.sm_pp_pitch and (vehicle.sm_pp_pitch + (Angles.p - vehicle.sm_pp_pitch) * 0.2) or 0
	
	vehicle:SetPoseParameter("vehicle_weapon_yaw", -vehicle.sm_pp_yaw )
	vehicle:SetPoseParameter("vehicle_weapon_pitch", -vehicle.sm_pp_pitch )
	
	vehicle.charge = vehicle.charge or 100
	
	local fire = ply:KeyDown( IN_ATTACK ) and vehicle.charge > 0
	
	if !fire then
		vehicle.charge = math.min(vehicle.charge + 0.3,100)
	end
	
	vehicle.OldFire = vehicle.OldFire or false
	if vehicle.OldFire != fire then
		vehicle.OldFire = fire
		if fire then
			vehicle.wpn = CreateSound( vehicle, "weapons/airboat/airboat_gun_loop2.wav" )
			vehicle.wpn:Play()
			vehicle:CallOnRemove( "stopmesounds", function( vehicle )
				if vehicle.wpn then
					vehicle.wpn:Stop()
				end
			end)
		else
			if vehicle.wpn then
				vehicle.wpn:Stop()
				vehicle.wpn = nil
			end

			vehicle:EmitSound("weapons/airboat/airboat_gun_lastshot"..math.Round(math.random(1,2),0)..".wav")
		end
	end
	
	vehicle.NextShoot = vehicle.NextShoot or 0
	if (vehicle.NextShoot < curtime) then
		if (fire) then
			AirboatFire(ply,vehicle,shootOrigin,Attachment,(vehicle.charge / 5))
			
			vehicle.charge = vehicle.charge - 0.5
			
			if vehicle.charge <= 0 then
				if vehicle.charge > -1 then
					vehicle:EmitSound("weapons/airboat/airboat_gun_energy"..math.Round(math.random(1,2),0)..".wav")
				end
				vehicle.charge = -50
			end
			
			vehicle.NextShoot = curtime + 0.05
		end
	end
end
