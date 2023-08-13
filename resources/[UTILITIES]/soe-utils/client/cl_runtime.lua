shouldDraw = false
txdString = ""

-- IF MUGSHOT SHOULD BE DRAWN, DRAW IT EVERY 3 MSEC
Citizen.CreateThread(function()
    local screenResX, screenResY = GetActiveScreenResolution();
    local width, height = 174/screenResX, 180/screenResY
    while true do
        if shouldDraw then
            DrawSprite(txdString, txdString, width/2, height/2, width, height, 0.0, 255, 255, 255, 1000);
        end
        Wait(5)
    end
end)