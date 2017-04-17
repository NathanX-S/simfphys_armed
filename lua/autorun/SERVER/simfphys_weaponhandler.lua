resource.AddWorkshop("831680603")

simWeapons = simWeapons or {}

if not istable( armeddipripvehicles ) then armeddipripvehicles = {} end
if not istable( armedAPCSTable ) then armedAPCSTable = {} end
if not istable( armedAPCSTable2 ) then armedAPCSTable2 = {} end
if not istable( armedCombineAPCSTable ) then armedCombineAPCSTable = {} end
if not istable( armedELITEJEEPSTable ) then armedELITEJEEPSTable = {} end
if not istable( armedELITEJEEPSTable2 ) then armedELITEJEEPSTable2 = {} end
if not istable( armedJEEPSTable ) then armedJEEPSTable = {} end
if not istable( armedJEEPSTable2 ) then armedJEEPSTable2 = {} end

hook.Add("PlayerSpawnedVehicle","simfphys_armedvehicles", function( ply, vehicle )
	timer.Simple( 0.2, function()
		if not IsValid( vehicle ) then return end
		if simfphys.IsCar( vehicle ) then
			local class = vehicle:GetSpawn_List()
			
			if class == "sim_fphys_ratmobile" or class == "sim_fphys_hedgehog" or class == "sim_fphys_chaos126p" then
				table.insert(armeddipripvehicles, vehicle)
			end
			
			if class == "sim_fphys_conscriptapc_armed" then
				table.insert(armedAPCSTable, vehicle)
			end
			
			if class == "sim_fphys_conscriptapc_armed2" then
				table.insert(armedAPCSTable2, vehicle)
			end
			
			if class == "sim_fphys_v8elite_armed" then
				table.insert(armedELITEJEEPSTable, vehicle)
				vehicle:SetBodygroup(1,1)
			end
			
			if class == "sim_fphys_jeep_armed" then
				table.insert(armedJEEPSTable, vehicle)
				vehicle:SetBodygroup(1,1)
			end
			
			if class == "sim_fphys_combineapc_armed" then
				table.insert(armedCombineAPCSTable, vehicle)
			end
			
			if class == "sim_fphys_jeep_armed2" then
				table.insert(armedJEEPSTable2, vehicle)
				
				local ID = vehicle:LookupAttachment( "gun_ref" )
				local attachmentdata = vehicle:GetAttachment( ID )
			
				local prop = ents.Create( "gmod_sent_vehicle_fphysics_attachment" )
				prop:SetModel( "models/airboatgun.mdl" )			
				prop:SetPos( attachmentdata.Pos )
				prop:SetAngles( attachmentdata.Ang )
				prop:SetOwner( self )
				prop:Spawn()
				prop:Activate()
				prop:SetNotSolid( true )
				prop:SetParent( vehicle, ID )
				prop.DoNotDuplicate = true
			end
			
			if class == "sim_fphys_v8elite_armed2" then
				table.insert(armedELITEJEEPSTable2, vehicle)
				
				local ID = vehicle:LookupAttachment( "gun_ref" )
				local attachmentdata = vehicle:GetAttachment( ID )
				
				local prop = ents.Create( "gmod_sent_vehicle_fphysics_attachment" )
				prop:SetModel( "models/airboatgun.mdl" )			
				prop:SetPos( attachmentdata.Pos )
				prop:SetAngles( attachmentdata.Ang )
				prop:SetOwner( self )
				prop:Spawn()
				prop:Activate()
				prop:SetNotSolid( true )
				prop:SetParent( vehicle, ID )
				prop.DoNotDuplicate = true
			end
		end
	end)
end)

local function HandleJEEPWeapons( vehicle )
	local pod = vehicle.DriverSeat
	
	if not IsValid(pod) then return end
	
	if not pod:GetNWBool( "IsGunnerSeat" ) then
		pod:SetNWBool( "IsGunnerSeat", true )
	end
	
	local ply = pod:GetDriver()
	
	simWeapons.taucannon( ply, pod, vehicle )
end

local function HandleJEEPWeapons2( vehicle )
	local pod = vehicle.DriverSeat
	
	if not IsValid(pod) then return end
	
	if not pod:GetNWBool( "IsGunnerSeat" ) then
		pod:SetNWBool( "IsGunnerSeat", true )
	end
	
	local ply = pod:GetDriver()
	
	simWeapons.airboatgun( ply, pod, vehicle )
end

local function HandleELITEJEEPWeapons( vehicle )
	if not istable( vehicle.PassengerSeats ) or not istable( vehicle.pSeat ) then return end
	
	local pod = vehicle.pSeat[1]
	
	if not IsValid(pod) then return end
	
	if not pod:GetNWBool( "IsGunnerSeat" ) then
		pod:SetNWBool( "IsGunnerSeat", true )
	end
	
	local ply = pod:GetDriver()
	
	simWeapons.taucannon( ply, pod, vehicle )
