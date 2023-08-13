RequestIpl("ba_barriers_case5")
RequestIpl("ba_case5_solomun")

local intLoc = vec3(-1569.4, -3017.0, -74.5)
local extLoc = vec3(-1285.0, -652.2, 26.5)
local intID = GetInteriorAtCoords(intLoc)
local clubsmoke = {
    {vec(-1600.0, -3012.0, -78.0), vec(0.0, 0.0, 0.0)},
    {vec(-1595.0, -3012.0, -78.0), vec(0.0, 0.0, 0.0)},
    {vec(-1590.0, -3012.0, -78.0), vec(0.0, 0.0, 0.0)},
    {vec(-1602.932, -3019.1, -77.99), vec(0.0, -10.0, 66.0)},
    {vec(-1593.238, -3017.05, -77.99), vec(0.0, -10.0, 110.0)},
    {vec(-1597.134, -3008.2, -77.99), vec(0.0, -10.0, -122.53)},
    {vec(-1589.966, -3008.518, -77.99), vec(0.0, -10.0, -166.97)}
}
local spawnedclubsmoke = {}
local smokemachines = {
    {vec(-1602.932, -3019.1, -79.99), vec(0.0, -10.0, 66.0)},
    {vec(-1593.238, -3017.05, -79.99), vec(0.0, -10.0, 110.0)},
    {vec(-1597.134, -3008.2, -79.99), vec(0.0, -10.0, -122.53)},
    {vec(-1589.966, -3008.518, -79.99), vec(0.0, -10.0, -166.97)}
}
local spawnedsmokemachines = {}

