local AUTOMATIC = 1
local MANUAL = 2

local light_table = {
	L_HeadLampPos = Vector(71.9,32.85,-5.59),
	L_HeadLampAng = Angle(15,0,0),
	R_HeadLampPos = Vector(71.9,-32.85,-5.59),
	R_HeadLampAng = Angle(15,0,0),

	L_RearLampPos =Vector(-94,29.08,3.7),
	L_RearLampAng = Angle(40,180,0),
	R_RearLampPos = Vector(-94,-29.08,3.7),
	R_RearLampAng = Angle(40,180,0),
	
	Headlight_sprites = { 
		Vector(71.9,32.85,-5.59),
		Vector(71.9,-32.85,-5.59)
	},
	Headlamp_sprites = { 
		Vector(76.36,26.72,-5.79),
		Vector(76.36,-26.72,-5.79)
	},
	Rearlight_sprites = {
		Vector(-94,34.39,3.7),
		Vector(-94,-34.39,3.7)
	},
	Brakelight_sprites = {
		Vector(-94,29.08,3.7),
		Vector(-94,-29.08,3.7)
	}
}
list.Set( "simfphys_lights", "driprip_ratmobile", light_table)

local V = {
	Name = "DIPRIP - Ratmobile",
	Model = "models/ratmobile/ratmobile.mdl",
	Category = "Armed Vehicles",
	SpawnOffset = Vector(0,0,25),

	Members = {
		Mass = 4800,
		FrontWheelMass = 225,
		RearWheelMass = 225,
		
		LightsTable = "driprip_ratmobile",
		
		IsArmored = true,
		
		EnginePos = Vector(20,0,0),
		
		MaxHealth = 5000,
		
		FrontWheelRadius = 20,
		RearWheelRadius = 20,
		
		SeatOffset = Vector(-35,0,15),
		SeatPitch = 0,
		
		CustomMassCenter = Vector(0,0,-5),

		ExhaustPositions = {
			{
				pos = Vector(6.54,44.25,13.19),
				ang = Angle(-15,0,0)
			},
			{
				pos = Vector(-1.85,44.15,14.79),
				ang = Angle(-15,0,0)
			},
			{
				pos = Vector(-9.87,44.49,16.03),
				ang = Angle(-15,0,0)
			},
			{
				pos = Vector(6.54,-44.25,13.19),
				ang = Angle(-15,0,0)
			},
			{
				pos = Vector(-1.85,-44.15,14.79),
				ang = Angle(-15,0,0)
			},
			{
				pos = Vector(-9.87,-44.49,16.03),
				ang = Angle(-15,0,0)
			},
			{
				pos = Vector(-92.45,20.94,-6.35),
				ang = Angle(-90,0,0)
			},
			{
				pos = Vector(-92.45,-20.94,-6.35),
				ang = Angle(-90,0,0)
			},
		},

		FrontHeight = 16,
		FrontConstant = 70000,
		FrontDamping = 6000,
		FrontRelativeDamping = 6000,
		
		RearHeight = 16.5,
		RearConstant = 70000,
		RearDamping = 6000,
		RearRelativeDamping = 6000,
		
		StrengthenSuspension = true,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 140,
		Efficiency = 1,
		GripOffset = 5,
		BrakePower = 120,
		BulletProofTires = true,
		
		IdleRPM = 750,
		LimitRPM = 7500,
		PeakTorque = 320,
		PowerbandStart = 1500,
		PowerbandEnd = 6500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = true,
		
		PowerBias = 0.25,
		
		EngineSoundPreset = 0,
		
		Sound_Idle = "simulated_vehicles/ratmobile/idle.wav",
		Sound_IdlePitch = 1,
		
		Sound_Mid = "simulated_vehicles/ratmobile/loop.wav",
		Sound_MidPitch = 0.9,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 100,
		Sound_MidFadeOutRate = 1,
		
		Sound_HighPitch = 0,
		Sound_HighVolume = 0,
		Sound_HighFadeInRPMpercent = 0,
		Sound_HighFadeInRate = 0,
		
		Sound_ThrottlePitch = 0,
		Sound_ThrottleVolume = 0,
		
		snd_horn = "common/null.wav",
		
		ForceTransmission = AUTOMATIC,
		
		DifferentialGear = 0.28,
		Gears = {-0.1,0,0.1,0.2,0.3,0.4,0.5}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_ratmobile", V )

local V = {
	Name = "DIPRIP - Chaos126p",
	Model = "models/chaos126p/chaos126p.mdl",
	Category = "Armed Vehicles",
	SpawnOffset = Vector(0,0,30),

	Members = {
		Mass = 4800,
		FrontWheelMass = 225,
		RearWheelMass = 225,
		
		--LightsTable = "driprip_ratmobile",
		
		IsArmored = true,
		
		EnginePos = Vector(49.98,0,14.16),
		
		MaxHealth = 5000,
		
		FrontWheelRadius = 22,
		RearWheelRadius = 23.5,
		
		SeatOffset = Vector(-6,0,23),
		SeatPitch = 0,
		
		CustomMassCenter = Vector(0,0,0),

		ExhaustPositions = {
			{
				pos = Vector(-73.69,21.88,21.45),
				ang = Angle(0,0,0)
			},
			{
				pos = Vector(-77.48,23.3,16.93),
				ang = Angle(0,0,0)
			},
			{
				pos = Vector(-81.22,23.87,12.01),
				ang = Angle(0,0,0)
			},
			{
				pos = Vector(-75.21,6.14,-13.95),
				ang = Angle(-90,0,0)
			},
			
			{
				pos = Vector(-73.69,-21.88,21.45),
				ang = Angle(0,0,0)
			},
			{
				pos = Vector(-77.48,-23.3,16.93),
				ang = Angle(0,0,0)
			},
			{
				pos = Vector(-81.22,-23.87,12.01),
				ang = Angle(0,0,0)
			},
			{
				pos = Vector(-75.21,-6.14,-13.95),
				ang = Angle(-90,0,0)
			},
		},

		FrontHeight = 17,
		FrontConstant = 70000,
		FrontDamping = 8000,
		FrontRelativeDamping = 8000,
		
		RearHeight = 18,
		RearConstant = 70000,
		RearDamping = 8000,
		RearRelativeDamping = 8000,
		
		StrengthenSuspension = true,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 140,
		Efficiency = 1,
		GripOffset = 5,
		BrakePower = 120,
		BulletProofTires = true,
		
		IdleRPM = 750,
		LimitRPM = 7500,
		PeakTorque = 280,
		PowerbandStart = 1500,
		PowerbandEnd = 6500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = true,
		
		PowerBias = 0.25,
		
		EngineSoundPreset = 0,
		
		Sound_Idle = "simulated_vehicles/4banger/4banger_idle.wav",
		Sound_IdlePitch = 1,
		
		Sound_Mid = "simulated_vehicles/4banger/4banger_mid.wav",
		Sound_MidPitch = 0.85,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 100,
		Sound_MidFadeOutRate = 1,
		
		Sound_HighPitch = 0,
		Sound_HighVolume = 0,
		Sound_HighFadeInRPMpercent = 0,
		Sound_HighFadeInRate = 0,
		
		Sound_ThrottlePitch = 0,
		Sound_ThrottleVolume = 0,
		
		snd_horn = "common/null.wav",
		
		ForceTransmission = AUTOMATIC,
		
		DifferentialGear = 0.25,
		Gears = {-0.1,0,0.1,0.2,0.3,0.4,0.5}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_chaos126p", V )

local V = {
	Name = "DIPRIP - Hedgehog",
	Model = "models/hedgehog/hedgehog.mdl",
	Category = "Armed Vehicles",
	SpawnOffset = Vector(0,0,25),

	Members = {
		Mass = 4800,
		FrontWheelMass = 225,
		RearWheelMass = 225,
		
		--LightsTable = "driprip_ratmobile",
		
		IsArmored = true,
		
		EnginePos = Vector(-83.52,0,30.16),
		
		MaxHealth = 5000,
		
		FrontWheelRadius = 16,
		RearWheelRadius = 16,
		
		SeatOffset = Vector(-25,0,37),
		SeatPitch = 0,
		
		CustomMassCenter = Vector(0,0,2),

		ExhaustPositions = {
			{
				pos = Vector(-77.06,11.36,43.69),
				ang = Angle(0,0,15)
			},
			{
				pos = Vector(-82.32,11.36,43.69),
				ang = Angle(0,0,15)
			},
			{
				pos = Vector(-87.7,11.36,43.69),
				ang = Angle(0,0,15)
			},
			{
				pos = Vector(-103.14,16.92,-6),
				ang = Angle(-90,0,0)
			},
			{
				pos = Vector(-77.06,-11.36,43.69),
				ang = Angle(0,0,-15)
			},
			{
				pos = Vector(-82.32,-11.36,43.69),
				ang = Angle(0,0,-15)
			},
			{
				pos = Vector(-87.7,-11.36,43.69),
				ang = Angle(0,0,-15)
			},
			{
				pos = Vector(-103.14,-16.92,-6),
				ang = Angle(-90,0,0)
			},
		},

		FrontHeight = 15,
		FrontConstant = 70000,
		FrontDamping = 8500,
		FrontRelativeDamping = 8500,
		
		RearHeight = 15,
		RearConstant = 70000,
		RearDamping = 8500,
		RearRelativeDamping = 8500,
		
		StrengthenSuspension = true,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 140,
		Efficiency = 1,
		GripOffset = 5,
		BrakePower = 120,
		BulletProofTires = true,
		
		IdleRPM = 750,
		LimitRPM = 7500,
		PeakTorque = 300,
		PowerbandStart = 1500,
		PowerbandEnd = 6500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = true,
		
		PowerBias = 0.25,
		
		EngineSoundPreset = 0,
		
		Sound_Idle = "simulated_vehicles/hedgehog/idle.wav",
		Sound_IdlePitch = 1,
		
		Sound_Mid = "simulated_vehicles/hedgehog/loop.wav",
		Sound_MidPitch = 0.8,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 100,
		Sound_MidFadeOutRate = 1,
		
		Sound_HighPitch = 0,
		Sound_HighVolume = 0,
		Sound_HighFadeInRPMpercent = 0,
		Sound_HighFadeInRate = 0,
		
		Sound_ThrottlePitch = 0,
		Sound_ThrottleVolume = 0,
		
		snd_horn = "common/null.wav",
		
		ForceTransmission = AUTOMATIC,
		
		DifferentialGear = 0.32,
		Gears = {-0.1,0,0.1,0.2,0.3,0.4,0.5}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_hedgehog", V )
