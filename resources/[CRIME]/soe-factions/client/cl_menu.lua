local isMenuOpen = false
local SOEMenu = assert(MenuV)
local factionMenuMain = SOEMenu:CreateMenu("Factions", "GETTIN' THE GANG BACK TOGETHER", 'topright', 255, 255, 255, 'size-100', 'default', 'menuv', 'factionMenuMain', 'native')

local function CloseFactionMenu()
    SOEMenu:CloseAll()
    isMenuOpen = false
end

local function DoesMemberHavePerm(member, checkPerm)
    if member.Permissions then
        for _, perm in pairs(json.decode(member.Permissions)) do
            if perm == checkPerm then
                return true
            end
        end
    end
    return false
end

local function AddMemberButton(menu, faction, text)
    menu:AddButton({label = text, select = function()
        exports["soe-input"]:OpenInputDialogue("number", "Who would you like to add? Please enter their SSN", function(returnData)
            if (returnData ~= nil and tonumber(returnData)) then
                CloseFactionMenu()
                local addRoster = exports["soe-nexus"]:TriggerServerCallback("Factions:Server:AddFactionRoster", tonumber(returnData), faction.FactionData.FactionID)

                if addRoster then
                    exports["soe-ui"]:SendAlert("success", "Your faction's roster has successfully been updated!", 5000)
                else
                    exports["soe-ui"]:SendAlert("error", "An error occure while updating your faction's roster.", 5000)
                end
            end
        end)
    end})
end

local function AddPermSection(menu, faction, member)
    local permLabel = menu:AddButton({label = "Permissions", disabled = true})
    for perm, label in pairs(GetPossiblePerms(faction.FactionData.FactionSubtype)) do
        local permCheck = menu:AddCheckbox({icon = "📋", label = label})
        if DoesMemberHavePerm(member, perm) then
            permCheck.Value = true
        end

        permCheck:On('check', function(item)
            local permChange = exports["soe-nexus"]:TriggerServerCallback("Factions:Server:ModifyPerms", member.EntryID, perm, "add")

            if permChange then
                exports["soe-ui"]:SendAlert("success", "Permissions updated for this member!", 5000)
            else
                exports["soe-ui"]:SendAlert("error", "An error occure while updating permissions for this member.", 5000)
            end
        end)

        permCheck:On('uncheck', function(item)
            local permChange = exports["soe-nexus"]:TriggerServerCallback("Factions:Server:ModifyPerms", member.EntryID, perm, "remove")

            if permChange then
                exports["soe-ui"]:SendAlert("success", "Permissions updated for this member!", 5000)
            else
                exports["soe-ui"]:SendAlert("error", "An error occure while updating permissions for this member.", 5000)
            end
        end)
    end
end