local InsidePeds = {
    ["Bouncer1"] = {
        false,
        25,
        "s_m_m_bouncer_01",
        vec3(-1568.34, -3002.85, -76.21),
        0.0,
        "WORLD_HUMAN_GUARD_STAND",
        vec3(-1568.34, -3002.85, -76.21),
        146.68
    },
    ["Bouncer2"] = {
        false,
        25,
        "s_m_m_bouncer_01",
        vec3(-1576.45, -3010.22, -79.01),
        0.0,
        "WORLD_HUMAN_GUARD_STAND",
        vec3(-1576.45, -3010.22, -79.01),
        4.69
    },
    ["Bouncer3"] = {
        false,
        25,
        "s_m_m_bouncer_01",
        vec3(-1602.02, -3018.44, -79.01),
        0.0,
        "WORLD_HUMAN_GUARD_STAND",
        vec3(-1602.02, -3018.44, -79.01),
        321.31
    },
    ["Bouncer4"] = {
        false,
        25,
        "s_m_m_bouncer_01",
        vec3(-1605.83, -3007.60, -76.00),
        0.0,
        "WORLD_HUMAN_GUARD_STAND",
        vec3(-1605.83, -3007.60, -76.00),
        318.89
    },
    ["Bouncer5"] = {
        false,
        25,
        "s_m_m_bouncer_01",
        vec3(-1609.64, -3005.60, -79.01),
        0.0,
        "WORLD_HUMAN_GUARD_STAND",
        vec3(-1609.64, -3005.60, -79.01),
        177.59
    },
    ["Bouncer6"] = {
        false,
        25,
        "s_m_m_bouncer_01",
        vec3(-1590.43, -3014.74, -79.01),
        0.0,
        "WORLD_HUMAN_GUARD_STAND",
        vec3(-1590.43, -3014.74, -79.01),
        93.51
    },
    ["Bouncer7"] = {
        false,
        25,
        "s_m_m_bouncer_01",
        vec3(-1581.97, -3019.10, -79.01),
        0.0,
        "WORLD_HUMAN_GUARD_STAND",
        vec3(-1581.97, -3019.10, -79.01),
        336.55
    },
    ["Bouncer8"] = {
        false,
        25,
        "s_m_m_bouncer_01",
        vec3(-1600.48, -3005.26, -79.01),
        0.0,
        "WORLD_HUMAN_GUARD_STAND",
        vec3(-1600.48, -3005.26, -79.01),
        98.54
    },
    ["Bouncer9"] = {
        false,
        25,
        "s_m_m_bouncer_01",
        vec3(-1570.64, -3017.02, -74.41),
        0.0,
        "WORLD_HUMAN_CLIPBOARD",
        vec3(-1570.64, -3017.02, -74.41),
        271.0
    },
    ["Bar1"] = {false, 25, "s_f_y_clubbar_01", vec3(-1576.27, -3016.55, -79.90), 0.0},
    ["Bar2"] = {false, 25, "s_f_y_clubbar_01", vec3(-1578.14, -3016.54, -79.90), 0.0},
    ["Bar3"] = {false, 25, "s_f_y_clubbar_01", vec3(-1585.03, -3012.61, -76.90), 90.0},
    ["EntranceG"] = {
        false,
        25,
        "s_f_y_clubbar_01",
        vec3(-1585.03, -3012.61, -76.90),
        0.0,
        "PROP_HUMAN_SEAT_CHAIR",
        vec3(-1572.17, -3013.49, -74.70),
        270.94
    },
    ["Ped1"] = {false, 25, "a_m_y_clubcust_01", vec3(-1591.61, -3014.70, -79.01), 73.43},
    ["Ped2"] = {false, 25, "a_f_y_clubcust_01", vec3(-1591.94, -3012.29, -79.01), 107.62},
    ["Ped3"] = {false, 25, "a_m_y_clubcust_03", vec3(-1591.96, -3009.93, -79.01), 82.72},
    ["Ped4"] = {false, 25, "a_f_y_clubcust_01", vec3(-1593.59, -3011.18, -79.01), 100.0},
    ["Ped5"] = {false, 25, "a_m_y_clubcust_01", vec3(-1594.87, -3013.23, -79.01), 75.41},
    ["Ped6"] = {false, 25, "a_f_y_clubcust_03", vec3(-1595.68, -3010.11, -79.01), 194.32},
    ["Ped7"] = {false, 25, "a_m_y_clubcust_01", vec3(-1596.82, -3011.57, -79.01), 97.57},
    ["Ped8"] = {false, 25, "a_m_y_clubcust_01", vec3(-1598.66, -3009.65, -79.01), 119.44},
    ["Ped9"] = {false, 25, "a_m_y_clubcust_02", vec3(-1599.12, -3012.36, -79.01), 69.83},
    ["Ped10"] = {false, 25, "a_f_y_clubcust_01", vec3(-1599.42, -3014.96, -79.01), 57.0},
    ["Ped11"] = {false, 25, "a_m_y_clubcust_02", vec3(-1596.74, -3016.31, -79.01), 48.74},
    ["Ped12"] = {false, 25, "a_f_y_clubcust_01", vec3(-1594.35, -3014.95, -79.01), 57.77},
    ["Ped13"] = {false, 25, "a_m_y_clubcust_01", vec3(-1586.53, -3018.35, -79.01), 52.63},
    ["Ped17"] = {false, 25, "a_m_y_clubcust_02", vec3(-1592.70, -3013.63, -79.01), 101.83},
    ["Ped18"] = {false, 25, "a_f_y_clubcust_01", vec3(-1593.22, -3012.22, -79.01), 85.53},
    ["Ped19"] = {false, 25, "a_m_y_clubcust_02", vec3(-1595.02, -3011.57, -79.01), 85.20},
    ["Ped20"] = {false, 25, "a_f_y_clubcust_01", vec3(-1596.83, -3013.09, -79.01), 91.70},
    ["Ped21"] = {false, 25, "a_m_y_clubcust_01", vec3(-1596.73, -3014.52, -79.01), 64.99},
    ["Ped22"] = {false, 25, "a_f_y_clubcust_02", vec3(-1598.19, -3013.81, -79.01), 91.67},
    ["Ped23"] = {false, 25, "a_m_y_clubcust_01", vec3(-1598.28, -3010.85, -79.01), 91.95},
    ["Ped24"] = {false, 25, "a_m_y_clubcust_03", vec3(-1598.30, -3008.66, -79.01), 93.34},
    ["Ped25"] = {false, 25, "a_m_y_clubcust_02", vec3(-1594.16, -3009.05, -79.01), 94.50},
    ["Ped26"] = {false, 25, "a_f_y_clubcust_01", vec3(-1596.49, -3009.58, -79.01), 130.58},
    ["Ped27"] = {false, 25, "a_m_y_clubcust_02", vec3(-1592.29, -3011.15, -79.01), 90.83},
    ["Ped28"] = {false, 25, "a_f_y_clubcust_01", vec3(-1594.10, -3010.15, -79.01), 101.0},
    ["Ped29"] = {false, 25, "a_m_y_clubcust_01", vec3(-1592.94, -3009.56, -79.01), 145.43},
    ["Ped30"] = {false, 25, "a_f_y_clubcust_02", vec3(-1596.83, -3009.62, -79.01), 39.07},
    ["Ped31"] = {false, 25, "a_m_y_clubcust_01", vec3(-1598.05, -3012.60, -79.01), 43.05},
    ["Ped32"] = {false, 25, "a_m_y_clubcust_03", vec3(-1599.63, -3010.95, -79.01), 151.02},
    ["Ped33"] = {false, 25, "a_m_y_clubcust_02", vec3(-1599.99, -3009.83, -79.01), 198.20},
    ["Ped14"] = {
        false,
        25,
        "a_m_y_clubcust_03",
        vec3(-1588.40, -3005.26, -79.01),
        199.0,
        "WORLD_HUMAN_PARTYING",
        vec3(-1588.40, -3005.26, -80.01),
        199.0
    },
    ["Ped15"] = {
        false,
        25,
        "a_f_y_clubcust_01",
        vec3(-1587.01, -3009.02, -79.01),
        24.60,
        "WORLD_HUMAN_PARTYING",
        vec3(-1587.01, -3009.02, -80.01),
        24.60
    },
    ["Ped16"] = {
        false,
        25,
        "a_m_y_clubcust_02",
        vec3(-1587.34, -3006.65, -79.01),
        197.9,
        "WORLD_HUMAN_PARTYING",
        vec3(-1587.34, -3006.65, -80.01),
        197.92
    },
    ["Ped34"] = {false, 25, "a_f_y_clubcust_01", vec3(-1591.08, -3018.12, -76.00), 90.0},
    ["Ped35"] = {false, 25, "a_m_y_clubcust_02", vec3(-1591.11, -3014.44, -76.00), 90.0},
    ["Ped36"] = {false, 25, "a_m_y_clubcust_03", vec3(-1591.02, -3012.08, -76.00), 90.0},
    ["Ped37"] = {false, 25, "a_m_y_clubcust_01", vec3(-1591.05, -3009.95, -76.00), 90.0},
    ["Ped38"] = {false, 25, "a_f_y_clubcust_02", vec3(-1595.41, -3007.81, -76.00), 180.0},
    ["Ped39"] = {false, 25, "a_m_y_clubcust_02", vec3(-1596.58, -3007.87, -76.00), 180.0},
    ["Ped40"] = {false, 25, "a_f_y_clubcust_01", vec3(-1601.03, -3007.79, -76.00), 180.0},
    ["Ped41"] = {false, 25, "a_m_y_clubcust_01", vec3(-1606.51, -3014.80, -77.80), 306.0},
    ["Ped42"] = {false, 25, "a_m_y_clubcust_02", vec3(-1606.49, -3013.09, -77.80), 270.0},
    ["Ped43"] = {false, 25, "a_f_y_clubcust_02", vec3(-1606.38, -3011.03, -77.80), 214.0},
    ["SittingGirl"] = {false, 25, "a_f_y_clubcust_02", vec3(-1612.689, -3010.791, -80.2060), -90.0},
    ["Attendant"] = {
        false,
        25,
        "s_m_y_clubbar_01",
        vec3(-1611.937, -3009.152, -79.2519),
        0.0,
        "PROP_HUMAN_SEAT_CHAIR",
        vec3(-1611.937, -3009.152, -79.2519),
        -131.39
    },
    ["PhoneGuy"] = {
        false,
        25,
        "a_m_y_business_02",
        vec3(-1611.937, -3009.152, -79.2519),
        0.0,
        "WORLD_HUMAN_STAND_MOBILE",
        vec3(-1611.21, -3018.67, -79.01),
        0.0
    },
    ["VomittingFemale"] = {false, 25, "s_f_y_hooker_02", vec3(-1609.22, -3015.61, -80.01), 270.0},
    ["DJ"] = {false, 25, "ig_sol", vec3(-1602.78, -3012.62, -78.80), 270.0},
    ["Dancer1"] = {false, 25, "u_f_y_dancerave_01", vec3(-1596.14, -3008.08, -79.21), 200.0},
    ["Dancer2"] = {false, 25, "u_f_y_dancerave_01", vec3(-1598.42, -3015.70, -79.21), 352.0},
    ["Tony"] = {
        false,
        25,
        "ig_tonyprince",
        vec3(-1572.28, -571.89, 108.52),
        0.0,
        "WORLD_HUMAN_STAND_MOBILE",
        vec3(-1607.90, -3014.93, -75.21),
        94.46
    }
}

