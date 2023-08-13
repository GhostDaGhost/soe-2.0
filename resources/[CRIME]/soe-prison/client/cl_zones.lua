-- CREATES POLYZONES FOR JOB INTERACTIONS
function CreateZones()
    --[[exports["soe-utils"]:AddCircleZone("prison", vector3(1709.73, 2587.57, 45.56), 97.24, {
        name = "prison",
        useZ = true,
    })]]

    exports["soe-utils"]:AddBoxZone("prison_cookingjob", vector3(1776.33, 2595.63, 45.8), 1.2, 1.2, {
        name = "prison_cookingjob",
        heading = 0,
        minZ = 43.0,
        maxZ = 47.0
    })

    exports["soe-utils"]:AddBoxZone("prison_cleaningjob", vector3(1782.86, 2589.47, 45.8), 1.2, 1.2, {
        name = "prison_cleaningjob",
        heading = 0,
        minZ = 42.8,
        maxZ = 46.8
    })
end
