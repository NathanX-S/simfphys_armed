local AUTOMATIC = 1
local MANUAL = 2

local light_table = {	
	ems_sounds = {"ambient/alarms/apc_alarm_loop1.wav"},
}
list.Set( "simfphys_lights", "capc_siren", light_table)

local light_table = {
	L_HeadLampPos = Vector(20.15,133,21),
	L_HeadLampAng = Angle(15,90,0),
	R_HeadLampPos = Vector(-54.51,133,21),
	R_HeadLampAng = Angle(15,90,0),
	
	L_RearLampPos = Vector(-62.74,-161,27),
	L_RearLampAng = Angle(40,-90,0),
	R_RearLampPos = Vector(28.33,-161,27),
	R_RearLampAng = Angle(40,-90,0),
	
	Headlight_sprites = { 
		Vector(29.15,133,21),
		Vector(-63.66,133,21),
	},
	Headlamp_sprites = { 
		Vector(20.15,133,21),
		Vector(-54.51,133,21),
	},
	Rearlight_sprites = {
		Vector(-62.74,-161,27),
		Vector(28.33,-161,27)
	},
	Brakelight_sprites = {
		Vector(-62.74,-161,27),
		Vector(28.33,-161,27)
	}
}
list.Set( "simfphys_lights", "conapc_armed", light_table)

