simWeapons = simWeapons or {}

local function GaussFire(ply,vehicle,shootOrigin,Attachment,damage)
	vehicle:EmitSound("simulated_vehicles/weapons/tau_fire"..math.Round(math.random(1,4),0)..".ogg")
	
	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= shootOrigin
		bullet.Dir 			= Attachment.Ang:Forward()
		bullet.Spread 		= Vector(0.01,0.01,0)
		bullet.Tracer		= 1
		bullet.TracerName 	= "simfphys_gausstracer"
		bullet.Force		= damage
		bullet.Damage		= damage * 1.5
		bullet.HullSize		= 1
		bullet.Callback = function(att, tr, dmginfo)
			local effect = ents.Create("env_spark")
				effect:SetKeyValue("targetname", "target")
				effect:SetPos( tr.HitPos + tr.HitNormal * 2 )
				effect:SetAngles( tr.HitNormal:Angle() )
				effect:Spawn()
				effect:SetKeyValue("spawnflags","128")
				effect:SetKeyValue("Magnitude",5)
				effect:SetKeyValue("TrailLength",3)
				effect:Fire( "SparkOnce" )
				effect:Fire("kill","",0.21)
				
			util.Decal("fadingscorch", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal)
		end
		bullet.Attacker 	= ply
		
	vehicle:FireBullets( bullet )
	
	vehicle:GetPhysicsObject():ApplyForceOffset( -Attachment.Ang:Forward() * damage * 1000, shootOrigin ) 
end

function simWeapons.taucannon( ply, pod, vehicle )
	local curtime = CurTime()
	
	if !IsValid(ply) then 
		if (vehicle.afire_pressed) then
			vehicle.afire_pressed = false
			vehicle.wpn_chr:Stop()
			vehicle.wpn_chr = nil
			vehicle.gausscharge = 0
			vehicle.NextShoot = curtime + 0.6
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
	
	local fire = ply:KeyDown( IN_ATTACK )
	local alt_fire = ply:KeyDown( IN_ATTACK2 )
	
	vehicle.afire_pressed = vehicle.afire_pressed or false
	vehicle.gausscharge = vehicle.gausscharge and (vehicle.gausscharge + math.Clamp((alt_fire and 100 or 0) - vehicle.gausscharge,0,1)) or 0
	
	if (vehicle.wpn_chr) then
		vehicle.wpn_chr:ChangePitch(100 + vehicle.gausscharge * 1.5)
		
		vehicle.gaus_pp_spin = vehicle.gaus_pp_spin and (vehicle.gaus_pp_spin + vehicle.gausscharge / 2) or 0
		vehicle:SetPoseParameter("gun_spin", vehicle.gaus_pp_spin)
	end
	
	vehicle.NextShoot = vehicle.NextShoot or 0
	if (vehicle.NextShoot < curtime) then
		if (fire) then
			GaussFire(ply,vehicle,shootOrigin,Attachment,12)
			vehicle.NextShoot = curtime + 0.2
		end
		
		if (alt_fire != vehicle.afire_pressed) then
			vehicle.afire_pressed = alt_fire
			if (alt_fire) then
				vehicle.wpn_chr = CreateSound( vehicle, "weapons/gauss/chargeloop.wav" )
				vehicle.wpn_chr:Play()
				vehicle:CallOnRemove( "stopmesounds", function( vehicle )
					if (vehicle.wpn_chr) then
						vehicle.wpn_chr:Stop()
					end
				end)
			else
				vehicle.wpn_chr:Stop()
				vehicle.wpn_chr = nil
				GaussFire(ply,vehicle,shootOrigin,Attachment,12 + vehicle.gausscharge * 2)
				vehicle.gausscharge = 0
				
				vehicle.NextShoot = curtime + 0.6
			end
		end
	end
end
