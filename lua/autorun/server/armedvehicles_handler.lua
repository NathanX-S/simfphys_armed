resource.AddWorkshop("831680603")

simfphys = istable( simfphys ) and simfphys or {}

simfphys.ManagedVehicles = istable( simfphys.ManagedVehicles ) and simfphys.ManagedVehicles or {}
simfphys.Weapons = {}
simfphys.weapon = {}

util.AddNetworkString( "simfphys_register_tank" )
util.AddNetworkString( "simfphys_tank_do_effect" )
util.AddNetworkString( "simfphys_update_tracks" )

sound.Add( {
	name = "apc_fire",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 110,
	pitch = { 90, 110 },
	sound = "^simulated_vehicles/weapons/apc_fire.wav"
} )

sound.Add( {
	name = "tiger_fire",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = { 90, 110 },
	sound = "^simulated_vehicles/weapons/tiger_cannon.wav"
} )

sound.Add( {
	name = "leopard_fire",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = { 90, 110 },
	sound = "^simulated_vehicles/weapons/leopard_cannon.wav"
} )

sound.Add( {
	name = "t90ms_fire",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = { 90, 110 },
	sound = "^simulated_vehicles/weapons/t90ms_cannon.wav"
} )

sound.Add( {
	name = "tiger_fire_mg",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 110,
	pitch = { 90, 110 },
	sound = "^simulated_vehicles/weapons/tiger_mg.wav"
} )

sound.Add( {
	name = "tiger_fire_mg_new",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 110,
	pitch = { 90, 110 },
	sound = {"^simulated_vehicles/weapons/tiger_mg1.wav","^simulated_vehicles/weapons/tiger_mg2.wav","^simulated_vehicles/weapons/tiger_mg3.wav"}
} )

sound.Add( {
	name = "tiger_reload",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 70,
	pitch = { 90, 110 },
	sound = "simulated_vehicles/weapons/tiger_reload.wav"
} )

sound.Add( {
	name = "sherman_fire",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = { 90, 110 },
	sound = "^simulated_vehicles/weapons/sherman_cannon.wav"
} )

sound.Add( {
	name = "sherman_fire_mg",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 110,
	pitch = { 90, 110 },
	sound = "^simulated_vehicles/weapons/sherman_mg.wav"
} )

sound.Add( {
	name = "sherman_reload",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 70,
	pitch = { 90, 110 },
	sound = "simulated_vehicles/weapons/sherman_reload.wav"
} )

sound.Add( {
	name = "t90ms_reload",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 70,
	pitch = { 90, 110 },
	sound = "simulated_vehicles/weapons/t90ms_reload.wav"
} )

sound.Add( {
	name = "taucannon_fire",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 95, 105 },
	sound = "weapons/gauss/fire1.wav"
} )

function simfphys.RegisterCamera( ent, offset_firstperson, offset_thirdperson, bLocalAng, attachment )
	if not IsValid( ent ) then return end
	
	offset_firstperson = isvector( offset_firstperson ) and offset_firstperson or Vector(0,0,0)
	offset_thirdperson = isvector( offset_thirdperson ) and offset_thirdperson or Vector(0,0,0)
	
	ent:SetNWBool( "simfphys_SpecialCam", true )
	ent:SetNWBool( "SpecialCam_LocalAngles",  bLocalAng or false )
	ent:SetNWVector( "SpecialCam_Firstperson", offset_firstperson )
	ent:SetNWVector( "SpecialCam_Thirdperson", offset_thirdperson )
	
	if isstring( attachment ) then 
		ent:SetNWString( "SpecialCam_Attachment", attachment )
	end
end