end

local function HandleELITEJEEPWeapons2( vehicle )
	if not istable( vehicle.PassengerSeats ) or not istable( vehicle.pSeat ) then return end
	
	local pod = vehicle.pSeat[1]
	
	if not IsValid( pod ) then return end
	
	if not pod:GetNWBool( "IsGunnerSeat" ) then
		pod:SetNWBool( "IsGunnerSeat", true )
	end
	
	local ply = pod:GetDriver()
	
	simWeapons.airboatgun( ply, pod, vehicle )
end

local function HandleCombineAPCWeapons( vehicle )
	local pod = vehicle.DriverSeat
	
	if not IsValid( pod ) then return end
	
	if not pod:GetNWBool( "IsGunnerSeat" ) then
		pod:SetNWBool( "IsGunnerSeat", true )
	end
	
	local ply = pod:GetDriver()
	
	simWeapons.combineAPC( ply, pod, vehicle )
end

local function HandleAPCWeapons( vehicle )
	
	if not istable( vehicle.PassengerSeats ) or not istable( vehicle.pSeat ) then return end
	
	local pod = vehicle.pSeat[1]
	
	if not IsValid( pod ) then return end
	
	if not pod:GetNWBool( "IsGunnerSeat" ) then
		pod:SetNWBool( "IsGunnerSeat", true )
		pod:SetNWBool( "IsAPCSeat", true )
	end
	
	local ply = pod:GetDriver()
	
	simWeapons.humanAPC( ply, pod, vehicle )
end

local function HandleAPCWeapons2( vehicle )
	
	if not istable( vehicle.PassengerSeats ) or not istable( vehicle.pSeat ) then return end
	
	local pod = vehicle.pSeat[1]
	
	if not IsValid( pod ) then return end
	
	if not pod:GetNWBool( "IsGunnerSeat" ) then
		pod:SetNWBool( "IsGunnerSeat", true )
		pod:SetNWBool( "IsAPCSeat", true )
	end
	
	local ply = pod:GetDriver()
	
	simWeapons.humanAPC2( ply, pod, vehicle )
end

local function HandleDIPRIPWeapons( vehicle )
	local pod = vehicle.DriverSeat
	
	if not IsValid(pod) then return end
	
	if not pod:GetNWBool( "IsGunnerSeat" ) then
		pod:SetNWBool( "IsGunnerSeat", true )
		pod:SetNWBool( "IsAPCSeat", true )
	end
	
	local ply = pod:GetDriver()
	
	vehicle.VehicleData["steerangle"] = 45
	
	simWeapons.dipripweaponset( ply, pod, vehicle )
end

hook.Add("Think", "simfphys_weaponhandler", function()
	if armeddipripvehicles then
		for k, v in pairs( armeddipripvehicles ) do
			if IsValid( v ) then
				HandleDIPRIPWeapons( v )
			else
				armeddipripvehicles[k] = nil
			end
		end
	end

	if armedCombineAPCSTable then
		for k, v in pairs( armedCombineAPCSTable ) do
			if IsValid( v ) then
				HandleCombineAPCWeapons( v )
			else
				armedCombineAPCSTable[k] = nil
			end
		end
	end
	
	if armedAPCSTable then
		for k, v in pairs( armedAPCSTable ) do
			if IsValid( v ) then
				HandleAPCWeapons( v )
			else
				armedAPCSTable[k] = nil
			end
		end
	end
	
	if armedAPCSTable2 then
		for k, v in pairs( armedAPCSTable2 ) do
			if IsValid( v ) then
				HandleAPCWeapons2( v )
			else
				armedAPCSTable2[k] = nil
			end
		end
	end
	
	if armedELITEJEEPSTable then
		for k, v in pairs( armedELITEJEEPSTable ) do
			if IsValid( v ) then
				HandleELITEJEEPWeapons( v )
			else
				armedELITEJEEPSTable[k] = nil
			end
		end
	end
	
	if armedJEEPSTable then
		for k, v in pairs( armedJEEPSTable ) do
			if IsValid( v ) then
				HandleJEEPWeapons( v )
			else
				armedJEEPSTable[k] = nil
			end
		end
	end
	
	if armedJEEPSTable2 then
		for k, v in pairs( armedJEEPSTable2 ) do
			if IsValid( v ) then
				HandleJEEPWeapons2( v )
			else
				armedJEEPSTable2[k] = nil
			end
		end
	end
	
	if armedELITEJEEPSTable2 then
		for k, v in pairs( armedELITEJEEPSTable2 ) do
			if IsValid( v ) then
				HandleELITEJEEPWeapons2( v )
			else
				armedELITEJEEPSTable2[k] = nil
			end
		end
	end
end)
