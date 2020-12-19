require("Boats/config")

ISVehicleMenuForTrailerWithBoat = {}

--[[

	Должна быть вода в нужных точках
	спавн лодки на воду

	Обратно аналогично
	должна быть лодка в нужных точках

	Надо сохранять состояние всех контейнеров и топлива и аккумулятора в мод дата

]]
local vec = Vector3f.new()

local function canLaunchBoat(boat)
	local point = boat:getWorldPos(0, 0, -boat:getScript():getPhysicsChassisShape():z()/2 - 3, vec)
	if not WaterBorders.isWater(getCell():getGridSquare(point:x(), point:y(), 0)) then return false end
	
	point = boat:getWorldPos(0, 0, -boat:getScript():getPhysicsChassisShape():z()/2 - 7, vec)
	if not WaterBorders.isWater(getCell():getGridSquare(point:x(), point:y(), 0)) then return false end

	return true
end



function ISVehicleMenuForTrailerWithBoat.launchRadialMenu(playerObj, vehicle)
	local menu = getPlayerRadialMenu(playerObj:getPlayerNum())
    if canLaunchBoat(vehicle) then
		menu:addSlice(getText("ContextMenu_LaunchBoat"), getTexture("media/ui/vehicles/vehicle_repair.png"), ISVehicleMenuForTrailerWithBoat.launchBoat, playerObj, vehicle)
	end
end


function ISVehicleMenuForTrailerWithBoat.launchBoat(playerObj, vehicle)
	local point = vehicle:getWorldPos(0, 0, -vehicle:getScript():getPhysicsChassisShape():z()/2 - 7, vec)
	local sq = getCell():getGridSquare(point:x(), point:y(), 0)
	if sq == nil then return end
	
	local newTrailerName = AquaTsarConfig.trailerAfterBoatLaunchTable[vehicle:getScript():getName()]
	local boatName = AquaTsarConfig.boatAfterBoatLaunchFromTrailerTable[vehicle:getScript():getName()]
	vehicle:setScriptName(newTrailerName)
	vehicle:scriptReloaded()
	
	local boat = addVehicleDebug("Base."..boatName, IsoDirections.N, 0, sq)
	boat:setAngles(vehicle:getAngleX(), vehicle:getAngleY(), vehicle:getAngleZ())
end

--------------------------------------------

local function starts_with(str, start)
	return str:sub(1, #start) == start
end




local function canLoadOntoTrailer(vehicle)
	if AquaTsarConfig.trailerAfterLoadBoatOnTrailerTable[vehicle:getScript():getName()] == nil then 
		return false 
	end

	for i=0, 8, 0.5 do
		local point = vehicle:getWorldPos(0, 0, -vehicle:getScript():getPhysicsChassisShape():z()/2 - i, vec)
		local sq = getCell():getGridSquare(point:x(), point:y(), 0)
		
		local boat = sq:getVehicleContainer()
		if boat then
			if starts_with(string.lower(boat:getScript():getName()), "boat") and AquaTsarConfig.trailerAfterLoadBoatOnTrailerTable[vehicle:getScript():getName()][boat:getScript():getName()] then
				return true
			end
		end
	end
	return false
end


function ISVehicleMenuForTrailerWithBoat.loadOntoTrailerRadialMenu(playerObj, vehicle)
	local menu = getPlayerRadialMenu(playerObj:getPlayerNum())
	if canLoadOntoTrailer(vehicle) then
		menu:addSlice(getText("ContextMenu_LoadBoatOntoTrailer"), getTexture("media/ui/vehicles/vehicle_repair.png"), ISVehicleMenuForTrailerWithBoat.loadOntoTrailer, playerObj, vehicle)
	end
end


function ISVehicleMenuForTrailerWithBoat.loadOntoTrailer(playerObj, vehicle)
	for i=0, 8, 0.5 do
		local point = vehicle:getWorldPos(0, 0, -vehicle:getScript():getPhysicsChassisShape():z()/2 - i, vec)
		local sq = getCell():getGridSquare(point:x(), point:y(), 0)
		
		local boat = sq:getVehicleContainer()
		if boat then
			if starts_with(string.lower(boat:getScript():getName()), "boat") then
				local trailerName = AquaTsarConfig.trailerAfterLoadBoatOnTrailerTable[vehicle:getScript():getName()][boat:getScript():getName()]				
				vehicle:setScriptName(trailerName)
				vehicle:scriptReloaded()

				boat:removeFromWorld()
				return
			end
		end
	end

end