function simfphys.FirePhysProjectile( data )
	if not data then return end
	if not istable( data.filter ) then return end
	if not isvector( data.shootOrigin ) then return end
	if not isvector( data.shootDirection ) then return end
	if not IsValid( data.attacker ) then return end
	if not IsValid( data.attackingent ) then return end
	if not isnumber( data.DeflectAng ) then data.DeflectAng = 0 end
	
	local projectile = ents.Create( "simfphys_tankprojectile" )
	projectile:SetPos( data.shootOrigin )
	projectile:SetAngles( data.shootDirection:Angle() )
	projectile:SetOwner( data.attackingent )
	projectile.Attacker = data.attacker
	projectile.DeflectAng = data.DeflectAng
	projectile.AttackingEnt = data.attackingent 
	
	local filter = data.filter 
	table.insert( filter, projectile )
	
	projectile.Force = data.Force and data.Force or 100
	projectile.Damage = data.Damage and data.Damage or 100
	projectile.BlastRadius = data.BlastRadius and data.BlastRadius or 200
	projectile.BlastDamage = data.BlastDamage and data.BlastDamage or 50
	projectile:SetBlastEffect( isstring( data.BlastEffect ) and data.BlastEffect or "simfphys_tankweapon_explosion" )
	projectile:SetSize( data.Size and data.Size or 1 )
	projectile.Filter = filter
	projectile:Spawn()
	projectile:Activate()
end

local ImpactSounds = {
	"physics/metal/metal_sheet_impact_bullet2.wav",
	"physics/metal/metal_sheet_impact_hard2.wav",
	"physics/metal/metal_sheet_impact_hard6.wav",
}

function simfphys.FireHitScan( data )
	if not data then return end
	if not istable( data.filter ) then return end
	if not isvector( data.shootOrigin ) then return end
	if not isvector( data.shootDirection ) then return end
	if not IsValid( data.attacker ) then return end
	if not IsValid( data.attackingent ) then return end
	
	data.Spread = data.Spread or Vector(0,0,0)
	data.Tracer = data.Tracer or 0
	data.HullSize = data.HullSize or 1
	
	local trace = util.TraceHull( {
		start = data.shootOrigin,
		endpos = data.shootOrigin + (data.shootDirection + Vector(math.Rand(-data.Spread.x,data.Spread.x),math.Rand(-data.Spread.y,data.Spread.y),math.Rand(-data.Spread.x,data.Spread.x)) )* 50000,
		filter = data.filter,
		maxs = data.HullSize,
		mins = -data.HullSize
	} )
	
	local bullet = {}
	bullet.Num 			= 1
	bullet.Src 			= trace.HitPos - data.shootDirection * 5
	bullet.Dir 			= data.shootDirection
	bullet.Spread 		= Vector(0,0,0)
	bullet.TracerName	= "simfphys_tracer_hit"
	bullet.Tracer		= 1
	bullet.Force		= (data.Force and data.Force or 1)
	bullet.Damage		= (data.Damage and data.Damage or 1)
	bullet.HullSize		= data.HullSize
	bullet.Attacker 		= data.attacker
	bullet.Callback = function(att, tr, dmginfo)
		if tr.Entity ~= Entity(0) then
			if simfphys.IsCar( tr.Entity ) then
				--sound.Play( Sound( "weapons/fx/rics/ric"..math.random(1,5)..".wav" ), tr.HitPos, 60)
				sound.Play( Sound( ImpactSounds[ math.random(1,table.Count( ImpactSounds )) ] ), tr.HitPos, 140)
			end
		end
	end
	data.attackingent:FireBullets( bullet )
	
	data.attackingent.hScanTracer = data.attackingent.hScanTracer and (data.attackingent.hScanTracer + 1) or 0
	
	if data.Tracer > 0 then
		if data.attackingent.hScanTracer >= data.Tracer then 
			data.attackingent.hScanTracer = 0
			
			local effectdata = EffectData()
			effectdata:SetStart( data.shootOrigin ) 
			effectdata:SetOrigin( trace.HitPos )
			util.Effect( "simfphys_tracer", effectdata )
		end
	end
end

function simfphys.RegisterCrosshair( ent, data )
	if not IsValid( ent ) then return end
	
	local data = istable( data ) and data or {}
	
	local Base = data.Attachment or "muzzle"
	local Dir = data.Direction or Vector(1,0,0)
	local Type = data.Type and data.Type or 0
	
	ent:SetNWInt( "CrosshairType", Type )
	ent:SetNWBool( "HasCrosshair", true )
	ent:SetNWString( "Attachment", Base )
	ent:SetNWVector( "Direction", Dir )
	
	if data.Attach_Start_Left and data.Attach_Start_Right then
		ent:SetNWBool( "CalcCenterPos", true )
		ent:SetNWString( "Start_Left", data.Attach_Start_Left )
		ent:SetNWString( "Start_Right", data.Attach_Start_Right )
	end