local PedComponents = {
    ["EntranceG"] = {false, 0, 3, 0, 0},
    ["EntranceG"] = {false, 2, 3, 0, 0},
    ["EntranceG"] = {false, 3, 3, 0, 0},
    ["EntranceG"] = {false, 4, 1, 0, 0},
    ["EntranceG"] = {false, 8, 1, 0, 0},
    ["Bar1"] = {false, 0, 0, 0, 0},
    ["Bar1"] = {false, 2, 0, 0, 0},
    ["Bar1"] = {false, 3, 0, 0, 0},
    ["Bar1"] = {false, 4, 0, 0, 0},
    ["Bar1"] = {false, 8, 0, 0, 0},
    ["Bar2"] = {false, 0, 2, 0, 0},
    ["Bar2"] = {false, 2, 2, 0, 0},
    ["Bar2"] = {false, 3, 2, 0, 0},
    ["Bar2"] = {false, 4, 1, 0, 0},
    ["Bar2"] = {false, 8, 0, 0, 0},
    ["Bar3"] = {false, 0, 4, 0, 0},
    ["Bar3"] = {false, 2, 4, 0, 0},
    ["Bar3"] = {false, 3, 4, 0, 0},
    ["Bar3"] = {false, 4, 0, 0, 0},
    ["Bar3"] = {false, 8, 1, 0, 0}
}

