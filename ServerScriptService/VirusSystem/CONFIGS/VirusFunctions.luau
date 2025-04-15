local collectionService = game:GetService("CollectionService")
local symptomsManager = require(game.ServerScriptService.VirusSystem.Modules.SymptomsManager)
local infectionSpreadManager = require(game.ServerScriptService:WaitForChild("VirusSystem").Modules.InfectionSpreadManager)

local utilityFunctions = require(script.UtilityFunctions)

local lesionConfig = {
	BaseColor = Color3.fromRGB(204, 0, 0),
	SizeRange = {min = 0.08, max = 0.16},
	Transparency = 0.1,
	BodyParts = {
		"LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm",
		"LeftLowerLeg", "RightLowerLeg", "LeftUpperLeg", "RightUpperLeg",
		"UpperTorso", "LowerTorso", "Head"
	},
	LesionsPerPart = {min = 1, max = 3},
	SeverityLevel = 1
}


VirusFunctions = {}

function VirusFunctions.executeSmallpox(character, timeUntilDeath, virusImmunityPenetration, coughSpreadChance, coughZoneSize)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid and collectionService:HasTag(character, "Smallpox") then
		local lesions = utilityFunctions.Smallpox.executeLesions(character, lesionConfig)
		
		local timeSinceLastInfection = 0
		
		task.spawn(function()
			while task.wait(0.5) do
				if collectionService:HasTag(character, "Smallpox") then
					timeSinceLastInfection += 0.5
				else
					timeSinceLastInfection = 0
					break
				end
			end
		end)
		
		task.spawn(function()
			local maxStages = 4
			for stage = 1, maxStages do
				task.wait(timeUntilDeath/5)
				if not collectionService:HasTag(character, "Smallpox") then return end
				infectionSpreadManager.InitiateCough(character, "Smallpox", virusImmunityPenetration, coughSpreadChance, coughZoneSize)
				if character and collectionService:HasTag(character, "Smallpox") then
					local moreLesions = utilityFunctions.Smallpox.executeLesions(character, lesionConfig)
					for _, lesion in ipairs(moreLesions) do
						table.insert(lesions, lesion)
					end
					for _, lesion in ipairs(lesions) do
						if lesion and lesion.Parent then
							lesion.Size = lesion.Size * 1
						end
					end
				else
					break
				end
			end
		end)
		task.delay(timeUntilDeath, function()
			if not collectionService:HasTag(character, "Smallpox") or not (timeSinceLastInfection >= 59) then return end
			for i, lesion in pairs(lesions) do
				lesion:Destroy()
			end
			humanoid.Health = 0
		end)
	end
end

return VirusFunctions