end

function simfphys.WeaponsGetAll()
	local weapons = file.Find("simfphys_weapons/*.lua", "LUA")
	
	return weapons
end

function simfphys.RegisterEquipment( vehicle )
	print("SIMFPHYS ARMED: RegisterEquipment() is no longer needed")
end

function simfphys.armedAutoRegister( vehicle )
	if not IsValid( vehicle ) then return end
	
	simfphys.Weapons = istable( simfphys.Weapons ) and table.Empty( simfphys.Weapons ) or {}
	
	for k,v in pairs( simfphys.WeaponsGetAll() ) do
		local name = string.Explode( ".", v )[1]
		
		include("simfphys_weapons/"..v)
		
		simfphys.Weapons[ name ] = table.Copy( simfphys.weapon )
	end
	
	local class = vehicle:GetSpawn_List()
	
	for wpnname,tbldata in pairs( simfphys.Weapons ) do
		for _,v in pairs( tbldata.ValidClasses() ) do
			if class == v then
				local data = {}
				data.entity = vehicle
				data.func = tbldata

				table.insert(simfphys.ManagedVehicles, data)

				tbldata.Initialize( tbldata, vehicle )
			end
		end
	end
end

local function DamageVehicle( ent , damage, type )
	if not simfphys.DamageEnabled then return end
	
	local MaxHealth = ent:GetMaxHealth()
	local CurHealth = ent:GetCurHealth()
	
	local NewHealth = math.max( math.Round(CurHealth - damage,0) , 0 )
	
	if NewHealth <= (MaxHealth * 0.6) then
		if NewHealth <= (MaxHealth * 0.3) then
			ent:SetOnFire( true )
			ent:SetOnSmoke( false )
		else
			ent:SetOnSmoke( true )
		end
	end
	
	if MaxHealth > 30 and NewHealth <= 31 then
		if ent:EngineActive() then
			ent:DamagedStall()
		end
	end
	
	if NewHealth <= 0 then
		if type ~= DMG_GENERIC and type ~= DMG_CRUSH or damage > 400 then
			
			DestroyVehicle( ent )
			
			return
		end
		
		if ent:EngineActive() then
			ent:DamagedStall()
		end
		
		return
	end
	
	ent:SetCurHealth( NewHealth )
end

local function DestroyVehicle( ent )
	if not IsValid( ent ) then return end
	if ent.destroyed then return end
	
	ent.destroyed = true
	
	local ply = ent.EntityOwner
	local skin = ent:GetSkin()
	local Col = ent:GetColor()
	Col.r = Col.r * 0.8
	Col.g = Col.g * 0.8
	Col.b = Col.b * 0.8
	
	local bprop = ents.Create( "gmod_sent_vehicle_fphysics_gib" )
	bprop:SetModel( ent:GetModel() )			
	bprop:SetPos( ent:GetPos() )
	bprop:SetAngles( ent:GetAngles() )
	bprop:Spawn()
	bprop:Activate()
	bprop:GetPhysicsObject():SetVelocity( ent:GetVelocity() + Vector(math.random(-5,5),math.random(-5,5),math.random(150,250)) ) 
	bprop:GetPhysicsObject():SetMass( ent.Mass * 0.75 )
	bprop.DoNotDuplicate = true
	bprop.MakeSound = true
	bprop:SetColor( Col )
	bprop:SetSkin( skin )
	
	ent.Gib = bprop
	
	simfphys.SetOwner( ply , bprop )
	
	if IsValid( ply ) then
		undo.Create( "Gib" )
		undo.SetPlayer( ply )
		undo.AddEntity( bprop )
		undo.SetCustomUndoText( "Undone Gib" )
		undo.Finish( "Gib" )
		ply:AddCleanup( "Gibs", bprop )
	end
	
	if ent.CustomWheels == true and not ent.NoWheelGibs then
		for i = 1, table.Count( ent.GhostWheels ) do
			local Wheel = ent.GhostWheels[i]
			if IsValid(Wheel) then
				local prop = ents.Create( "gmod_sent_vehicle_fphysics_gib" )
				prop:SetModel( Wheel:GetModel() )			
				prop:SetPos( Wheel:LocalToWorld( Vector(0,0,0) ) )
				prop:SetAngles( Wheel:LocalToWorldAngles( Angle(0,0,0) ) )
				prop:SetOwner( bprop )
				prop:Spawn()
				prop:Activate()
				prop:GetPhysicsObject():SetVelocity( ent:GetVelocity() + Vector(math.random(-5,5),math.random(-5,5),math.random(0,25)) )
				prop:GetPhysicsObject():SetMass( 20 )
				prop.DoNotDuplicate = true
				bprop:DeleteOnRemove( prop )
				
				simfphys.SetOwner( ply , prop )
			end
		end
	end
	
	local Driver = ent:GetDriver()
	if IsValid( Driver ) then
		if ent.RemoteDriver ~= Driver then
			Driver:TakeDamage( Driver:Health() + Driver:Armor(), ent.LastAttacker or Entity(0), ent.LastInflictor or Entity(0) )
		end
	end
	
	if ent.PassengerSeats then
		for i = 1, table.Count( ent.PassengerSeats ) do
			local Passenger = ent.pSeat[i]:GetDriver()
			if IsValid( Passenger ) then
				Passenger:TakeDamage( Passenger:Health() + Passenger:Armor(), ent.LastAttacker or Entity(0), ent.LastInflictor or Entity(0) )
			end
		end
	end
	
	ent:Extinguish() 
	
	ent:OnDestroyed()
	
	ent:Remove()
