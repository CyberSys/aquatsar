require("Boats/Init")
AquatsarYachts.Swim = {}



function AquatsarYachts.Swim.chanceSuccess(playerObj)
    return 33
end

function AquatsarYachts.Swim.swimToLand(playerObj, chance)
    print("swim")    
end



-- Lifebuoy

function AquatsarYachts.Swim.haveLifebuoy(playerObj)
    return true
end

function AquatsarYachts.Swim.chanceSuccessWithLifebuoy(playerObj)
    return 66
end

function AquatsarYachts.Swim.swimToLandWithLifebuoy(playerObj, chance)
    print("Swim with lifebuoy")
end