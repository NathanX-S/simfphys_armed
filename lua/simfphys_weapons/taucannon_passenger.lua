
local function GaussFire(ply,vehicle,shootOrigin,Attachment,damage)
	vehicle:EmitSound("taucannon_fire")
	
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
		bullet.DisableOverride = true
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

function simfphys.weapon:ValidClasses()
	
	local classes = {
		"sim_fphys_v8elite_armed"
	}
	
	return classes
end

function simfphys.weapon:Initialize( vehicle )
	vehicle:SetBodygroup(1,1)
	
	local pod = vehicle.pSeat[1]
	
	simfphys.RegisterCrosshair( pod )
end

function simfphys.weapon:AimWeapon( ply, vehicle, pod )
	local Aimang = ply:EyeAngles()
	
	local Angles = vehicle:WorldToLocalAngles( Aimang ) - Angle(0,90,0)
	Angles:Normalize()
	
	local Rate = 3
	
	vehicle.sm_pp_yaw = vehicle.sm_pp_yaw and (vehicle.sm_pp_yaw + math.Clamp(Angles.y - vehicle.sm_pp_yaw,-Rate,Rate) ) or 0
	vehicle.sm_pp_pitch = vehicle.sm_pp_pitch and ( vehicle.sm_pp_pitch + math.Clamp(Angles.p - vehicle.sm_pp_pitch,-Rate,Rate) ) or 0
	
	vehicle:SetPoseParameter("vehicle_weapon_yaw", -vehicle.sm_pp_yaw )
	vehicle:SetPoseParameter("vehicle_weapon_pitch", -vehicle.sm_pp_pitch )
end

function simfphys.weapon:Think( vehicle )
	if not istable( vehicle.PassengerSeats ) or not istable( vehicle.pSeat ) then return end
	
	local pod = vehicle.pSeat[1]
	
	if not IsValid( pod ) then return end
	
	local ply = pod:GetDriver()
	
	local curtime = CurTime()
	
	if not IsValid( ply ) then 
		if vehicle.wpn then
			vehicle.wpn:Stop()
			vehicle.wpn = nil
		end
		
		return
	end
	
	local ID = vehicle:LookupAttachment( "muzzle" )
	local Attachment = vehicle:GetAttachment( ID )
	
	self:AimWeapon( ply, vehicle, pod )
	
	vehicle.wOldPos = vehicle.wOldPos or Vector(0,0,0)
	local deltapos = vehicle:GetPos() - vehicle.wOldPos
	vehicle.wOldPos = vehicle:GetPos()

	local shootOrigin = Attachment.Pos + deltapos * engine.TickInterval()
	
	local fire = ply:KeyDown( IN_ATTACK )
	local alt_fire = ply:KeyDown( IN_ATTACK2 )
	
	vehicle.afire_pressed = vehicle.afire_pressed or false
	vehicle.gausscharge = vehicle.gausscharge and (vehicle.gausscharge + math.Clamp((alt_fire and 100 or 0) - vehicle.gausscharge,0,1)) or 0
	
	if vehicle.wpn_chr then
		vehicle.wpn_chr:ChangePitch(100 + vehicle.gausscharge * 1.5)
		
		vehicle.gaus_pp_spin = vehicle.gaus_pp_spin and (vehicle.gaus_pp_spin + vehicle.gausscharge / 2) or 0
		vehicle:SetPoseParameter("gun_spin", vehicle.gaus_pp_spin)
	end
	
	if fire and not alt_fire then
		self:PrimaryAttack( vehicle, ply, shootOrigin, Attachment )
	end
	
	if alt_fire ~= vehicle.afire_pressed then
		vehicle.afire_pressed = alt_fire
		if alt_fire then
			vehicle.wpn_chr = CreateSound( vehicle, "weapons/gauss/chargeloop.wav" )
			vehicle.wpn_chr:Play()
			vehicle:CallOnRemove( "stopmesounds", function( vehicle )
				if vehicle.wpn_chr then
					vehicle.wpn_chr:Stop()
				end
			end)
		else
			vehicle.wpn_chr:Stop()
			vehicle.wpn_chr = nil
			GaussFire(ply,vehicle,shootOrigin,Attachment,12 + vehicle.gausscharge * 2)
			vehicle.gausscharge = 0
			
			self:SetNextPrimaryFire( vehicle, CurTime() + 0.6 )
		end
	end
end

function simfphys.weapon:CanPrimaryAttack( vehicle )
	vehicle.NextShoot = vehicle.NextShoot or 0
	return vehicle.NextShoot < CurTime()
end

function simfphys.weapon:SetNextPrimaryFire( vehicle, time )
	vehicle.NextShoot = time
end

function simfphys.weapon:PrimaryAttack( vehicle, ply, shootOrigin, Attachment )
	if not self:CanPrimaryAttack( vehicle ) then return end
	
	GaussFire(ply,vehicle,shootOrigin,Attachment,12)
	
	self:SetNextPrimaryFire( vehicle, CurTime() + 0.2 )
end