end

local function bcDamage( vehicle , position , cdamage )
	if not simfphys.DamageEnabled then return end
	
	cdamage = cdamage or false
	net.Start( "simfphys_spritedamage" )
		net.WriteEntity( vehicle )
		net.WriteVector( position ) 
		net.WriteBool( cdamage ) 
	net.Broadcast()
end

function simfphys.TankDamageSystem(ent, dmginfo)
	if not ent:IsInitialized() then return end
	
	local Damage = dmginfo:GetDamage() 
	local DamagePos = dmginfo:GetDamagePosition() 
	local Type = dmginfo:GetDamageType()
	local Driver = ent:GetDriver()
	
	ent.LastAttacker = dmginfo:GetAttacker() 
	ent.LastInflictor = dmginfo:GetInflictor()
	
	bcDamage( ent , ent:WorldToLocal( DamagePos ) )
	
	if Type == DMG_BLAST or Type == DMG_CRUSH or Type == DMG_GENERIC then
		if simfphys.DamageEnabled then
			local MaxHealth = ent:GetMaxHealth()
			local CurHealth = ent:GetCurHealth()
			
			local NewHealth = math.max( math.Round(CurHealth - Damage,0) , 0 )
			
			if NewHealth <= (MaxHealth * 0.6) then
				if NewHealth <= (MaxHealth * 0.3) then
					ent:SetOnFire( true )
					ent:SetOnSmoke( false )
				else
					ent:SetOnSmoke( true )
				end
			end
			
			if MaxHealth > 30 and NewHealth <= 31 then
				if ent:EngineActive() then
					ent:DamagedStall()
				end
			end
			
			if NewHealth <= 0 then
				if type ~= DMG_GENERIC and type ~= DMG_CRUSH or Damage > 400 then
					
					DestroyVehicle( ent )
					
					return
				end
				
				if ent:EngineActive() then
					ent:DamagedStall()
				end
				
				return
			end
			
			ent:SetCurHealth( NewHealth )
		end
	end
end

hook.Add("PlayerSpawnedVehicle","simfphys_armedvehicles", function( ply, vehicle )
	if not simfphys.IsCar( vehicle ) then return end
	
	if not simfphys.VERSION or simfphys.VERSION < 1.0 then
		print("SIMFPHYS ARMED: please update simfphys base")
		
		timer.Simple( 0.2, function()
			simfphys.armedAutoRegister( vehicle )
		end)
	end
end)

hook.Add("Think", "simfphys_weaponhandler", function()
	if simfphys.ManagedVehicles then
		for k, v in pairs( simfphys.ManagedVehicles ) do
			if IsValid( v.entity ) then
				if v.func then
					v.func.Think( v.func,v.entity )
				end
			else
				simfphys.ManagedVehicles[k] = nil
			end
		end
	end
end)