local function AddRosterSubmenu(menu, faction, roleIndex, type, role, promoteTo, demoteTo)
    menu:AddButton({label = role .. "(s)", disabled = true})
    for _, member in pairs(faction.FactionRoster) do
        if member.Role == role then
            local rosterManageSubmenu = SOEMenu:InheritMenu(factionMenuMain, {
                ["title"] = faction.FactionData.FactionName,
                ["subtitle"] = "MANAGE " .. string.upper(member.Name)
            })

            rosterManageSubmenu:AddButton({icon = "❌", label = "Remove From Faction", select = function()
                exports["soe-input"]:OpenConfirmDialogue("Are you sure you'd like to remove " .. member.Name .. " from this faction?", "Yes", "No", function(returnData)
                    if returnData then
                        CloseFactionMenu()
                        local removeRoster = exports["soe-nexus"]:TriggerServerCallback("Factions:Server:RemoveFactionRoster", member.EntryID)

                        if removeRoster then
                            exports["soe-ui"]:SendAlert("success", "Member successfully removed from faction!", 5000)
                        else
                            exports["soe-ui"]:SendAlert("error", "An error occure while removing this member.", 5000)
                        end
                    end
                end)
            end})

            rosterManageSubmenu:AddButton({icon = "🖊️", label = "Edit Title/Position", select = function()
                exports["soe-input"]:OpenInputDialogue("name", "What would you like to change " .. member.Name .. "'s title/position to?", function(returnData)
                    if (returnData ~= nil) then
                        CloseFactionMenu()
                        local modifyRoster = exports["soe-nexus"]:TriggerServerCallback("Factions:Server:ModifyFactionRoster", member.EntryID, "Title", returnData)

                        if modifyRoster then
                            exports["soe-ui"]:SendAlert("success", "Title updated!", 5000)
                        else
                            exports["soe-ui"]:SendAlert("error", "An error occure while updating this member's title.", 5000)
                        end
                    end
                end)
            end})

            if type == "business" then
                rosterManageSubmenu:AddButton({icon = "💲", label = ("Current Pay Rate: $%s"):format(member.Rate)})
                rosterManageSubmenu:AddButton({icon = "💲", label = "Edit Pay Rate", select = function()
                    exports["soe-input"]:OpenInputDialogue("number", "What would you like to change " .. member.Name .. "'s pay rate to?", function(returnData)
                        local chosenRate = tonumber(returnData)
                        if chosenRate ~= nil then
                            CloseFactionMenu()
                            if chosenRate <= maxClockinRate then
                                local modifyRoster = exports["soe-nexus"]:TriggerServerCallback("Factions:Server:ModifyFactionRoster", member.EntryID, "Rate", chosenRate)
                                if modifyRoster then
                                    exports["soe-ui"]:SendAlert("success", ("Rate for %s updated to: %s"):format(member.Name, chosenRate), 5000)
                                else
                                    exports["soe-ui"]:SendAlert("error", "An error occurred while updating this member's rate.", 5000)
                                end
                            elseif chosenRate < 0 then
                                exports["soe-ui"]:SendAlert("error", "Rate cannot be less than 0!", 5000)
                            else
                                exports["soe-ui"]:SendAlert("error", ("Max rate is %s!"):format(maxClockinRate), 5000)
                            end
                        end
                    end)
                end})
            end

            rosterManageSubmenu:AddButton({icon = "🔽", label = "Demote To " .. demoteTo, select = function()
                exports["soe-input"]:OpenConfirmDialogue("Are you sure you'd like to demote " .. member.Name .. " to " .. demoteTo .. "?", "Yes", "No", function(returnData)
                    if returnData then
                        CloseFactionMenu()
                        local modifyRoster = exports["soe-nexus"]:TriggerServerCallback("Factions:Server:ModifyFactionRoster", member.EntryID, "Role", demoteTo)

                        if modifyRoster then
                            exports["soe-ui"]:SendAlert("success", "Member demoted successfully!", 5000)
                        else
                            exports["soe-ui"]:SendAlert("error", "An error occure while updating this member's role.", 5000)
                        end
                    end
                end)
            end})

            if GetRoleIndex(role) - roleIndex >= 2 or roleIndex == 1 then
                rosterManageSubmenu:AddButton({icon = "🔼", label = "Promote To " .. promoteTo, select = function()
                    exports["soe-input"]:OpenConfirmDialogue("Are you sure you'd like to promote " .. member.Name .. " to " .. promoteTo .. "?", "Yes", "No", function(returnData)
                        if returnData then
                            CloseFactionMenu()
                            local modifyRoster = exports["soe-nexus"]:TriggerServerCallback("Factions:Server:ModifyFactionRoster", member.EntryID, "Role", promoteTo)

                            if modifyRoster then
                                exports["soe-ui"]:SendAlert("success", "Member promoted successfully!", 5000)
                            else
                                exports["soe-ui"]:SendAlert("error", "An error occure while updating this member's role.", 5000)
                            end
                        end
                    end)
                end})
            end

            AddPermSection(rosterManageSubmenu, faction, member)

            if GetRoleIndex(role) - roleIndex >= 1 and roleIndex < 3 then
                menu:AddButton({label = member.Name .. " (" .. member.Title .. ")", value = rosterManageSubmenu})
            else
                menu:AddButton({label = member.Name .. " (" .. member.Title .. ")"})
            end
        end
    end
end

