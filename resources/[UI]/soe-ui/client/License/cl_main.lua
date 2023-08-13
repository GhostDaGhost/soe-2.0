licenseFade, licenseTimer, licenseFadeTime, useChatMessageForLicense = false, GetResourceKvpInt("uidata.licenseTimer"), GetResourceKvpInt("uidata.licenseFadeTime"), false

-- KEY MAPPINGS
RegisterKeyMapping("clearlicenseui", "[License] Clear", "KEYBOARD", "H")

-- **********************
--    Global Functions
-- **********************
-- WHEN TRIGGERED, SETUP LICENSES PREFERENCES
function SetupLicensePreferences()
    licenseFade, licenseTimer, licenseFadeTime, useChatMessageForLicense = false, GetResourceKvpInt("uidata.licenseTimer"), GetResourceKvpInt("uidata.licenseFadeTime"), false -- RE-INITIALIZE JUST IN CASE
    if (GetResourceKvpString("uidata.licenseFade") == "true") then
        licenseFade = true
    end

    if (GetResourceKvpInt("uidata.licenseTimer") == 0) then
        licenseTimer = 10000
    end

    if (GetResourceKvpInt("uidata.licenseFadeTime") == 0) then
        licenseFadeTime = 3500
    end

    if (GetResourceKvpString("uidata.licenseChatMessage") == "true") then
        useChatMessageForLicense = true
    end

    SendNUIMessage({ -- SEND TO TYPESCRIPT OUR SAVED PREFERENCES
        type = "License.LoadPreferences",
        licenseFade = licenseFade or false,
        licenseTimer = licenseTimer or 10000,
        licenseFadeTime = licenseFadeTime or 3500
    })
end

-- **********************
--        Commands
-- **********************
-- WHEN TRIGGERED, CLEAR ANY LICENSES ON SCREEN
RegisterCommand("clearlicenseui", function()
    SendNUIMessage({type = "License.Clear"})
end)

-- **********************
--        Events
-- **********************
-- WHEN TRIGGERED, SHOW LICENSE UI
RegisterNetEvent("UI:Client:ShowLicense", function(licenseData, licenseID)
    if not licenseData then return end -- FAILSAFE

    -- PLAYERS HAVE THE OPTION OF CLASSIC CHAT LICENSE OR THE NEW LICENSE UI CARD
    if not useChatMessageForLicense then
        SendNUIMessage({
            type = "License.Show",
            licenseData = {
                picture = licenseData["ImageURL"] or "",
                firstGiven = licenseData["FirstGiven"] or "Danny",
                lastGiven = licenseData["LastGiven"] or "Default",
                SSN = licenseData["SSN"] or 0,
                DOB = licenseData["DOB"] or "1950-01-1",
                licenseID = licenseID or 0,
                issuedDate = licenseData["IssuedDate"] or "2000-01-01",
                expiryDate = licenseData["ExpiryDate"] or "2000-01-01",
                gender = licenseData["Gender"] or "Unknown"
            }
        })
    else
        local msg = ("ID #: ^2%s ^0| SSN #: ^2%s ^0| First: ^2%s ^0Last: ^2%s ^0| DOB: ^2%s ^0| Issued Date: ^2%s ^0| Expiry Date: ^2%s ^0| Gender: ^2%s ^0"):format(licenseID, licenseData["SSN"], licenseData["FirstGiven"], licenseData["LastGiven"], licenseData["DOB"], licenseData["IssuedDate"], licenseData["ExpiryDate"], (licenseData["Gender"]):sub(0, 1):upper())
        TriggerEvent("Chat:Client:Message", "[ID]", msg, "id")
    end
end)