local PedAnims = {
    ["Bar1"] = {false, "mini@strip_club@drink@idle_a", "idle_a_bartender"},
    ["Bar2"] = {false, "mini@strip_club@drink@idle_a", "idle_a_bartender"},
    ["Bar3"] = {false, "mini@strip_club@drink@idle_a", "idle_a_bartender"},
    ["Ped1"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center"},
    ["Ped2"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center_down"},
    ["Ped3"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "med_right"},
    ["Ped4"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "med_left"},
    ["Ped5"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "high_center_up"},
    ["Ped6"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "low_right"},
    ["Ped7"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_right"},
    ["Ped8"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "med_center_down"},
    ["Ped9"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "high_left"},
    ["Ped10"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_left_up"},
    ["Ped11"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "low_center_up"},
    ["Ped12"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "med_right_up"},
    ["Ped13"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "med_center"},
    ["Ped17"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_down"},
    ["Ped18"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "med_center"},
    ["Ped19"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "high_left"},
    ["Ped20"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "low_left"},
    ["Ped21"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "high_center"},
    ["Ped22"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center"},
    ["Ped23"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_down"},
    ["Ped24"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "med_center_up"},
    ["Ped25"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "med_left"},
    ["Ped26"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "low_right"},
    ["Ped27"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "med_center"},
    ["Ped28"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "med_center_down"},
    ["Ped29"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "high_right"},
    ["Ped30"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "med_center"},
    ["Ped31"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center_up"},
    ["Ped32"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "high_left"},
    ["Ped33"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "high_center_down"},
    ["Ped34"] = {false, "anim@amb@nightclub@dancers@club_ambientpeds@", "mi-hi_amb_club_06_base_female^1"},
    ["Ped35"] = {false, "anim@amb@nightclub@dancers@club_ambientpeds@", "mi-hi_amb_club_06_base_male^1"},
    ["Ped36"] = {false, "anim@amb@nightclub@dancers@club_ambientpeds@", "mi-hi_amb_club_06_base_male^3"},
    ["Ped37"] = {false, "anim@amb@nightclub@dancers@club_ambientpeds@", "mi-hi_amb_club_06_base_male^6"},
    ["Ped38"] = {false, "anim@amb@nightclub@dancers@club_ambientpeds@", "mi-hi_amb_club_06_base_female^4"},
    ["Ped39"] = {false, "anim@amb@nightclub@dancers@club_ambientpeds@", "mi-hi_amb_club_06_base_male^4"},
    ["Ped40"] = {false, "anim@amb@nightclub@dancers@club_ambientpeds@", "mi-hi_amb_club_06_base_female^2"},
    ["Ped41"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_right"},
    ["Ped42"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "med_center_down"},
    ["Ped43"] = {false, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "high_left"},
    ["SittingGirl"] = {false, "anim@amb@nightclub@peds@", "amb_world_human_seat_wall_female_hands_by_sides_idle_c"},
    ["VomittingFemale"] = {false, "timetable@tracy@ig_7@base", "base"},
    ["DJ"] = {false, "anim@amb@nightclub@djs@solomun@", "sol_idle_ctr_mid_a_sol"},
    ["Dancer1"] = {false, "anim@amb@nightclub@dancers@podium_dancers@", "hi_dance_facedj_17_v2_female^2"},
    ["Dancer2"] = {false, "anim@amb@nightclub@dancers@podium_dancers@", "hi_dance_facedj_17_v2_male^5"}
}

function RequestEntModel(model)
    exports["soe-utils"]:LoadModel(model, 0)
    SetModelAsNoLongerNeeded(model)
end

function playAnim(ped, animDict, animName)
    exports["soe-utils"]:LoadAnimDict(animDict, 0)
    TaskPlayAnim(ped, animDict, animName, 1.0, -1.0, -1, 1, 1, false, false, false)
    RemoveAnimDict(animDict)
end

function CreatePeds()
    for k, v in pairs(InsidePeds) do
        if not v[1] then
            RequestEntModel(v[3])
            v[1] = CreatePed(v[2], v[3], v[4], v[5], false, true)
            if v[6] ~= nil then
                TaskStartScenarioAtPosition(v[1], v[6], v[7], v[8], -1, false, true)
            end
            SetBlockingOfNonTemporaryEvents(v[1], true)
        end
        for q, t in pairs(PedComponents) do
            if q == k then
                t[1] = v[1]
            end
        end
        for i, o in pairs(PedAnims) do
            if i == k then
                o[1] = v[1]
            end
        end
        if k == "Dancer1" or k == "Dancer2" then
            FreezeEntityPosition(v[1], true)
        end
        if k == "Tony" then
            SetPedPropIndex(v[1], 1, 0, 0, true)
        end
    end
    for k, v in pairs(PedComponents) do
        SetPedComponentVariation(v[1], v[2], v[3], v[4], v[5])
    end
    for k, v in pairs(PedAnims) do
        playAnim(v[1], v[2], v[3])
    end
end

function DeletePeds()
    for k, v in pairs(InsidePeds) do
        if DoesEntityExist(v[1]) then
            DeleteEntity(v[1])
            v[1] = false
        end
    end
    for k, v in pairs(spawnedclubsmoke) do
        if DoesParticleFxLoopedExist(v) then
            StopParticleFxLooped(v, false)
        end
    end
    for k, v in pairs(spawnedsmokemachines) do
        if DoesParticleFxLoopedExist(v) then
            StopParticleFxLooped(v, false)
        end
    end
end

function CreateNamedRenderTargetForModel(name, model)
    local handle = 0
    if not IsNamedRendertargetRegistered(name) then
        RegisterNamedRendertarget(name, 0)
    end
    if not IsNamedRendertargetLinked(model) then
        LinkNamedRendertarget(model)
    end
    if IsNamedRendertargetRegistered(name) then
        handle = GetNamedRendertargetRenderId(name)
    end
    return handle
end

function EnterClub()
    BeginTextCommandBusyString("FMMC_PLYLOAD")
    EndTextCommandBusyString(4)
    DoScreenFadeOut(1000)

    Wait(1000)

    RequestIpl("ba_int_placement_ba_interior_0_dlc_int_01_ba_milo_")
    EnableInteriorProp(intID, "Int01_ba_security_upgrade")
    EnableInteriorProp(intID, "Int01_ba_equipment_setup")
    EnableInteriorProp(intID, "Int01_ba_Style03")
    EnableInteriorProp(intID, "Int01_ba_style03_podium")
    EnableInteriorProp(intID, "int01_ba_lights_screen")
    EnableInteriorProp(intID, "Int01_ba_Screen")
    EnableInteriorProp(intID, "Int01_ba_bar_content")
    EnableInteriorProp(intID, "Int01_ba_dj02")
    EnableInteriorProp(intID, "DJ_01_Lights_02")
    EnableInteriorProp(intID, "DJ_01_Lights_04")
    EnableInteriorProp(intID, "Int01_ba_lightgrid_01")
    EnableInteriorProp(intID, "Int01_ba_equipment_upgrade")
    EnableInteriorProp(intID, "Int01_ba_clubname_01")
    EnableInteriorProp(intID, "Int01_ba_dry_ice")
    EnableInteriorProp(intID, "Int01_ba_deliverytruck")
    EnableInteriorProp(intID, "Int01_ba_trophy04")
    EnableInteriorProp(intID, "Int01_ba_trophy05")
    EnableInteriorProp(intID, "Int01_ba_trophy07")
    EnableInteriorProp(intID, "Int01_ba_trophy09")
    EnableInteriorProp(intID, "Int01_ba_trophy08")
    EnableInteriorProp(intID, "Int01_ba_trophy11")
    EnableInteriorProp(intID, "Int01_ba_trophy10")
    EnableInteriorProp(intID, "Int01_ba_trophy03")
    EnableInteriorProp(intID, "Int01_ba_trophy01")
    EnableInteriorProp(intID, "Int01_ba_trophy02")
    EnableInteriorProp(intID, "Int01_ba_trad_lights")
    RefreshInterior(intID)
    --CreatePeds() -- DISABLED ON BUSINESS OWNER REQUEST 02 JUL 21'

    RequestNamedPtfxAsset("scr_ba_club")
    while not HasNamedPtfxAssetLoaded("scr_ba_club") do
        Wait(0)
    end

    for i, v in ipairs(clubsmoke) do
        if not DoesParticleFxLoopedExist(spawnedclubsmoke[i]) then
            UseParticleFxAssetNextCall("scr_ba_club")
            spawnedclubsmoke[i] = StartParticleFxLoopedAtCoord("scr_ba_club_smoke", v[1], v[2], 1.0, 0, 0, 0, 1)
            SetParticleFxLoopedColour(spawnedclubsmoke[i], 255.0, 255.0, 255.0, 1)
        end
    end

    for i, v in ipairs(smokemachines) do
        if not DoesParticleFxLoopedExist(spawnedsmokemachines[i]) then
            UseParticleFxAssetNextCall("scr_ba_club")
            spawnedsmokemachines[i] =
                StartParticleFxLoopedAtCoord("scr_ba_club_smoke_machine", v[1], v[2], 5.0, 0, 0, 0, 1)
            SetParticleFxLoopedColour(spawnedsmokemachines[i], 255.0, 255.0, 255.0, 1)
        end
    end
    RemovePtfxAsset("scr_ba_club")

    local tvmodel = "ba_prop_club_screens_01"
    local tvpos = vec3(-1600.02, -3012.55, -77.71)
    local tventity = GetClosestObjectOfType(tvpos, 0.05, tvmodel, 0, 0, 0)
    local handle = CreateNamedRenderTargetForModel("club_projector", tvmodel)

    Citizen.CreateThread(
        function()
            while inClub do
                SetTextRenderId(handle)
                SetUiLayer(4)
                SetScriptGfxDrawBehindPausemenu(1)
                DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
                SetTextRenderId(GetDefaultScriptRendertargetRenderId())
                SetScriptGfxDrawBehindPausemenu(0)
                Wait(0)
            end
        end
    )

    LoadTvChannelSequence(0, "PL_SOL_LED_GALAXY", 1)
    SetTvAudioFrontend(1)
    SetTvVolume(-5.0)
    SetTvChannel(0)

    exports["soe-fidelis"]:AuthorizeTeleport()
    SetEntityCoords(PlayerPedId(), intLoc)

    SetEntityHeading(PlayerPedId(), 0.0)
    SetGameplayCamRelativeHeading(0.0)

    Wait(1000)
    RemoveLoadingPrompt()
    DoScreenFadeIn(2000)

    Wait(1000)
    for k, v in pairs(InsidePeds) do
        FreezeEntityPosition(v[1], true)
    end
end

function ExitClub()
    BeginTextCommandBusyString("FMMC_PLYLOAD")
    EndTextCommandBusyString(4)
    DoScreenFadeOut(1000)
    Wait(1000)

    DisableInteriorProp(intID, "Int01_ba_security_upgrade")
    DisableInteriorProp(intID, "Int01_ba_equipment_setup")
    DisableInteriorProp(intID, "Int01_ba_Style03")
    DisableInteriorProp(intID, "Int01_ba_style03_podium")
    DisableInteriorProp(intID, "int01_ba_lights_screen")
    DisableInteriorProp(intID, "Int01_ba_Screen")
    DisableInteriorProp(intID, "Int01_ba_bar_content")
    DisableInteriorProp(intID, "Int01_ba_dj02")
    DisableInteriorProp(intID, "DJ_01_Lights_02")
    DisableInteriorProp(intID, "DJ_01_Lights_04")
    DisableInteriorProp(intID, "Int01_ba_lightgrid_01")
    DisableInteriorProp(intID, "Int01_ba_equipment_upgrade")
    DisableInteriorProp(intID, "Int01_ba_clubname_01")
    DisableInteriorProp(intID, "Int01_ba_dry_ice")
    DisableInteriorProp(intID, "Int01_ba_deliverytruck")
    DisableInteriorProp(intID, "Int01_ba_trophy04")
    DisableInteriorProp(intID, "Int01_ba_trophy05")
    DisableInteriorProp(intID, "Int01_ba_trophy07")
    DisableInteriorProp(intID, "Int01_ba_trophy09")
    DisableInteriorProp(intID, "Int01_ba_trophy08")
    DisableInteriorProp(intID, "Int01_ba_trophy11")
    DisableInteriorProp(intID, "Int01_ba_trophy10")
    DisableInteriorProp(intID, "Int01_ba_trophy03")
    DisableInteriorProp(intID, "Int01_ba_trophy01")
    DisableInteriorProp(intID, "Int01_ba_trophy02")
    DisableInteriorProp(intID, "Int01_ba_trad_lights")
    RefreshInterior(intID)
    RemoveIpl("ba_int_placement_ba_interior_0_dlc_int_01_ba_milo_")

    DeletePeds()
    exports["soe-fidelis"]:AuthorizeTeleport()
    SetEntityCoords(PlayerPedId(), extLoc)

    SetEntityHeading(PlayerPedId(), 42.0)
    SetGameplayCamRelativeHeading(0.0)
    Wait(1000)
    RemoveLoadingPrompt()
    DoScreenFadeIn(2000)
    Wait(1000)
end

local inClub = false
CreateThread(
    function()
        while true do
            Wait(5)
            local pos = GetEntityCoords(PlayerPedId())
            if not inClub then
                local dist = GetDistanceBetweenCoords(pos, extLoc, true)
                if dist < 50.0 then
                    if not IsPedInAnyVehicle(PlayerPedId(), true) then
                        if dist < 1.0 then
                            exports["soe-ui"]:SendUniqueAlert(
                                "enterClub",
                                "inform",
                                "Press [E] to enter club",
                                3000
                            )
                            if IsControlJustReleased(2, 38) then
                                inClub = true
                                EnterClub()
                            end
                        end
                    end
                else
                    Wait(5000)
                end
            else
                if GetInteriorAtCoords(pos) == 271617 then
                    --[[if not DoesEntityExist(InsidePeds["Bouncer1"][1]) then
                        inClub = false
                        ExitClub()
                    end]]   -- KICKS PLAYER OUT IF BOUNCER PED DOES NOT EXIST -- DISABLED ON BUSINESS OWNER REQUEST 02 JUL 21'
                    DrawSpotLight(
                        -1597.229,
                        -3012.469,
                        -74.32224,
                        0.1011411,
                        -0.004866444,
                        -0.9948602,
                        0,
                        0,
                        255,
                        15.0,
                        2.0,
                        10.0,
                        50.0,
                        200.0
                    )
                end
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), intLoc, true) < 15.0 then
                    if not IsPedInAnyVehicle(PlayerPedId(), true) then
                        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), intLoc, true) < 1.0 then
                            exports["soe-ui"]:SendUniqueAlert("exitClub", "inform", "Press [E] to exit club", 3000)
                            if IsControlJustReleased(2, 38) then
                                inClub = false
                                ExitClub()
                            end
                        end
                    end
                end
            end
        end
    end
)
