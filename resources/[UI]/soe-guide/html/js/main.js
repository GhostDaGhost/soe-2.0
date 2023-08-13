// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let type = event.data.type
    switch(type) {
        case 'Guide.Open':
            $('body').fadeIn();
            break;
        case 'Guide.ResetUI':
            CloseGuideUI();
            console.log('[Guide] UI resetted.');
            break;
        default:
            console.log("Invalid type passed to NUI (" + type + ")");
            break;
    }
});

function CloseGuideUI() {
    $.post('https://soe-guide/Guide.Close', JSON.stringify({}));
    $('body').fadeOut();
}

function buildTable() {
    if ($("#data-table")[0]) {
        $("#data-table").DataTable({
            autoWidth: !1,
            responsive: !0,
            stateSave: true,
            stateDuration: 60,
            order: [
                [5, "desc"]
            ],
            lengthMenu: [
                [15, 30, 45, -1],
                ["15 Rows", "30 Rows", "45 Rows", "Everything"]
            ],
            language: {
                searchPlaceholder: "Search..."
            },
            sDom: '<"dataTables__top"flB>rt<"dataTables__bottom"ip><"clear">',
            initComplete: function () {}
        })
    }
    $('div.dataTables_length select').addClass('bg-dark-blue');
}

$(() => {
    $(document).on('keydown', (event) => {
        if (event.key == "Escape") {
            CloseGuideUI()
        }
    });

    jQuery.each(commands, function (command) {
        $('#data-table tbody').append('<tr><td>' + this.command + '</td><td>' + this.parameters + '</td><td>' + this.example + '</td><td>' + this.alias + '</td><td>' + this.description + '</td><td>' + this.category + '</td></tr>')

    });
    buildTable();
});