local V = {
	Name = "HL2 Combine APC",
	Model = "models/combine_apc.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Armed Vehicles",

	Members = {
		Mass = 3500,
		MaxHealth = 6000,
		
		LightsTable = "capc_siren",
		
		IsArmored = true,
		
		FrontWheelRadius = 28,
		RearWheelRadius = 28,
		
		SeatOffset = Vector(-25,0,104),
		SeatPitch = 0,
		
		PassengerSeats = {
		},
		
		FrontHeight = 10,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 3000,
		
		RearHeight = 10,
		RearConstant = 50000,
		RearDamping = 3000,
		RearRelativeDamping = 3000,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 70,
		Efficiency = 1.8,
		GripOffset = 0,
		BrakePower = 70,
		BulletProofTires = true,
		
		
		IdleRPM = 750,
		LimitRPM = 6000,
		PeakTorque = 100,
		PowerbandStart = 1500,
		PowerbandEnd = 5800,
		Turbocharged = false,
		Supercharged = false,
		
		PowerBias = 0,
		
		EngineSoundPreset = 0,
		
		Sound_Idle = "simulated_vehicles/c_apc/apc_idle.wav",
		Sound_IdlePitch = 1,
		
		Sound_Mid = "simulated_vehicles/c_apc/apc_mid.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 100,
		Sound_MidFadeOutRate = 1,
		
		Sound_High = "",
		
		Sound_Throttle = "",
		
		snd_horn = "ambient/alarms/apc_alarm_pass1.wav",
		
		ForceTransmission = AUTOMATIC,
		DifferentialGear = 0.3,
		Gears = {-0.1,0,0.1,0.2,0.3}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_combineapc_armed", V )

local V = {
	Name = "HL2 Jeep taucannon",
	Model = "models/buggy.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Armed Vehicles",

	Members = {
		Mass = 1700,
		
		LightsTable = "jeep",
		
		FrontWheelRadius = 18,
		RearWheelRadius = 20,

		SeatOffset = Vector(0,0,-2),
		SeatPitch = 0,

		FrontHeight = 13.5,
		FrontConstant = 27000,
		FrontDamping = 2800,
		FrontRelativeDamping = 2800,
		
		RearHeight = 13.5,
		RearConstant = 32000,
		RearDamping = 2900,
		RearRelativeDamping = 2900,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 44,
		Efficiency = 1.337,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = true,
		
		IdleRPM = 750,
		LimitRPM = 6500,
		PeakTorque = 100,
		PowerbandStart = 2200,
		PowerbandEnd = 6300,
		
		PowerBias = 0.5,
		
		EngineSoundPreset = -1,
		
		snd_pitch = 1,
		snd_idle = "simulated_vehicles/jeep/jeep_idle.wav",
		
		snd_low = "simulated_vehicles/jeep/jeep_low.wav",
		snd_low_revdown = "simulated_vehicles/jeep/jeep_revdown.wav",
		snd_low_pitch = 0.9,
		
		snd_mid = "simulated_vehicles/jeep/jeep_mid.wav",
		snd_mid_gearup = "simulated_vehicles/jeep/jeep_second.wav",
		snd_mid_pitch = 1,
		
		snd_horn = "simulated_vehicles/horn_1.wav",
		
		ForceTransmission = AUTOMATIC,
		DifferentialGear = 0.3,
		Gears = {-0.15,0,0.15,0.25,0.35,0.45}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_jeep_armed", V )


local V = {
	Name = "HL2 Jeep airboatgun",
	Model = "models/buggy.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Armed Vehicles",

	Members = {
		Mass = 1700,
		
		LightsTable = "jeep",
		
		FrontWheelRadius = 18,
		RearWheelRadius = 20,

		SeatOffset = Vector(0,0,-2),
		SeatPitch = 0,

		FrontHeight = 13.5,
		FrontConstant = 27000,
		FrontDamping = 2800,
		FrontRelativeDamping = 2800,
		
		RearHeight = 13.5,
		RearConstant = 32000,
		RearDamping = 2900,
		RearRelativeDamping = 2900,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 44,
		Efficiency = 1.337,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = true,
		
		IdleRPM = 750,
		LimitRPM = 6500,
		PeakTorque = 100,
		PowerbandStart = 2200,
		PowerbandEnd = 6300,
		
		PowerBias = 0.5,
		
		EngineSoundPreset = -1,
		
		snd_pitch = 1,
		snd_idle = "simulated_vehicles/jeep/jeep_idle.wav",
		
		snd_low = "simulated_vehicles/jeep/jeep_low.wav",
		snd_low_revdown = "simulated_vehicles/jeep/jeep_revdown.wav",
		snd_low_pitch = 0.9,
		
		snd_mid = "simulated_vehicles/jeep/jeep_mid.wav",
		snd_mid_gearup = "simulated_vehicles/jeep/jeep_second.wav",
		snd_mid_pitch = 1,
		
		snd_horn = "simulated_vehicles/horn_1.wav",
		
		ForceTransmission = AUTOMATIC,
		DifferentialGear = 0.3,
		Gears = {-0.15,0,0.15,0.25,0.35,0.45}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_jeep_armed2", V )

local V = {
	Name = "Synergy Elite Jeep taucannon",
	Model = "models/vehicles/buggy_elite.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Armed Vehicles",

	Members = {
		Mass = 1700,
		
		LightsTable = "elitejeep",
		
		FrontWheelRadius = 18,
		RearWheelRadius = 20,
		
		SeatOffset = Vector(0,0,-3),
		SeatPitch = 0,
		
		PassengerSeats = {
			{
			pos = Vector(16,-35,16),
			ang = Angle(0,0,0)
			}
		},
		
		Backfire = true,
		ExhaustPositions = {
			{
				pos = Vector(-15.69,-105.94,14.94),
				ang = Angle(90,-90,0)
			},
			{
				pos = Vector(16.78,-105.46,14.35),
				ang = Angle(90,-90,0)
			}
		},
		
		StrengthenSuspension = true,
		
		FrontHeight = 13.5,
		FrontConstant = 27000,
		FrontDamping = 2200,
		FrontRelativeDamping = 1500, 
		
		RearHeight = 13.5,
		RearConstant = 32000,
		RearDamping = 2200,
		RearRelativeDamping = 1500,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 44,
		Efficiency = 1.4,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = true,
		
		IdleRPM = 750,
		LimitRPM = 7500,
		PeakTorque = 100,
		PowerbandStart = 2500,
		PowerbandEnd = 7300,
		Turbocharged = false,
		Supercharged = false,
		
		PowerBias = 0.6,
		
		EngineSoundPreset = -1,
		
		snd_pitch = 1,
		snd_idle = "simulated_vehicles/v8elite/v8elite_idle.wav",
		
		snd_low = "simulated_vehicles/v8elite/v8elite_low.wav",
		snd_low_revdown = "simulated_vehicles/v8elite/v8elite_revdown.wav",
		snd_low_pitch = 0.8,
		
		snd_mid = "simulated_vehicles/v8elite/v8elite_mid.wav",
		snd_mid_gearup = "simulated_vehicles/v8elite/v8elite_second.wav",
		snd_mid_pitch = 1,
		
		snd_horn = "simulated_vehicles/horn_4.wav",
		
		DifferentialGear = 0.38,
		Gears = {-0.1,0,0.1,0.18,0.25,0.31,0.40}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_v8elite_armed", V )


local V = {
	Name = "Synergy Elite Jeep airboatgun",
	Model = "models/vehicles/buggy_elite.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Armed Vehicles",

	Members = {
		Mass = 1700,
		
		LightsTable = "elitejeep",
		
		FrontWheelRadius = 18,
		RearWheelRadius = 20,
		
		SeatOffset = Vector(0,0,-3),
		SeatPitch = 0,
		
		PassengerSeats = {
			{
			pos = Vector(16,-35,16),
			ang = Angle(0,0,0)
			}
		},
		
		Backfire = true,
		ExhaustPositions = {
			{
				pos = Vector(-15.69,-105.94,14.94),
				ang = Angle(90,-90,0)
			},
			{
				pos = Vector(16.78,-105.46,14.35),
				ang = Angle(90,-90,0)
			}
		},
		
		StrengthenSuspension = true,
		
		FrontHeight = 13.5,
		FrontConstant = 27000,
		FrontDamping = 2200,
		FrontRelativeDamping = 1500, 
		
		RearHeight = 13.5,
		RearConstant = 32000,
		RearDamping = 2200,
		RearRelativeDamping = 1500,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 44,
		Efficiency = 1.4,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = true,
		
		IdleRPM = 750,
		LimitRPM = 7500,
		PeakTorque = 100,
		PowerbandStart = 2500,
		PowerbandEnd = 7300,
		Turbocharged = false,
		Supercharged = false,
		
		PowerBias = 0.6,
		
		EngineSoundPreset = -1,
		
		snd_pitch = 1,
		snd_idle = "simulated_vehicles/v8elite/v8elite_idle.wav",
		
		snd_low = "simulated_vehicles/v8elite/v8elite_low.wav",
		snd_low_revdown = "simulated_vehicles/v8elite/v8elite_revdown.wav",
		snd_low_pitch = 0.8,
		
		snd_mid = "simulated_vehicles/v8elite/v8elite_mid.wav",
		snd_mid_gearup = "simulated_vehicles/v8elite/v8elite_second.wav",
		snd_mid_pitch = 1,
		
		snd_horn = "simulated_vehicles/horn_4.wav",
		
		DifferentialGear = 0.38,
		Gears = {-0.1,0,0.1,0.18,0.25,0.31,0.40}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_v8elite_armed2", V )

local V = {
	Name = "HL2 APC",
	Model = "models/apc/apc.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Armed Vehicles",
	SpawnOffset = Vector(0,0,60),

	Members = {
		Mass = 4800,
		
		MaxHealth = 4500,
		
		IsArmored = true,
		
		LightsTable = "conapc_armed",
		
		FrontWheelRadius = 32,
		RearWheelRadius = 32,
		
		SeatOffset = Vector(375,-13,-58),
		SeatPitch = 0,
		
		CustomMassCenter = Vector(0,0,-12),
		
		PassengerSeats = {
			{
				pos = Vector(-17,0,17),
				ang = Angle(0,0,0)
			},
			{
				pos = Vector(-5,60,-3),
				ang = Angle(0,0,0)
			},
		},
		
		Attachments = {
			{
				model = "models/hunter/plates/plate075x105.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				pos = Vector(0.04-18,57.5-15,16.74),
				ang = Angle(90,-90,0),
				nosolid = true
			},
			{
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				pos = Vector(-25.08-18,91.34-15,29.46),
				ang = Angle(4.2,-109.19,68.43),
				nosolid = true
			},
			{
				pos = Vector(-24.63-18,77.76-15,8.65),
				ang = Angle(24.05,-12.81,-1.87),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(24.63-18,77.76-15,8.65),
				ang = Angle(24.05,-167.19,1.87),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-30.17-18,61.36-15,32.79),
				ang = Angle(-1.21,-92.38,-130.2),
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(30.17-18,61.36-15,32.79),
				ang = Angle(-1.21,-87.62,130.2),
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-18,72.92-15,40.54),
				ang = Angle(0,-180,0.79),
				model = "models/hunter/plates/plate1x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(25.08-18,91.34-15,29.46),
				ang = Angle(4.2,-70.81,-68.43),
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-29.63-18,79.02-15,19.28),
				ang = Angle(90,-18,0),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(29.63-18,79.02-15,19.28),
				ang = Angle(90,-162,0),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-18,75.33-15,5.91),
				ang = Angle(0,0,0),
				model = "models/hunter/plates/plate1x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-18,98.02-15,35.74),
				ang = Angle(63,90,0),
				model = "models/hunter/plates/plate025x025.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-18,100.55-15,7.41),
				ang = Angle(90,-90,0),
				model = "models/hunter/plates/plate1x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			}
		},
		
		FrontHeight = 22,
		FrontConstant = 50000,
		FrontDamping = 4000,
		FrontRelativeDamping = 4000,
		
		RearHeight = 22,
		RearConstant = 50000,
		RearDamping = 4000,
		RearRelativeDamping = 4000,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 140,
		Efficiency = 1.25,
		GripOffset = -14,
		BrakePower = 120,
		BulletProofTires = true,
		
		IdleRPM = 750,
		LimitRPM = 5500,
		PeakTorque = 180,
		PowerbandStart = 1000,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		
		PowerBias = 0,
		
		EngineSoundPreset = 0,
		
		Sound_Idle = "simulated_vehicles/misc/Nanjing_loop.wav",
		Sound_IdlePitch = 1,
		
		Sound_Mid = "simulated_vehicles/misc/m50.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 58,
		Sound_MidFadeOutRate = 0.476,
		
		Sound_High = "simulated_vehicles/misc/v8high2.wav",
		Sound_HighPitch = 1,
		Sound_HighVolume = 0.75,
		Sound_HighFadeInRPMpercent = 58,
		Sound_HighFadeInRate = 0.19,
		
		Sound_Throttle = "",
		Sound_ThrottlePitch = 0,
		Sound_ThrottleVolume = 0,
		
		snd_horn = "simulated_vehicles/horn_2.wav",
		
		DifferentialGear = 0.27,
		Gears = {-0.09,0,0.09,0.18,0.28,0.35}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_conscriptapc_armed", V )


local V = {
	Name = "HL2 APC - MG",
	Model = "models/apc/apc.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Armed Vehicles",
	SpawnOffset = Vector(0,0,60),

	Members = {
		Mass = 4800,
		
		MaxHealth = 4500,
		
		IsArmored = true,
		
		LightsTable = "conapc_armed",
		
		FrontWheelRadius = 32,
		RearWheelRadius = 32,
		
		SeatOffset = Vector(375,-13,-58),
		SeatPitch = 0,
		
		CustomMassCenter = Vector(0,0,-12),
		
		PassengerSeats = {
			{
				pos = Vector(-17,0,17),
				ang = Angle(0,0,0)
			},
			{
				pos = Vector(-5,60,-3),
				ang = Angle(0,0,0)
			},
		},
		
		Attachments = {
			{
				model = "models/hunter/plates/plate075x105.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				pos = Vector(0.04-18,57.5-15,16.74),
				ang = Angle(90,-90,0),
				nosolid = true
			},
			{
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				pos = Vector(-25.08-18,91.34-15,29.46),
				ang = Angle(4.2,-109.19,68.43),
				nosolid = true
			},
			{
				pos = Vector(-24.63-18,77.76-15,8.65),
				ang = Angle(24.05,-12.81,-1.87),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(24.63-18,77.76-15,8.65),
				ang = Angle(24.05,-167.19,1.87),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-30.17-18,61.36-15,32.79),
				ang = Angle(-1.21,-92.38,-130.2),
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(30.17-18,61.36-15,32.79),
				ang = Angle(-1.21,-87.62,130.2),
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-18,72.92-15,40.54),
				ang = Angle(0,-180,0.79),
				model = "models/hunter/plates/plate1x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(25.08-18,91.34-15,29.46),
				ang = Angle(4.2,-70.81,-68.43),
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-29.63-18,79.02-15,19.28),
				ang = Angle(90,-18,0),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(29.63-18,79.02-15,19.28),
				ang = Angle(90,-162,0),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-18,75.33-15,5.91),
				ang = Angle(0,0,0),
				model = "models/hunter/plates/plate1x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-18,98.02-15,35.74),
				ang = Angle(63,90,0),
				model = "models/hunter/plates/plate025x025.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-18,100.55-15,7.41),
				ang = Angle(90,-90,0),
				model = "models/hunter/plates/plate1x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			}
		},
		
		FrontHeight = 22,
		FrontConstant = 50000,
		FrontDamping = 4000,
		FrontRelativeDamping = 4000,
		
		RearHeight = 22,
		RearConstant = 50000,
		RearDamping = 4000,
		RearRelativeDamping = 4000,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 140,
		Efficiency = 1.25,
		GripOffset = -14,
		BrakePower = 120,
		BulletProofTires = true,
		
		IdleRPM = 750,
		LimitRPM = 5500,
		PeakTorque = 180,
		PowerbandStart = 1000,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		
		PowerBias = 0,
		
		EngineSoundPreset = 0,
		
		Sound_Idle = "simulated_vehicles/misc/Nanjing_loop.wav",
		Sound_IdlePitch = 1,
		
		Sound_Mid = "simulated_vehicles/misc/m50.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 58,
		Sound_MidFadeOutRate = 0.476,
		
		Sound_High = "simulated_vehicles/misc/v8high2.wav",
		Sound_HighPitch = 1,
		Sound_HighVolume = 0.75,
		Sound_HighFadeInRPMpercent = 58,
		Sound_HighFadeInRate = 0.19,
		
		Sound_Throttle = "",
		Sound_ThrottlePitch = 0,
		Sound_ThrottleVolume = 0,
		
		snd_horn = "simulated_vehicles/horn_2.wav",
		
		DifferentialGear = 0.27,
		Gears = {-0.09,0,0.09,0.18,0.28,0.35}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_conscriptapc_armed2", V )

local function simfphyslerpView( ply, view )
	
	ply.simfphys_smooth_in = ply.simfphys_smooth_in or 1
	ply.simfphys_smooth_out = ply.simfphys_smooth_out or 1
	
	if ply:InVehicle() then
		if ply.simfphys_smooth_in < 0.999 then
			ply.simfphys_smooth_in = ply.simfphys_smooth_in + (1 - ply.simfphys_smooth_in) * FrameTime() * 5
			
			view.origin = LerpVector(ply.simfphys_smooth_in, ply.simfphys_eyepos_in, view.origin )
			view.angles = LerpAngle(ply.simfphys_smooth_in, ply.simfphys_eyeang_in, view.angles )
		end
		
		local vehicle = ply:GetVehicle()
		if IsValid(vehicle) then
			ply.simfphys_eyeang_out = view.angles
			ply.simfphys_eyepos_out = view.origin
		end
	else
		if ply.simfphys_smooth_out < 0.999 then
			ply.simfphys_smooth_out = ply.simfphys_smooth_out + (1 - ply.simfphys_smooth_out) * FrameTime() * 5
			
			view.origin = LerpVector(ply.simfphys_smooth_out, ply.simfphys_eyepos_out, ply:GetShootPos() )
			view.angles = LerpAngle(ply.simfphys_smooth_out, ply.simfphys_eyeang_out, ply:EyeAngles() )
		end
		
		ply.simfphys_eyeang_in = view.angles
		ply.simfphys_eyepos_in = view.origin
	end
	
	ply.shootpos = view.origin
	ply.shootang = view.angles
	
	return view
end

hook.Add( "CalcView", "simfphys_gunner_view", function( ply, pos, ang )
	if not IsValid( ply ) or not ply:Alive() or not ply:InVehicle() or ply:GetViewEntity() ~= ply then return end
	
	local Vehicle = ply:GetVehicle()
	
	if not IsValid( Vehicle ) then return end
	if not Vehicle:GetNWBool( "IsGunnerSeat" ) then return end
	
	if Vehicle:GetNWBool( "IsAPCSeat" ) then
		pos = pos + Vehicle:GetUp() * 25
	end
	
	local view = {
		origin = pos,
		angles = Vehicle:LocalToWorldAngles( ply:EyeAngles() ),
		drawviewer = false,
	}
	
	if ( Vehicle.GetThirdPersonMode == nil || ply:GetViewEntity() != ply ) then
		return
	end
	
	ply.simfphys_smooth_out = 0
	
	if ( !Vehicle:GetThirdPersonMode() ) then
		view.origin = view.origin + Vehicle:GetUp() * 5 - Vehicle:GetRight() * 9
		return simfphyslerpView( ply, view )
	end
	
	local mn, mx = Vehicle:GetRenderBounds()
	local radius = ( mn - mx ):Length()
	local radius = radius + radius * Vehicle:GetCameraDistance()

	local TargetOrigin = view.origin + ( view.angles:Forward() * -radius )
	local WallOffset = 4

	local tr = util.TraceHull( {
		start = view.origin,
		endpos = TargetOrigin,
		filter = function( e )
			local c = e:GetClass()
			return !c:StartWith( "prop_physics" ) &&!c:StartWith( "prop_dynamic" ) && !c:StartWith( "prop_ragdoll" ) && !e:IsVehicle() && !c:StartWith( "gmod_" ) && !c:StartWith( "player" )
		end,
		mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
		maxs = Vector( WallOffset, WallOffset, WallOffset ),
	} )

	view.origin = tr.HitPos
	view.drawviewer = true

	if ( tr.Hit && !tr.StartSolid) then
		view.origin = view.origin + tr.HitNormal * WallOffset
	end
	
	return simfphyslerpView( ply, view )
end )
