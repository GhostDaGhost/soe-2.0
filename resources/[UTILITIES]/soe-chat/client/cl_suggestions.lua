AddEventHandler(
    "onClientResourceStart",
    function(resource)
        if (GetCurrentResourceName() ~= resource) then return end

        -- WAIT A FEW SECONDS FOR STUFF TO LOAD
        Wait(8000)

        AddSuggestion("/dev", "Dev Tools")
        AddSuggestion("/mod", "Staff Tools")
        AddSuggestion(
            "/mod ban",
            "Bans the selected player from the server for the set duration",
            {
                {name = "Player ID", help = "Player's ID from the server list"},
                {name = "Duration", help = "Duration of the ban (1d, 1h, 1m, 1w, etc.)"},
                {name = "Reason", help = "The reason for the ban (Do not include your name)"}
            }
        )

        AddSuggestion(
            "/say",
            "Makes an announcement to the entire server",
            {{name = "Message", help = "Enter message here"}}
        )
        AddSuggestion(
            "/warppoi",
            "Teleports to specified coordinates",
            {{name = "X Y Z", help = "Enter coordinates"}}
        )
        AddSuggestion("/warpwp", "Teleports to set waypoint")

        AddSuggestion("/13", "Activates panic button")
        AddSuggestion(
            "/alert",
            "Sends a island-wide emergency services advisory",
            {{name = "Message", help = "Enter message here"}}
        )
        AddSuggestion("/ambulance", "Sends the local medics to your location")
        AddSuggestion("/anchor", "Deploys/brings up your boat anchor")
        AddSuggestion(
            "/arrest",
            "Sends the targeted player to prison for a specified amount of time and reason",
            {
                {name = "Player ID", help = "Player's ID from the server list"},
                {name = "Time", help = "Enter time here (1 = 1 Minute, etc)"},
                {name = "Reason", help = "Enter reason here"}
            }
        )
        AddSuggestion("/badge", "Shows your department/group issued badge")
        AddSuggestion("/bag", "Toggles your bag")
        AddSuggestion("/bed", "Puts you into the nearest medical bed and heals you")
        AddSuggestion("/belt", "Toggles seatbelt on/off")
        AddSuggestion(
            "/bill",
            "Gives the targeted player a bill for a specified amount and reason",
            {
                {name = "Player ID", help = "Player's ID from the server list"},
                {name = "Amount", help = "Enter amount here (1 = $1, etc)"},
                {name = "Reason", help = "Enter reason here"}
            }
        )
        AddSuggestion("/bodybag", "Removes dead AI bodies")
        AddSuggestion("/bracelet", "Toggles your bracelet")
        AddSuggestion(
            "/callsign",
            "Sets/Changes your emergency services callsign",
            {{name = "Assigned Callsign", help = "Enter numbers here"}}
        )
        AddSuggestion("/carry", "Carries the nearest player or NPC")
        AddSuggestion("/coroner", "Sends the local coroner to your location")
        AddSuggestion("/cuff", "Handcuffs/Uncuffs nearest player")
        AddSuggestion("/ziptie", "Zip-ties/Releases nearest player")
        AddSuggestion("/drag", "Forcibly drag nearest player or NPC")
        AddSuggestion(
            "/do",
            "Sends a third-person action message to anyone nearby",
            {{name = "Message", help = "Enter message here"}}
        )
        AddSuggestion("/doggo", "Transform into a dog")
        AddSuggestion(
            "/door",
            "Opens vehicle door",
            {{name = "fl/fr/bl/br", help = "Choose a door to open"}}
        )
        AddSuggestion("/duty", "Opens Duty Menu")
        AddSuggestion(
            "/e",
            "Play an emote",
            {{name = "Emote Name", help = "dance, camera, sit or any valid emote"}}
        )
        AddSuggestion("/ear", "Toggles earpiece")
        AddSuggestion(
            "/ems",
            "Sends a reminder to the targeted downed player",
            {{name = "Player ID", help = "Player's ID from the server list"}}
        )
        AddSuggestion(
            "/emote",
            "Play an emote",
            {{name = "Emote Name", help = "dance, camera, sit or any valid emote"}}
        )
        AddSuggestion("/emotemenu", "Opens Emote Menu")
        AddSuggestion("/engine", "Toggle Vehicle Engine On/Off")
        AddSuggestion("/escort", "Escort nearest player or NPC")
        AddSuggestion(
            "/evac",
            "Sends the targeted player to a hospital at a cost",
            {{name = "Player ID", help = "Player's ID from the server list"}}
        )
        AddSuggestion(
            "/g",
            "Sends a message to the global help chat",
            {{name = "Message", help = "Enter message here"}}
        )
        --AddSuggestion("/getintrunk", "Puts you into the vehicle's trunk that you're facing")
        AddSuggestion("/glasses", "Toggles your glasses")
        AddSuggestion("/gps", "Toggles your location indicator to top or bottom left next to minimap")
        AddSuggestion("/hair", "Puts your hair to a bun/ponytail")
        AddSuggestion("/hat", "Toggles your hat/helmet")
        AddSuggestion("/heal", "Heals closest player")
        AddSuggestion("/hotwire", "Hotwires the vehicle you are in")
        AddSuggestion("/hood", "Opens vehicle hood/bonnet")
        AddSuggestion("/hud", "Toggles all visible UI")
        AddSuggestion(
            "/l",
            "Sends a local OOC message to anyone nearby",
            {{name = "Message", help = "Enter message here"}}
        )
        AddSuggestion("/local911", "Sends a locally called EMS CAD Alert if you are dead")
        AddSuggestion("/localtow", "Sends the local tow company to your location")
        AddSuggestion("/mask", "Toggles your facial mask")
        AddSuggestion(
            "/mdt",
            "Sends the targeted player an MDT message",
            {
                {name = "Callsign", help = "Target callsign"},
                {name = "Message", help = "Enter message here"}
            }
        )
        AddSuggestion(
            "/me",
            "Sends a first-person action message to anyone nearby",
            {{name = "Message", help = "Enter message here"}}
        )
        AddSuggestion(
            "/ncic",
            "Runs an individual's record",
            {{name = "Subject's SSN or Full Name", help = "SSN or Full Name of subject (Example: First/Last)"}}
        )
        AddSuggestion("/ncicfull", "Displays a full record printout of the last ran NCIC record")
        AddSuggestion(
            "/nearby",
            "Sends a shared emote request to anyone nearby",
            {{name = "Emote Name", help = "Enter emote name (must be from Shared Emotes)"}}
        )
        AddSuggestion("/neck", "Toggles your necklace/tie/holster")
        AddSuggestion(
            "/ooc",
            "Sends a local OOC message to anyone nearby.",
            {{name = "Message", help = "Enter message here"}}
        )
        AddSuggestion(
            "/paytow",
            "Pays the targeted player to tow a vehicle",
            {{name = "Player ID", help = "Player's ID from the server list"}}
        )
        AddSuggestion(
            "/pm",
            "Sends private message to the selected player",
            {
                {name = "Player ID", help = "Player's ID from the server list"},
                {name = "Message", help = "Enter message here"}
            }
        )
        AddSuggestion("/pants", "Toggles your pants")
        AddSuggestion(
            "/pet",
            "Changes your displayed name to the parameter you enter",
            {{name = "Preferred Name", help = "Enter name here"}}
        )
        AddSuggestion("/muteboombox", "Mutes/unmutes boomboxes.")
        AddSuggestion("/mutephone", "Mutes/unmutes phone notification icons.")
        AddSuggestion("/mutedispatch", "Mutes receiving CAD alerts sound.")
        AddSuggestion("/piggyback", "Give the closest player or NPC a piggyback ride")
        AddSuggestion(
            "/pinfo",
            "Retrieve a target player's information",
            {{name = "Player ID", help = "Player's ID from the server list (-1 for ALL players)"}}
        )
        AddSuggestion("/pullout", "Pulls out all occupants of a vehicle.")
        AddSuggestion("/takefromcar", "Pulls out all occupants of a vehicle.")
        AddSuggestion("/putincar", "Puts escorted/held/carried player into the nearest vehicle")
        AddSuggestion("/rv", "Deletes closest vehicle")
        AddSuggestion("/radio", "Opens your radio (if you have one)")
        AddSuggestion(
            "/rehab",
            "Sends targeted player to Parsons for evaluation",
            {
                {name = "Player ID", help = "Player's ID from the server list"},
                {name = "Reason", help = "Enter reason here"}
            }
        )
        AddSuggestion(
            "/rehabrelease",
            "Releases targeted player from Parsons",
            {{name = "Player ID", help = "Player's ID from the server list"}}
        )
        AddSuggestion(
            "/reportveh",
            "Reports vehicle with a flag",
            {
                {name = "Stolen/Recovered", help = "Enter status here"},
                {name = "License Plate #", help = "Enter license plate here"}
            }
        )
        AddSuggestion("/reset_radar_data", "Resets speed radar saved configuration")
        AddSuggestion(
            "/respawn",
            "Revives you and takes you to nearest hospital (If SAFR isn't active)"
        )
        AddSuggestion("/revertclothing", "Resets your clothing toggles")
        AddSuggestion("/revive", "Revive closest AI ped/player")
        AddSuggestion("/rights", "Show nearby players the Miranda Warning")
        AddSuggestion(
            "/roll",
            "Rolls a dice",
            {
                {
                    name = "(#)d(Sides)",
                    help = "Rolls number of dice equal to (#) with (Sides) Example: 2d20, (Two: 20 sided dice)"
                }
            }
        )
        AddSuggestion(
            "/runplate",
            "Runs a vehicle plate",
            {{name = "License Plate #", help = "Enter plate here"}}
        )
        AddSuggestion("/shirt", "Toggles your shirt/jacket as well as undershirt and gloves")
        AddSuggestion("/shoes", "Toggles your shoes")
        AddSuggestion("/shuffle", "Seat shuffles to the next vehicle seat available")
        AddSuggestion(
            "/sound",
            "Changes volume of game SFX (seatbelt, spikes etc)",
            {{name = "0.0 - 1.0", help = "Choose volume"}}
        )
        AddSuggestion(
            "/status",
            "Sets your status message",
            {{name = "Message", help = "Enter message here"}}
        )
        AddSuggestion("/sv", "Opens Motor Pool Menu for Emergency Services players")
        AddSuggestion(
            "/spotlight",
            "Creates massive burst of light from sides or front",
            {{name = "front/left/right", help = "Choose direction"}}
        )
        AddSuggestion(
            "/trailer",
            "Opens trailer doors",
            {{name = "bl/br/trunk/lower", help = "Choose a door to open"}}
        )
        AddSuggestion(
            "/ticket",
            "Gives the targeted player a ticket for a specified amount and reason",
            {
                {name = "Player ID", help = "Player's ID from the server list"},
                {name = "Amount", help = "Enter amount here (1 = $1, etc)"},
                {name = "Reason", help = "Enter reason here"}
            }
        )
        AddSuggestion("/triage", "Checks nearest player's injuries")
        AddSuggestion("/triageself", "Checks your injuries")
        AddSuggestion("/trunk", "Opens vehicle trunk/boot")
        AddSuggestion("/trunk2", "Opens vehicle's alternate trunk/boot")
        AddSuggestion("/top", "Toggles your top")
        AddSuggestion("/vest", "Toggles your armor vest")
        AddSuggestion("/visor", "Toggles your helmet visor")
        AddSuggestion(
            "/walk",
            "Sets your walking style",
            {{name = "Style Name", help = "Name of walkstyle (do /walks for a list)"}}
        )
        AddSuggestion("/watch", "Toggles your watch")
        AddSuggestion("/xyz", "Shows your current coordinates and heading on screen.")
        AddSuggestion(
            "/killalarm",
            "Kills an alarm belonging to the alarm ID",
            {{name = "Alarm ID", help = "Enter an alarm ID"}}
        )
        AddSuggestion(
            "/cctv",
            "Accesses a security camera belonging to the camera ID",
            {{name = "Camera ID", help = "Enter an camera ID"}}
        )
        AddSuggestion("/frisk", "Frisks the individual in front of you for weapons")
        AddSuggestion("/inv", "Opens your inventory")
        AddSuggestion("/taxi", "Toggles your job duty inside a taxi")
        AddSuggestion("/requesttow", "Requests a tow truck for the vehicle you are facing")
        AddSuggestion("/towonduty", "Returns the amount of tow trucks on duty")
        AddSuggestion("/techsonduty", "Returns weather or not a lab tech is on duty")
        AddSuggestion("/impound", "Marks the vehicle you are facing for impound")
        AddSuggestion("/sit", "Makes you sit on the nearest supported chair")
        AddSuggestion("/givekeys", "Gives a spare set of your vehicle keys to the nearest player")
        AddSuggestion("/tablet", "Opens your tablet UI if you have one.")
        AddSuggestion("/putinbed", "Puts carried/escorted/dragged player onto a hospital bed")
        AddSuggestion("/takefrombed", "Assists the closest player off a hospital bed")
        AddSuggestion("/hospitallogs", "Requests check-in logs within 12 hours from Pillbox Hospital")
        AddSuggestion("/notifylog", "Opens a log full of past/recent mythic notifications")
        AddSuggestion("/searchgarage", "Accesses a person's valet as an LEO", {{name = "SSN", help = "Enter an SSN"}})
        AddSuggestion("/a", "Sends a private message to all online staff members", {{name = "Message", help = "Enter message here"}})
        AddSuggestion("/identify", "Attempts to identify the closest player's SSN")
        AddSuggestion("/bikerentals", "Toggles blips in the map for bike rentals")
        AddSuggestion("/ssn", "Shows your character ID - Only visible to you")
        AddSuggestion("/dob", "Shows your character's birthday - Only visible to you")
        AddSuggestion("/answer", "Answers a pending emergency services call.")
        AddSuggestion("/hangup", "Terminates the active emergency services call.")
        AddSuggestion("/radar", "Opens radar remote", {{name = "New Speed", help = "Enter new fastest speed limit here"}})
        AddSuggestion("/vin", "Find the VIN of the vehicle in front of you.")
        AddSuggestion("/job", "Get your current job or employment status.")
        AddSuggestion("/signticket", "Signs the pending citation given by an LEO.")
        AddSuggestion("/refuseticket", "Refuses the pending citation given by an LEO.")
        AddSuggestion("/hold", "Holds the nearest player or NPC")
        AddSuggestion("/decals", "Toggles your clothing decals.")
        AddSuggestion("/scene", "Opens scene creation menu.")
        AddSuggestion("/clearwants", "Clears all wants on a player.", {{name = "SSN", help = "Enter an SSN."}})
        AddSuggestion("/removescene", "Removes a scene by its unique ID.", {{name = "Scene ID", help = "Enter ID here"}})
        AddSuggestion("/warrant", "Issues an arrest warrant on a player.", {{name = "SSN", help = "Enter an SSN."}, {name = "Reason", help = "Enter warrant details (timestamp is not needed)"}})
        AddSuggestion("/want", "Issues a want on a player.", {{name = "SSN", help = "Enter an SSN."}, {name = "Reason", help = "Enter want details (timestamp is not needed)"}})
        AddSuggestion("/courtorder", "Issues a court order on a player.", {{name = "SSN", help = "Enter an SSN."}, {name = "Reason", help = "Enter order details (timestamp is not needed)"}})
        AddSuggestion("/cautioncode", "Issues a caution code on a player.", {{name = "SSN", help = "Enter an SSN."}, {name = "Code", help = "Enter caution code."}})
        AddSuggestion("/getemail", "Issues a state email with the entered password (if eligible).", {{name = "Password", help = "Password for the generated email account."}})
        AddSuggestion("/cornersell", "Toggles corner selling status.", {{name = "meth/coke/weed/shrooms/crack", help = "Enter drug here to sell."}})
        AddSuggestion("/fish", "Starts fishing if in a valid/illegal fishing spot.")
        --AddSuggestion("/wash", "Cleans off any GSR on your hands if in water.")
        AddSuggestion("/copyxyz", "Copies your coords and heading in the vector4 format into your clipboard.")
        AddSuggestion("/help", "Opens a help guide with tips on what to do in the city.")
        AddSuggestion("/locker", "Opens your personal locker. You must be in a locker room and be either an LEO or EMS.")
        AddSuggestion("/togglehelp", "Mutes/unmutes help chat.")
        AddSuggestion("/togglestaffchat", "Mutes/unmutes staff chat. (Staff Only)")
        AddSuggestion("/toggleexitmsgs", "Mutes/unmutes exit messages. (Staff Only)")
        AddSuggestion("/sniff", "Sniffs closest player.")
        AddSuggestion("/sniffveh", "Sniffs closest vehicle.")
        AddSuggestion("/plant", "Plants a weed plant pot if you have the required items.")
        AddSuggestion("/harvest", "Harvests the closest weed plant.")
        AddSuggestion("/getintrunk", "Gets inside the trunk of the nearest vehicle.")
        AddSuggestion("/putintrunk", "Puts escorted/held/carried player into the nearest vehicle's trunk.")
        AddSuggestion("/bindemote", "Saves an emote to a keybind number.", {{name = "Bind Number", help = "Enter number from a range of 1-5."}, {name = "Emote", help = "Enter a valid emote name."}})
        AddSuggestion("/evidence", "Opens evidence locker by its event ID.", {{name = "Event Number", help = "Enter event number to access its evidence locker."}})
        AddSuggestion("/trash", "Opens the trash to dump junk in it. You must be in a locker room and be either an LEO or EMS.")
        AddSuggestion("/respond", "Responds to the latest CAD alert.", {{name = "CAD Alert ID", help = "Responds to the CAD alert matching the ID."}})
        AddSuggestion("/tattoo", "Opens tattoo menu to customize the server ID's tattoos.", {{name = "Server ID (TTID)", help = "Enter target's server ID."}})
        AddSuggestion("/killswitch", "Triggers the LAST killswitch you equipped in a vehicle.")
        AddSuggestion("/cleartowcalls", "Clears all pending tow calls on your end.")
        AddSuggestion("/tow", "Places the vehicle you are facing on your flatbed.")
        AddSuggestion("/neons color", "Sets your neon light color by RGB code.", {
            {name = "Red", help = "Set the red value within RGB code. (0-255)"},
            {name = "Green", help = "Set the green value within RGB code. (0-255)"},
            {name = "Blue", help = "Set the blue value within RGB code. (0-255)"}
        })
        AddSuggestion("/neons", "Neon underglow control command.", {{name = "on, off, sequence, flash, controller", help = "Enter one of the options available."}})
        AddSuggestion("/unload", "Clears all ammo in your current firearm.")
        AddSuggestion("/closet", "Accesses a clothing menu when inside a property.")
        AddSuggestion("/vsync", "Forces a re-sync of your Mumble VOIP connection.")
        AddSuggestion("/grid", "Prints out your current grid. (Useful for VOIP Debugging)")
        AddSuggestion("/emotes", "Shows a list of usable normal animations in the chat.")
        AddSuggestion("/moods", "Shows a list of usable moods in the chat.")
        AddSuggestion("/sharedemotes", "Shows a list of usable shared animations in the chat.")
        AddSuggestion("/mood", "Play a mood", {{name = "Mood Name", help = "angry, aiming or any valid mood."}})
        AddSuggestion("/requestlawyer", "Requests a lawyer if you are an LEO.")
        AddSuggestion("/lawyeronduty", "Returns the amount of lawyers online.")
        AddSuggestion("/factions", "Opens factions menu.")
        AddSuggestion("/rolldown", "Rolls down the front two vehicle windows", {{name = "all", help = "Rolls down all windows if the driver or front passenger."}})
        AddSuggestion("/rollup", "Rolls up the front two vehicle windows", {{name = "all", help = "Rolls up all windows if the driver or front passenger."}})
        AddSuggestion("/bolo", "Sets your plate reader's plate to look out for.", {{name = "License Plate", help = "Enter target plate. (Put nothing to clear)"}})
        AddSuggestion("/resetui", "Resets any active NUI instance.")
        AddSuggestion("/chatsize", "Opens an input box for you to set your chat size. Saves through logins/raptures.")
        AddSuggestion("/ui", "Opens settings to allow configuration of various things in the server.")
        AddSuggestion("/staff", "Shows a list of online staff and their server IDs on duty.")
        AddSuggestion("/dances", "Gives you a number of dances that you could enter with /dance")
        AddSuggestion("/dance", "Does a dance by its inputted number. (No input does a random dance)", {{name = "Number", help = "Enter number of dance (no input does random dance)."}})

        -- POLYZONE
        AddSuggestion("/pzadd", "Adds point to zone")
        AddSuggestion("/pzcancel", "Cancel zone creation")
        AddSuggestion("/pzfinish", "Finishes and prints zone")
        AddSuggestion("/pzundo", "Undoes the last point added")
        AddSuggestion("/pzcomboinfo", "Prints some useful info for all created ComboZones")
        AddSuggestion("/pzlast", "Starts creation of the last zone you finished (only works on BoxZone and CircleZone)")
        AddSuggestion("/pzcreate", "Starts creation of a zone for PolyZone of one of the available types: circle, box, poly", {{name = "zoneType", help = "Zone Type (required)"}})

        -- REMOVE SUGGESTIONS FOR REBINDABLE COMMANDS
        RemoveSuggestion("/radar_fr_ant")
        RemoveSuggestion("/radar_bk_ant")
        RemoveSuggestion("/radar_fr_cam")
        RemoveSuggestion("/radar_bk_cam")
        RemoveSuggestion("/cruise")
        RemoveSuggestion("/readplate")
        RemoveSuggestion("/neutral")
        RemoveSuggestion("/ragdoll")
        RemoveSuggestion("/+point")
        RemoveSuggestion("/-point")
        RemoveSuggestion("/+radiotalk")
        RemoveSuggestion("/-radiotalk")
        RemoveSuggestion("/tackle")
        RemoveSuggestion("/powercall")
        RemoveSuggestion("/sirentoggle")
        RemoveSuggestion("/sirenswitch")
        RemoveSuggestion("/cycleproximity")
        RemoveSuggestion("/slashtire")
        RemoveSuggestion("/teleport")
        RemoveSuggestion("/radialmenu")
        RemoveSuggestion("/showgarage")
        RemoveSuggestion("/pickupsnowball")
        RemoveSuggestion("/handsup")
        RemoveSuggestion("/hazards")
        RemoveSuggestion("/leftblinker")
        RemoveSuggestion("/rightblinker")
        RemoveSuggestion("/pickupbloodsplatter")
        RemoveSuggestion("/pickupcasing")
        RemoveSuggestion("/pickupfingerprints")
        RemoveSuggestion("/ec")
        RemoveSuggestion("/emergencylighttoggle")
        RemoveSuggestion("/lockvehicle")
        RemoveSuggestion("/binos")
        RemoveSuggestion("/+showcounter")
        RemoveSuggestion("/-showcounter")
        RemoveSuggestion("/+moveDown")
        RemoveSuggestion("/-moveDown")
        RemoveSuggestion("/+moveUp")
        RemoveSuggestion("/-moveUp")
        RemoveSuggestion("/+moveRight")
        RemoveSuggestion("/-moveRight")
        RemoveSuggestion("/+moveLeft")
        RemoveSuggestion("/-moveLeft")
        RemoveSuggestion("/cycleguns")
        RemoveSuggestion("/callspeaker")
        RemoveSuggestion("/toggleChat")
        RemoveSuggestion("/doors_togglestate")
        RemoveSuggestion("/pushveh")
        RemoveSuggestion("/pickupitem")
        RemoveSuggestion("/+menuv_close")
        RemoveSuggestion("/+menuv_close_all")
        RemoveSuggestion("/+menuv_down")
        RemoveSuggestion("/+menuv_up")
        RemoveSuggestion("/+menuv_enter")
        RemoveSuggestion("/+menuv_left")
        RemoveSuggestion("/+menuv_right")
        RemoveSuggestion("/-menuv_close")
        RemoveSuggestion("/-menuv_close_all")
        RemoveSuggestion("/-menuv_down")
        RemoveSuggestion("/-menuv_up")
        RemoveSuggestion("/-menuv_enter")
        RemoveSuggestion("/-menuv_left")
        RemoveSuggestion("/-menuv_right")
        RemoveSuggestion("/_radar_key_lock")
        RemoveSuggestion("/alertui")
        RemoveSuggestion("/cs")
        RemoveSuggestion("/dispatch_moveleft")
        RemoveSuggestion("/dispatch_moveright")
        RemoveSuggestion("/dispatch_movemode")
        RemoveSuggestion("/+airhorn")
        RemoveSuggestion("/-airhorn")
        RemoveSuggestion("/+airhorn2")
        RemoveSuggestion("/-airhorn2")
        RemoveSuggestion("/+chirp")
        RemoveSuggestion("/-chirp")
        RemoveSuggestion("/+chirp2")
        RemoveSuggestion("/-chirp2")
        RemoveSuggestion("/opengphone")
        RemoveSuggestion("/openradar_remote")
        RemoveSuggestion("/+togglegphonecam")
        RemoveSuggestion("/-togglegphonecam")
        RemoveSuggestion("/noclip_speed")
        RemoveSuggestion("/pickupbasketball")
        RemoveSuggestion("/rollbasketball")
        RemoveSuggestion("/+shootbasketball")
        RemoveSuggestion("/-shootbasketball")
        RemoveSuggestion("/dropbasketball")
        RemoveSuggestion("/dribblebasketball")
        RemoveSuggestion("/bigalertui")
        RemoveSuggestion("/crouch")
        RemoveSuggestion("/prone")
        RemoveSuggestion("/finalizetow")
        RemoveSuggestion("/hotdog_togglesale")
        RemoveSuggestion("/hotdog_restock")
        RemoveSuggestion("/helicam_lock")
        RemoveSuggestion("/helicam_vision")
        RemoveSuggestion("/dogjump")
        RemoveSuggestion("/+usejerrycan")
        RemoveSuggestion("/-usejerrycan")
        RemoveSuggestion("/emote_bind1")
        RemoveSuggestion("/emote_bind2")
        RemoveSuggestion("/emote_bind3")
        RemoveSuggestion("/emote_bind4")
        RemoveSuggestion("/emote_bind5")
        RemoveSuggestion("/tow_spawntruck")
        RemoveSuggestion("/+secondaryradiotalk")
        RemoveSuggestion("/-secondaryradiotalk")
        RemoveSuggestion("/clearlicenseui")
    end
)