// Commands list below
var commands = [{
        "command": "/me",
        "parameters": "message",
        "example": "/me takes out his wallet",
        "alias": "",
        "description": "Send message in the third person. e.g., \"/me waves\" = \"Daniel waves\"",
        "category": "Chat"
    },
    {
        "command": "/do",
        "parameters": "message",
        "example": "/do Front passenger door opens",
        "alias": "",
        "description": "Send action message. e.g., \"/do Front passenger door opens\" = \"Front passenger door opens\"",
        "category": "Chat"
    },
    {
        "command": "/pm",
        "parameters": "Player ID, Message",
        "example": "/pm 23 This is an OOC message",
        "alias": "",
        "description": "Send a private message to a player with the specified player ID",
        "category": "Chat"
    },
    {
        "command": "/emote",
        "parameters": "Emote Name",
        "example": "/emote sit",
        "alias": "/e",
        "description": "This is used to play emotes/animations",
        "category": "General"
    },
    {
        "command": "/emotemenu",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "This is used to open the emote/walkstyles/moods menu.",
        "category": "General"
    },
    {
        "command": "/wash",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Cleans off any GSR on your hands if in water.",
        "category": "General"
    },
    {
        "command": "/gps",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Toggles your location indicator from top or bottom. This is saved within character's data every relog.",
        "category": "General"
    },
    {
        "command": "/hud",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Toggles your visible UI.",
        "category": "General"
    },
    {
        "command": "/xyz",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Shows your current coordinates",
        "category": "Dev"
    },
    {
        "command": "/carry",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "This will allow you to carry any player/NPC.",
        "category": "Interaction"
    },
    {
        "command": "/drag",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "This will allow you to drag any player/NPC.",
        "category": "Interaction"
    },
    {
        "command": "/hold",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "This will allow you to hold any player/NPC.",
        "category": "Interaction"
    },
    {
        "command": "/escort",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "This will allow you to escort any player/NPC.",
        "category": "Interaction"
    },
    {
        "command": "/piggyback",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "This will allow you to give a piggyback ride to any player/NPC.",
        "category": "Interaction"
    },
    {
        "command": "/dob",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Shows your character's DOB only to your chat.",
        "category": "General"
    },
    {
        "command": "/vin",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Looks for the VIN of the vehicle you are facing.",
        "category": "General"
    },
    {
        "command": "/ssn",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Shows your character's SSN only to your chat.",
        "category": "General"
    },
    {
        "command": "/fish",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Starts fishing if you have a rod and bait at a suitable location.",
        "category": "General"
    },
    {
        "command": "/chatsize",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Opens an input box for you to set your chat size. Saves through logins/raptures.",
        "category": "General"
    },
    {
        "command": "/cornersell",
        "parameters": "meth/coke/weed/shrooms/crack",
        "example": "",
        "alias": "",
        "description": "Toggles corner selling for drugs.",
        "category": "General"
    },
    {
        "command": "/pullout",
        "parameters": "",
        "example": "",
        "alias": "/takefromcar",
        "description": "This can be used to pull people out of a vehicle.",
        "category": "General"
    },
    {
        "command": "/putincar",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Puts a carried/escorted person into the car.",
        "category": "General"
    },
    {
        "command": "/radio",
        "parameters": "",
        "example": "",
        "alias": "F4",
        "description": "This opens your radio to choose channels or enable/disable.",
        "category": "General"
    },
    {
        "command": "/resetui",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Resets any active NUI instance.",
        "category": "General"
    },
    {
        "command": "/roll",
        "parameters": "(#)d(Sides)",
        "example": "/roll 1d8",
        "alias": "",
        "description": "Rolls number of dice equal to (#) with (Sides) Example: 2d20, (Two: 20 sided dice)",
        "category": "General"
    },
    {
        "command": "/guide",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Opens this commands guide.",
        "category": "General"
    },
    {
        "command": "/notifylog",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Opens a log full of past mythic notifications.",
        "category": "General"
    },
    {
        "command": "/badge",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Shows your department/group badge to anyone nearby.",
        "category": "General"
    },
    {
        "command": "/respawn",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Respawns you and takes you to the nearest hospital when your timer is up and no SAFR is on.",
        "category": "General"
    },
    {
        "command": "/bed",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Puts yourself into a hospital bed to heal yourself and get treated.",
        "category": "General"
    },
    {
        "command": "/cuff",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Hard cuffs/soft cuffs and can uncuff an individual from behind if you have handcuffs.",
        "category": "General"
    },
    {
        "command": "/triage",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Checks the closest player's injuries. If there is no player, it'll look for the closest NPC's cause of death.",
        "category": "General"
    },
    {
        "command": "/triageself",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Checks your own injuries.",
        "category": "General"
    },
    {
        "command": "/refuseticket",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Refuses to sign your name onto a pending citation issued by an LEO. It could have consequences.",
        "category": "General"
    },
    {
        "command": "/signticket",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Signs your name onto a pending citation issued by an LEO. It will give you a citation inventory item as well.",
        "category": "General"
    },
    {
        "command": "/revive",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Makes a player alive again",
        "category": "Emergency Services"
    },
    {
        "command": "/rv",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Will remove the vehicle in front of you",
        "category": "Emergency Services"
    },
    {
        "command": "/bodybag",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Removes dead NPC bodies",
        "category": "Emergency Services"
    },
    {
        "command": "/duty",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Opens Duty Menu.",
        "category": "Emergency Services"
    },
    {
        "command": "/sv",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Opens Service Vehicles Menu.",
        "category": "Emergency Services"
    },
    {
        "command": "/doggo",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Turns you into a dog for K-9 usage.",
        "category": "Emergency Services"
    },
    {
        "command": "/reportveh",
        "parameters": "Flag | License Plate",
        "example": "/reportveh stolen PLATE123 OR /reportveh recovered PLATE123",
        "alias": "",
        "description": "Flags a vehicle either stolen or recovered.",
        "category": "LEO"
    },
    {
        "command": "/bolo",
        "parameters": "License Plate",
        "example": "/bolo PLATE123 | /bolo (putting nothing would clear last BOLO'd plate)",
        "alias": "",
        "description": "Sets your plate reader's plate to look out for.",
        "category": "LEO"
    },
    {
        "command": "/runplate",
        "parameters": "License Plate",
        "example": "/runplate PLATE123",
        "alias": "",
        "description": "Runs the plate indicated for the owner's name and any flags.",
        "category": "LEO"
    },
    {
        "command": "/ncic",
        "parameters": "SSN/Full Name",
        "example": "/ncic Daniel/Madsen OR /ncic 12",
        "alias": "",
        "description": "Searches the character indicated's arrest/ticket records.",
        "category": "LEO"
    },
    {
        "command": "/ncicfull",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Prints out a list of arrests/tickets from the LAST NCIC record you ran.",
        "category": "LEO"
    },
    {
        "command": "/callsign",
        "parameters": "Assigned Callsign",
        "example": "/callsign D35",
        "alias": "",
        "description": "Registers your callsign within the game. Persistent through raptures and relogs.",
        "category": "Emergency Services"
    },
    {
        "command": "/mdt",
        "parameters": "Callsign | Message",
        "example": "/mdt D35 Hello!",
        "alias": "",
        "description": "Sends an MDT message to the callsign entered.",
        "category": "Emergency Services"
    },
    {
        "command": "/rehab",
        "parameters": "Player ID | Reason",
        "example": "/rehab 1 Being a crazy person.",
        "alias": "",
        "description": "Puts the player indicated into rehabilition at the Parsons Rehab Center. The opposite of /arrest.",
        "category": "SAFR"
    },
    {
        "command": "/rehabrelease",
        "parameters": "Player ID",
        "example": "/rehabrelease 1",
        "alias": "",
        "description": "Releases the player indicated from Parsons Rehab Center.",
        "category": "SAFR"
    },
    {
        "command": "/cautioncode",
        "parameters": "SSN/Full Name | Code",
        "example": "/cautioncode Daniel/Madsen G || /cautioncode 12 G",
        "alias": "",
        "description": "Issues a caution code to the character indicated.",
        "category": "LEO"
    },
    {
        "command": "/ticket",
        "parameters": "Player ID | Amount | Reason",
        "example": "/ticket 1 1000 Running a Red Light",
        "alias": "",
        "description": "Issues a citation to the player indicated. Allows the player to choose between signing/refusing. The amount when accepted adds to state debt.",
        "category": "LEO"
    },
    {
        "command": "/bill",
        "parameters": "Player ID | Amount | Reason",
        "example": "/bill 1 1000 Fleeing and Eluding",
        "alias": "",
        "description": "Issues a bill to the player indicated and adds amount to their state debt.",
        "category": "LEO"
    },
    {
        "command": "/arrest",
        "parameters": "Player ID | Time | Reason",
        "example": "/arrest 1 5 Fleeing and Eluding",
        "alias": "",
        "description": "Sends the player indicated to prison for the amount of time in minutes.",
        "category": "LEO"
    },
    {
        "command": "/coroner",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Sends out a local coroner squad to collect dead NPC bodies.",
        "category": "Emergency Services"
    },
    {
        "command": "/ambulance",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Sends out a local ambulance and medics to collect 'dead' NPC bodies.",
        "category": "Emergency Services"
    },
    {
        "command": "/localtow",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Sends out a local tow truck to collect the vehicle you are facing.",
        "category": "Emergency Services"
    },
    {
        "command": "/hospitallogs",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Contains a list of individuals who checked themselves in at hospitals.",
        "category": "SAFR"
    },
    {
        "command": "/paytow",
        "parameters": "Player ID",
        "example": "",
        "alias": "",
        "description": "Sends payment to the player ID if they are towing a vehicle.",
        "category": "Emergency Services"
    },
    {
        "command": "/priorequest",
        "parameters": "Message",
        "example": "",
        "alias": "",
        "description": "Sends out a priority assistance request to the combined ops discord.",
        "category": "Emergency Services"
    },
    {
        "command": "/judgerequest",
        "parameters": "Message",
        "example": "",
        "alias": "",
        "description": "Sends out a judge request to the combined ops discord.",
        "category": "LEO"
    },
    {
        "command": "/lawyerrequest",
        "parameters": "Message",
        "example": "",
        "alias": "",
        "description": "Sends out a lawyer request to the combined ops discord.",
        "category": "LEO"
    },
    {
        "command": "/rights",
        "parameters": "",
        "example": "[Rights] You have the right to remain silent...",
        "alias": "",
        "description": "Gives you the miranda rights in the chat box, both you and the people around you will see it.",
        "category": "LEO"
    },
    {
        "command": "/radar",
        "parameters": "Speed Limit",
        "example": "",
        "alias": "",
        "description": "Opens the Radar menu for your service vehicle. Add a number to change your speed limit.",
        "category": "LEO"
    },
    {
        "command": "/13",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Silent panic alarm for LEO/EMS, sends your current location. To be used both when you feel threatened or you are downed",
        "category": "Emergency Services"
    },
    {
        "command": "/putinbed",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Puts the downed individual you are dragging into a bed with no cost.",
        "category": "Emergency Services"
    },
    {
        "command": "/takefrombed",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Helps an individual off a hospital bed.",
        "category": "Emergency Services"
    },
    {
        "command": "/alert",
        "parameters": "Message",
        "example": "[Alert]: Pillbox Bank is currently closed due to an incident.",
        "alias": "",
        "description": "Sends an island-wide advisory to all players",
        "category": "Emergency Services"
    },
    {
        "command": "/killalarm",
        "parameters": "Alarm ID (do /killalarm without parameters to see IDs)",
        "example": "",
        "alias": "",
        "description": "Shuts off a alarm for a bank or jewelry store.",
        "category": "LEO"
    },
    {
        "command": "/breach",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Allows entry into the nearest house/warehouse thats being robbed.",
        "category": "Emergency Services"
    },
    {
        "command": "/identify",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Uses a fingerprint scanner on the nearest player and gets their SSN if they have been arrested before.",
        "category": "Emergency Services"
    },
    {
        "command": "/searchgarage",
        "parameters": "CharID",
        "example": "",
        "alias": "",
        "description": "Searches another character's valet.",
        "category": "LEO"
    },
    {
        "command": "/impound",
        "parameters": "2 (if bill is to be free)",
        "example": "",
        "alias": "",
        "description": "Marks the vehicle you are facing for impound. Enter a parameter to make the bill free to the RO.",
        "category": "LEO"
    },
    {
        "command": "/spotlight",
        "parameters": "left, right [optional]",
        "example": "/spotlight right",
        "alias": "/spotlight left or /spotlight right",
        "description": "Turns on your front spotlights or alley lights. Send the same command again without any parameters to turn off.",
        "category": "LEO"
    },
    {
        "command": "/engine",
        "parameters": "",
        "example": "",
        "alias": "Default keybind F6 and located in the Radial Menu",
        "description": "Toggles the engine on or off.",
        "category": "Vehicle"
    },
    {
        "command": "/givekeys",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Gives keys to the vehicle you own/rented to the passenger or closest player outside.",
        "category": "Vehicle"
    },
    {
        "command": "/sit",
        "parameters": "",
        "example": "",
        "alias": "Allows you to sit in the nearest chair if possible. (Not all chairs work.)",
        "description": "",
        "category": "General"
    },
    {
        "command": "/belt",
        "parameters": "",
        "example": "",
        "alias": "Default keybind F1 and located in the Radial Menu",
        "description": "",
        "category": "General"
    },
    {
        "command": "/local911",
        "parameters": "",
        "example": "",
        "alias": "Triggers a locally sent 911 call to LEO/EMS for assistance if you are downed.",
        "description": "",
        "category": "General"
    },
    {
        "command": "/scene",
        "parameters": "",
        "example": "",
        "alias": "Opens scene creation UI.",
        "description": "",
        "category": "General"
    },
    {
        "command": "/removescene",
        "parameters": "Scene ID",
        "example": "/removescene 130",
        "alias": "Removes a scene by its unique ID.",
        "description": "",
        "category": "General"
    },
    {
        "command": "/tablet",
        "parameters": "",
        "example": "",
        "alias": "Opens your tablet to access SoE Core if you have one.",
        "description": "",
        "category": "General"
    },
    {
        "command": "/ui",
        "parameters": "",
        "example": "",
        "alias": "Opens settings to allow configuration of various things in the server.",
        "description": "",
        "category": "General"
    },
    {
        "command": "/staff",
        "parameters": "",
        "example": "",
        "alias": "Shows a list of online staff and their server IDs on duty.",
        "description": "",
        "category": "General"
    },
    {
        "command": "/frisk",
        "parameters": "",
        "example": "",
        "alias": "Frisks the closest player's inventory for weapons.",
        "description": "",
        "category": "General"
    },
    {
        "command": "/search",
        "parameters": "",
        "example": "",
        "alias": "Searches the closest player's inventory.",
        "description": "",
        "category": "General"
    },
    {
        "command": "/inv",
        "parameters": "",
        "example": "",
        "alias": "Opens your inventory.",
        "description": "",
        "category": "General"
    },
    {
        "command": "/vsync",
        "parameters": "",
        "example": "",
        "alias": "Resyncs VOIP.",
        "description": "",
        "category": "General"
    },
    {
        "command": "/bikerentals",
        "parameters": "",
        "example": "",
        "alias": "Toggles bike rental places blips on the map.",
        "description": "",
        "category": "General"
    },
    {
        "command": "/sound",
        "parameters": "0.0 to 10.0",
        "example": "/sound 0.1",
        "alias": "",
        "description": "To lower sound volume such as alerts or tones",
        "category": "General"
    },
    {
        "command": "/heal",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Starts slowly healing the nearest player, as well as stop bleeding.",
        "category": "SAFR"
    },
    {
        "command": "/ems",
        "parameters": "Player ID",
        "example": "",
        "alias": "",
        "description": "Sends an enroute assurance message to the target.",
        "category": "SAFR"
    },
    {
        "command": "/evac",
        "parameters": "Player ID",
        "example": "",
        "alias": "",
        "description": "Sends the downed target to a hospital by MedEvac.",
        "category": "SAFR"
    },
    {
        "command": "/job",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Gets your current job/employment status.",
        "category": "General"
    },
    {
        "command": "/jobinfo",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Gets your current job/employment assignment.",
        "category": "General"
    },
    {
        "command": "/helicam",
        "parameters": "",
        "example": "",
        "alias": "E",
        "description": "Enables/disables helicam.",
        "category": "Aviation"
    },
    {
        "command": "/putintrunk",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Puts escorted/held/carried player into the nearest vehicle's trunk.",
        "category": "General"
    },
    {
        "command": "/getintrunk",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Gets inside the trunk of the nearest vehicle.",
        "category": "General"
    },
    {
        "command": "/bindemote",
        "parameters": "Bind Number, Emote",
        "example": "/bindemote 3 lean",
        "alias": "",
        "description": "Saves an emote to a keybind number.",
        "category": "General"
    },
    {
        "command": "/tattoo",
        "parameters": "Server ID (TTID)",
        "example": "/tattoo 20",
        "alias": "",
        "description": "Opens tattoo menu to customize the server ID's tattoos.",
        "category": "General"
    },
    {
        "command": "/killswitch",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Triggers the LAST killswitch you equipped in a vehicle.",
        "category": "General"
    },
    {
        "command": "/tow",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Places the vehicle you are facing on your flatbed.",
        "category": "General"
    },
    {
        "command": "/cleartowcalls",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Clears all pending tow calls on your end.",
        "category": "General"
    },
    {
        "command": "/neons",
        "parameters": "on, off, sequence, flash, controller",
        "example": "/neons on",
        "alias": "",
        "description": "",
        "category": "Vehicle"
    },
    {
        "command": "/neons color",
        "parameters": "/neons color 0-255 0-255 0-255",
        "example": "/neons color 255 0 255",
        "alias": "",
        "description": "You use the RGB code of the colour you want.",
        "category": "Vehicle"
    },
    {
        "command": "/unload",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Clears all ammo in your current firearm.",
        "category": "General"
    },
    {
        "command": "/closet",
        "parameters": "",
        "example": "",
        "alias": "",
        "description": "Accesses a clothing menu when inside a property.",
        "category": "General"
    },
]
