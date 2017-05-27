resource.AddWorkshop("831680603")

simfphys = istable( simfphys ) and simfphys or {}

simfphys.ManagedVehicles = istable( simfphys.ManagedVehicles ) and simfphys.ManagedVehicles or {}
simfphys.Weapons = istable( simfphys.Weapons ) and simfphys.Weapons or {}
simfphys.weapon = {}

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
