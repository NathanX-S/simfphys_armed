resource.AddWorkshop("831680603")

simfphys = istable( simfphys ) and simfphys or {}

simfphys.ManagedVehicles = istable( simfphys.ManagedVehicles ) and simfphys.ManagedVehicles or {}
simfphys.Weapons = istable( simfphys.Weapons ) and simfphys.Weapons or {}
simfphys.weapon = {}

util.AddNetworkString( "simfphys_register_tank" )
util.AddNetworkString( "simfphys_tank_do_effect" )

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
	name = "tiger_fire_mg",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 110,
	pitch = { 90, 110 },
	sound = "^simulated_vehicles/weapons/tiger_mg.wav"
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
	name = "taucannon_fire",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 95, 105 },
	sound = "weapons/gauss/fire1.wav"
} )

function simfphys.RegisterCamera( ent, offset_firstperson, offset_thirdperson, bLocalAng )
	if not IsValid( ent ) then return end
	
	offset_firstperson = isvector( offset_firstperson ) and offset_firstperson or Vector(0,0,0)
	offset_thirdperson = isvector( offset_thirdperson ) and offset_thirdperson or Vector(0,0,0)
	
	ent:SetNWBool( "simfphys_SpecialCam", true )
	ent:SetNWBool( "SpecialCam_LocalAngles",  bLocalAng or false )
	ent:SetNWVector( "SpecialCam_Firstperson", offset_firstperson )
	ent:SetNWVector( "SpecialCam_Thirdperson", offset_thirdperson )
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
	if not IsValid( vehicle ) then return end
	
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

for k,v in pairs( simfphys.WeaponsGetAll() ) do
	local name = string.Explode( ".", v )[1]
	
	include("simfphys_weapons/"..v)
	
	simfphys.Weapons[ name ] = table.Copy( simfphys.weapon )
end


hook.Add("PlayerSpawnedVehicle","simfphys_armedvehicles", function( ply, vehicle )
	if not simfphys.IsCar( vehicle ) then return end
	
	timer.Simple( 0.2, function()
		simfphys.RegisterEquipment( vehicle )
	end)
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
