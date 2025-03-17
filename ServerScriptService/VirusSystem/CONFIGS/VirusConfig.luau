local virusFunctions = require(script.Parent.VirusFunctions)

local VirusConfig = {
	
	Smallpox = {
		Name = "Smallpox",
		IncubationTime = 30,
		Lifespan = 300,
		ImmunityPenetration = 2,
		CureName = "Smallpox Cure",
		playFunction = virusFunctions.Smallpox,
		
		CoughZoneSize = Vector3.new(3,3,3),
		CoughSpreadChance = 0.6,
		CoughFrequency = 10
	},
	
	Paralysis = {
		Name = "Paralysis",
		IncubationTime = 30,
		Lifespan = 300,
		ImmunityPenetration = 1,
		CureName = "Paralysis Cure",
		playFunction = virusFunctions.Paralysis,
	}
}

return VirusConfig