RegisterNetEvent("Factions:Client:OpenMenu")
AddEventHandler("Factions:Client:OpenMenu", function(factionData)
    -- DON'T ALLOW STACKING
    if isMenuOpen then
        return
    end

    -- CLEAR ANY OLD ITEMS
    factionMenuMain:ClearItems()

    -- BUSINESS FACTIONS
    factionMenuMain:AddButton({icon = '📝', label = "My Business Factions", disabled = true})
    for _, faction in pairs(factionData) do
        if faction.FactionData.FactionType == "business" then
            local roleIndex = GetRoleIndex(faction.MyData.Role)

            local factionSubmenu = SOEMenu:InheritMenu(factionMenuMain, {
                ["title"] = faction.FactionData.FactionName,
                ["subtitle"] = "VIEW/MANAGE " .. string.upper(faction.FactionData.FactionName)
            })
            factionMenuMain:AddButton({label = faction.FactionData.FactionName, value = factionSubmenu})

            local rosterSubmenu = SOEMenu:InheritMenu(factionMenuMain, {
                ["title"] = faction.FactionData.FactionName,
                ["subtitle"] = "VIEW/MANAGE THE ROSTER FOR " .. string.upper(faction.FactionData.FactionName)
            })

            factionSubmenu:AddButton({icon = "💲", label = "Clock in", select = function()
                TriggerEvent("Factions:Client:Clockin", factionData, faction.FactionData.FactionName)
                CloseFactionMenu()
            end})

            factionSubmenu:AddButton({icon = "📋", label = "View/Manage Roster", value = rosterSubmenu})

            -- MANAGER+ CAN HIRE
            if roleIndex <= 2 then
                AddMemberButton(rosterSubmenu, faction, "Hire Somebody New")
            end

            AddRosterSubmenu(rosterSubmenu, faction, roleIndex, faction.FactionData.FactionType, "Owner", "Owner", "Manager")
            AddRosterSubmenu(rosterSubmenu, faction, roleIndex, faction.FactionData.FactionType, "Manager", "Owner", "Employee")
            AddRosterSubmenu(rosterSubmenu, faction, roleIndex, faction.FactionData.FactionType, "Employee", "Manager", "Newhire")
            AddRosterSubmenu(rosterSubmenu, faction, roleIndex, faction.FactionData.FactionType, "Newhire", "Employee", "Newhire")
        end
    end

    -- GANG FACTIONS
    factionMenuMain:AddButton({icon = '📝', label = "My Gang Factions", disabled = true})
    for _, faction in pairs(factionData) do
        if faction.FactionData.FactionType == "gang" then
            local roleIndex = GetRoleIndex(faction.MyData.Role)

            local factionSubmenu = SOEMenu:InheritMenu(factionMenuMain, {
                ["title"] = faction.FactionData.FactionName,
                ["subtitle"] = "VIEW/MANAGE " .. string.upper(faction.FactionData.FactionName)
            })
            factionMenuMain:AddButton({label = faction.FactionData.FactionName, value = factionSubmenu})

            local rosterSubmenu = SOEMenu:InheritMenu(factionMenuMain, {
                ["title"] = faction.FactionData.FactionName,
                ["subtitle"] = "VIEW/MANAGE THE ROSTER FOR " .. string.upper(faction.FactionData.FactionName)
            })
            factionSubmenu:AddButton({label = "View/Manage Roster", value = rosterSubmenu})

            -- LEADER CAN ONLY HIRE
            if (roleIndex <= 1) then
                AddMemberButton(rosterSubmenu, faction, "Recruit Somebody New")
            end

            AddRosterSubmenu(rosterSubmenu, faction, roleIndex, faction.FactionData.FactionType, "Leader", "Leader", "Trusted")
            AddRosterSubmenu(rosterSubmenu, faction, roleIndex, faction.FactionData.FactionType, "Trusted", "Leader", "Member")
            AddRosterSubmenu(rosterSubmenu, faction, roleIndex, faction.FactionData.FactionType, "Member", "Trusted", "Recruit")
            AddRosterSubmenu(rosterSubmenu, faction, roleIndex, faction.FactionData.FactionType, "Recruit", "Member", "Recruit")
        end
    end

    factionMenuMain:Open()
    isMenuOpen = true
end)

-- ON MENU CLOSED, SET MENUOPEN TO FALSE
factionMenuMain:On('close', function(menu)
    isMenuOpen = false
end)