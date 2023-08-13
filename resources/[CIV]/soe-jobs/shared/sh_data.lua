-- LIST OF VALID JOBS THE DUTY TOGGLE CAN TAKE (ADD ONTO THIS WHEN ADDING A NEW JOB)
validJobs = {
    ["DOJ"] = true,
    ["TOW"] = true,
    ["EMS"] = true,
    ["TAXI"] = true,
    ["PIZZA"] = true,
    ["POLICE"] = true,
    ["HOTDOG"] = true,
    ["DISPATCH"] = true,
    ["GOPOSTAL"] = true,
    ["GARBAGE"] = true,
    ["SECURITY"] = true,
    ["NEWS"] = true,
    ["CLUCKINBELL"] = true,
    ["GOV"] = true,
    ["CRIMELAB"] = true
}

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, RETURN THE LIST OF VALID JOBS
function GetValidJobs()
    return validJobs
end
exports("GetValidJobs", GetValidJobs)
