CreateThread(function()
    Wait(6500)
    RequestScriptAudioBank("ICE_FOOTSTEPS", false)
    RequestScriptAudioBank("SNOW_FOOTSTEPS", false)
    exports["soe-utils"]:LoadPTFXAsset("core_snow", 15)
    UseParticleFxAssetNextCall("core_snow")

    while true do
        Wait(35)
        if IsNextWeatherType("XMAS") then
            N_0xc54a08c85ae4d410(3.0)
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        end
    end
end)
