-- **********************
--       Functions
-- **********************
-- RETURNS WHETHER THIS SERVER IS A DEV SERVER
function IsDevServer()
    if (GetConvarInt("isDevServer", 0) == 1) then
        return true
    end
    return false
end
exports("IsDevServer", IsDevServer)

-- RETURNS WHETHER THIS SERVER IS A TRAINING SERVER
function IsTrainingServer()
    if (GetConvarInt("isTrainingServer", 0) == 1) then
        return true
    end
    return false
end
exports("IsTrainingServer", IsTrainingServer)
