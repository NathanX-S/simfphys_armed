
function simfphys.weapon:ValidClasses()
	
	local classes = {
		"sim_fphys_conscriptapc_armed2"
	}
	
	return classes
end

function simfphys.weapon:Initialize( vehicle )
	if not istable( vehicle.PassengerSeats ) or not istable( vehicle.pSeat ) then return end
	
	local pod = vehicle.pSeat[1]
	
	if not IsValid( pod ) then return end
	
	pod:SetNWBool( "IsGunnerSeat", true )
	pod:SetNWBool( "IsAPCSeat", true )
end

function simfphys.weapon:Think( vehicle )
	if not istable( vehicle.PassengerSeats ) or not istable( vehicle.pSeat ) then return end
	
	local pod = vehicle.pSeat[1]
	
	if not IsValid( pod ) then return end
	
	local ply = pod:GetDriver()
	
	local curtime = CurTime()
	
	if not IsValid(ply) then return end

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
	
	local a_forward = Attachment.Ang:Forward()
	local a_right = Attachment.Ang:Right()
	local a_up = Attachment.Ang:Up()
	
	local shootOrigin = Attachment.Pos + a_forward * 50 + a_right * 0 + a_up * 7 + deltapos * engine.TickInterval() 
	
	local Aimang = (Aimpos - shootOrigin):Angle()
	
	local Angles = vehicle:WorldToLocalAngles( Aimang ) - Angle(0,90,0)
	Angles:Normalize()
	
	vehicle:SetPoseParameter("vehicle_weapon_yaw", (pod:WorldToLocalAngles( ply:EyeAngles() - Angle(0,90,0) ).y / 180) * 121 )
	
	local fire = ply:KeyDown( IN_ATTACK )
	local reload = ply:KeyDown( IN_RELOAD )
	local maxclip = 35
	
	vehicle.NextShoot = vehicle.NextShoot or 0
	vehicle.clip = vehicle.clip or maxclip
	
	if reload and vehicle.clip ~= maxclip then
		vehicle:EmitSound("vehicles/tank_readyfire1.wav")
		vehicle.clip = maxclip
		vehicle.NextShoot = curtime + 2
		vehicle:SetIsCruiseModeOn( false )
	end
	
	if not fire then return end
	
	if vehicle.NextShoot > curtime then return end
	
	if vehicle.clip > 0 then
		vehicle.clip = vehicle.clip - 1
		
		vehicle.NextShoot = curtime + 0.1
		
		vehicle:EmitSound("Weapon_SMG1.NPC_Single")
		pod:EmitSound("Weapon_AR2.NPC_Single")
		
		local bullet = {}
			bullet.Num 			= 1
			bullet.Src 			= shootOrigin
			bullet.Dir 			= Aimang:Forward()
			bullet.Spread 		= Vector(0.015,0.015,0)
			bullet.Tracer		= 0
			bullet.Force		= 50
			bullet.Damage		= 50
			bullet.HullSize		= 10
			bullet.Attacker 	= ply
			bullet.Callback = function(att, tr, dmginfo)
				if tr.Entity ~= Entity(0) then
					if simfphys.IsCar( tr.Entity ) then
						local effectdata = EffectData()
							effectdata:SetOrigin( tr.HitPos, tr.HitNormal )
							effectdata:SetNormal( tr.HitNormal )
							effectdata:SetRadius( 3 )
						util.Effect( "cball_bounce", effectdata, true, true )
						
						sound.Play( Sound( "weapons/fx/rics/ric"..math.random(1,5)..".wav" ), tr.HitPos, 60)
					end
				end
			end
		vehicle:FireBullets( bullet )
		
		if vehicle.swapMuzzle then
			vehicle.swapMuzzle = false
		else
			vehicle.swapMuzzle = true
		end
		local s_Pos = vehicle.swapMuzzle and -2 or 3
		
		local effectdata = EffectData()
			effectdata:SetOrigin( shootOrigin + a_up * s_Pos )
			effectdata:SetAngles( Attachment.Ang )
			effectdata:SetScale( 1.5 )
			util.Effect( "MuzzleEffect", effectdata, true, true )
			
		vehicle:GetPhysicsObject():ApplyForceOffset( -Aimang:Forward() * 10000, shootOrigin )
	else
		vehicle:EmitSound("vehicles/tank_readyfire1.wav")
		vehicle.clip = maxclip
		vehicle.NextShoot = curtime + 2
	end
end