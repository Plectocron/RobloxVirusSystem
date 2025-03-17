local immunityManager = require(script.Parent.ImmunityManager)
local virusConfig = require(script.Parent.Parent.CONFIGs.VirusConfig)
local collectionService = game:GetService("CollectionService")


local InfectionSpreadManager = {}

local function playerCanBeInfected(playerCharacter, virusName:string)
	local playerImmunityLevel = immunityManager.GetImmunityLevel(playerCharacter)
	local playerIsInfectable = immunityManager.VirusCanBypassImmunity(virusName, playerImmunityLevel)
	return playerIsInfectable
end
local function smallpoxTagAdded(playerCharacter)
	local playerIsInfectable = playerCanBeInfected(playerCharacter, "Smallpox")
	if not playerIsInfectable then
		collectionService:RemoveTag(playerCharacter, "Smallpox")
		return
	end
end
local function paralysisTagAdded(playerCharacter)
	local playerIsInfectable = playerCanBeInfected(playerCharacter, "Paralysis")
	if not playerIsInfectable then
		collectionService:RemoveTag(playerCharacter, "Paralysis")
		return
	end
end
function InfectionSpreadManager.InitializeTagSecurity()
	collectionService:GetInstanceAddedSignal("Smallpox"):Connect(smallpoxTagAdded)
	collectionService:GetInstanceAddedSignal("Paralysis"):Connect(paralysisTagAdded)
end

function InfectionSpreadManager.StartSpreadChecking()
	
end

function InfectionSpreadManager.CheckPlayerProximity(infectedPlayer, targetPlayer)
	if not infectedPlayer.Character or not targetPlayer.Character then return math.huge end

	local root1 = infectedPlayer.Character:FindFirstChild("HumanoidRootPart")
	local root2 = targetPlayer.Character:FindFirstChild("HumanoidRootPart")

	if root1 and root2 then
		return (root1.Position - root2.Position).Magnitude
	end

	return math.huge
end

local function spawnZone(location, size)
	local zone = Instance.new("Part")
	zone.Anchored = true
	zone.CanCollide = false
	zone.Size = size
	zone.Position = location
	return zone
end
function InfectionSpreadManager.playersWithinCoughZone(infectedPlayer, virusName)
	if not virusConfig[virusName] or not virusConfig[virusName].CoughZoneSize then return end
	local coughZone = spawnZone(infectedPlayer.PrimaryPart.Position, virusConfig[virusName].CoughZoneSize)
	local partsWithinZone = coughZone:GetTouchingParts()
	
	local playersWithinCoughZone = {}
	for i, part in pairs(partsWithinZone) do
		if part.Parent:FindFirstChild("Humanoid") and game.Players:GetPlayerFromCharacter(part.Parent) then
			local playerCharacter = part.Parent
			if playerCharacter ~= infectedPlayer then
				table.insert(playersWithinCoughZone, playerCharacter)
			end
		end
	end
	
	coughZone:Destroy()
	return playersWithinCoughZone
end

function InfectionSpreadManager.AttemptInfectionAfterCough(infectedPlayer, targetPlayer, virusName)
	
end

local function isInfectedThroughCough(playerCharacter, virusName)
	if not virusConfig[virusName] or not virusConfig[virusName].CoughSpreadChance then return false end
	
	local infectionChance = virusConfig[virusName]
end
function InfectionSpreadManager.InitiateCough(infectedPlayer, virusName)
	local potentialVictims = InfectionSpreadManager.playersWithinCoughZone(infectedPlayer, virusName)
	local guaranteedVictims = {}
	
	
end

return InfectionSpreadManager
