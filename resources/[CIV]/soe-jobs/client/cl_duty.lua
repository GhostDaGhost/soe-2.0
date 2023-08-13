local myJob = "Unemployed"

isOnDuty = false

-- RETURNS WHAT JOB YOU ARE ACTIVELY IN
function GetMyJob()
    return myJob
end

-- RETURNS IF YOU ARE ON DUTY OR NOT
function IsOnDuty()
    return isOnDuty
end

-- CALLED FROM SERVER TO UPDATE CLIENT'S ACTIVE JOB
RegisterNetEvent("Jobs:Client:ToggleDuty")
AddEventHandler("Jobs:Client:ToggleDuty", function(type, active)
    if active then
        myJob = type
        isOnDuty = true
    else
        myJob = "Unemployed"
        isOnDuty = false
    end
end)
