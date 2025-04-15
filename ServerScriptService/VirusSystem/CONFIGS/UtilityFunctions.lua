local RunService = game:GetService("RunService")

local UtilityFunctions = {
	RNG = {},
	Smallpox = {}
}

--[[
	Returns a random number between -1 and 1, while trying not to be too deep into the middle (with the use of the parameter minDistanceFromCenter.) Used to scale in 1 dimension.
	
	@param minDistanceFromCenter (Number between 0-1): if minDistanceFromCenter = 0.75, returned value will be between -1 to -0.75, or 0.75 to 1
]]
function UtilityFunctions.RNG.getRandomAwayFromCenter(minDistanceFromCenter)
	local offset = math.random() * 2 - 1

	-- If offset is too close to 0 (within -minDistanceFromCenter to minDistanceFromCenter), push to the nearest edge
	if offset > -minDistanceFromCenter and offset < minDistanceFromCenter then
		if offset > 0 then
			return minDistanceFromCenter
		else
			return -minDistanceFromCenter
		end
	end

	-- if it's already beyond the threshold, return it as is
	return offset
end

--[[
	Returns a random offset from a part's center.
	
	@param part (Part): Part that you want to get the offset from
	@param minDistanceFromCenter (Number between 0-1): if minDistanceFromCenter = 0.75, returned value will be between -1 to -0.75, or 0.75 to 1
	@param reachExtent (Number): How far you want the offset to reach from the part's center. If 0, it WILL be exactly on the part's center. If 1, it will HAVE THE POSSIBILITY to be exactly on the part's surface
]]
function UtilityFunctions.RNG.getRandomOffsetInPart(part, minDistanceFromCenter, reachExtent)
	local size = part.Size
	local xOffset = UtilityFunctions.RNG.getRandomAwayFromCenter(minDistanceFromCenter) * size.X * reachExtent
	local yOffset = UtilityFunctions.RNG.getRandomAwayFromCenter(minDistanceFromCenter) * size.Y * reachExtent
	local zOffset = UtilityFunctions.RNG.getRandomAwayFromCenter(minDistanceFromCenter) * size.Z * reachExtent

	return Vector3.new(xOffset, yOffset, zOffset)
end

--[[
	Gets a random offset from a part's center. Used for smallpox, to make the rashes not be exactly on the part's center.
	
	@param part (Part): Part that you want to get the offset from
]]
function UtilityFunctions.Smallpox.getRandomLesionOffset(part)
	
	local lesionOffset = UtilityFunctions.RNG.getRandomOffsetInPart(part, 0.75, 0.6)

	if part.Name == "Head" then
		return UtilityFunctions.RNG.getRandomOffsetInPart(part, 0.75, 0.45)
	end

	return lesionOffset
end

--[[
	Creates smallpox lesions on a player's body part.
	
	@param bodyPart (Part): Player's body part that you want to create the smallpox on
	@param lesionConfig (table): Configuration table of lesions
]]
function UtilityFunctions.Smallpox.createLesion(bodyPart, lesionConfig)
	local lesion = Instance.new("Part")
	lesion.Name = "SmallpoxLesion"
	lesion.Shape = Enum.PartType.Ball
	local size = math.random() * (lesionConfig.SizeRange.max - lesionConfig.SizeRange.min) + lesionConfig.SizeRange.min
	lesion.Size = Vector3.new(size, size, size)
	local colorVariation = math.random(-20, 20) / 255
	lesion.Color = Color3.new(
		math.clamp(lesionConfig.BaseColor.R + colorVariation, 0, 1),
		math.clamp(lesionConfig.BaseColor.G + colorVariation, 0, 1),
		math.clamp(lesionConfig.BaseColor.B + colorVariation, 0, 1)
	)
	lesion.Material = Enum.Material.SmoothPlastic
	lesion.Transparency = lesionConfig.Transparency
	lesion.CanCollide = false
	lesion.Anchored = true
	lesion.CastShadow = false
	lesion.Massless = true
	local offset = UtilityFunctions.Smallpox.getRandomLesionOffset(bodyPart)
	lesion.Parent = workspace
	lesion.CFrame = bodyPart.CFrame * CFrame.new(offset)
	return {
		part = lesion,
		bodyPart = bodyPart,
		offset = offset
	}
end

--[[
	Executes the creation of random smallpox on a player's body parts.
	
	@param character (Model): Player's character that you want to create the lesions on
	@param lesionConfig (table): Configuration table of lesions
]]
function UtilityFunctions.Smallpox.executeLesions(character, lesionConfig)
	local allLesions = {}
	local lesionsData = {}
	for _, partName in ipairs(lesionConfig.BodyParts) do
		local bodyPart = character:FindFirstChild(partName)
		if bodyPart then
			local numLesions = math.random(
				lesionConfig.LesionsPerPart.min, 
				lesionConfig.LesionsPerPart.max
			) * lesionConfig.SeverityLevel
			for i = 1, numLesions do
				local lesionData = UtilityFunctions.Smallpox.createLesion(bodyPart, lesionConfig)
				table.insert(lesionsData, lesionData)
			end
		end
	end
	RunService.Heartbeat:Wait()
	for _, data in ipairs(lesionsData) do
		local lesion = data.part
		local bodyPart = data.bodyPart
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = lesion
		weld.Part1 = bodyPart
		weld.Parent = lesion
		lesion.Parent = bodyPart
		lesion.Anchored = false
		table.insert(allLesions, lesion)
	end
	return allLesions
end


return UtilityFunctions
