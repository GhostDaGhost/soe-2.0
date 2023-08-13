-- IMGUR CLIENT ID FOR UPLOADS
local clientID = "5e62770eb1e943f"

-- GET UPLOADED MUGSHOT URL
function GetMugshotURL(ped, cb)
    print("MUGSHOT DEBUG 1")
    -- GET MUGSHOT OF PLAYER
    local mugshot = RegisterPedheadshot_3(ped);

    print("MUGSHOT DEBUG 2")
    -- DELAY
    Wait(300)

    print("MUGSHOT DEBUG 3")
    -- GET TEXTURE OF MUGSHOT AND DRAW IT ON SCREEN VIA RUNTIME
    txdString = GetPedheadshotTxdString(mugshot);
    print("MUGSHOT DEBUG 4")
	local screenResX, screenResY = GetActiveScreenResolution();
    print("MUGSHOT DEBUG 5")
    print(screenResX, screenResY, 174/screenResX, 180/screenResY, mugshot, txdString, ped)
    shouldDraw = true

    print("MUGSHOT DEBUG 6")
    -- DELAY
    Wait(100)

    print("MUGSHOT DEBUG 7")
    -- UPLOAD SCREENSHOT OF MUGHSOT TO IMGUR AND GET URL
    exports["screenshot-basic"]:requestScreenshotUpload("https://api.imgur.com/3/image", "imgur", {
        ["headers"] = {
            ["authorization"] = "Client-ID " .. clientID,
            ["content-type"] = 'multipart/form-data'
        },
        ["crop"] = {
            ["offsetX"] = 0,
            ["offsetY"] = 0,
            ["width"] = 174,
            ["height"] = 180
        }
    }, 
    function(data)
        print("MUGSHOT DEBUG 8", json.encode(data))
        -- UNREGISTER MUGSHOT AND SEND URL
        UnregisterPedheadshot(mugshot)
        shouldDraw = false
        local url = json.decode(data).data.link
        cb(url)
        print("MUGSHOT DEBUG 9")
    end)
end
exports("GetMugshotURL", GetMugshotURL)