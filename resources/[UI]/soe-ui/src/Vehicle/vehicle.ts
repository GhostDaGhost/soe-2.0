let vehicleType = "car";

// NUI EVENT LISTENER
window.addEventListener("message", (event) => {
    let data = event.data
    switch(data.type) {
        case "Vehicle.PopulateUI.Street":
            UpdateMyGPS(data);
            break;
        case "Vehicle.PopulateUI.Fuel":
            UpdateFuel(data.fuel);
            break;
        case "Vehicle.PopulateUI.Speed":
            UpdateSpeed(data.speed, data.altitude);
            break;
        case "Vehicle.PopulateUI.Time":
            $(".time-text").html(data.time);
            break;
        case "Vehicle.PopulateUI.Engine":
            UpdateEngineState(data.show);
            break;
        case "Vehicle.SetType":
            SetVehicleType(data);
            break;
        case "Vehicle.PopulateUI.Belt":
            ToggleSeatbelt(data.seatbelt);
            break;
        case "Vehicle.PopulateUI.Locks":
            ToggleVehLocks(data.locks);
            break;
        case "Vehicle.UpdateUI":
            UpdateVehicleHud(data);
            break;
        case "Vehicle.DisplayUI":
            DisplayVehicleHud(data.show);
            break;
    }
})

// VEHICLE LOCKS INDICATOR TOGGLE
function ToggleVehLocks(locks: boolean) {
    if (locks) {
        $(".car-locks").fadeOut(400);
    } else {
        $(".car-locks").fadeIn(400);
    }
}

// SEATBELT INDICATOR TOGGLE
function ToggleSeatbelt(seatbelt: boolean) {
    if (seatbelt) {
        $(".car-seatbelt").fadeOut(1000);
    } else {
        $(".car-seatbelt").fadeIn(1000);
    }
}

// CARHUD DISPLAY TOGGLE
function DisplayVehicleHud(show: boolean) {
    if (show) {
        $(".carhud-container").fadeIn();
        $(".car-seatbelt").fadeIn();
    } else {
        $(".car-locks").fadeOut();
        $(".carhud-container").fadeOut();
        $(".car-seatbelt").fadeOut();
    }
}

// SET VEHICLE TYPE
function SetVehicleType(type: any) {
    vehicleType = "car"
    if (type.isAircraft) {
        vehicleType = "aircraft"
    } else if (type.isBoat) {
        vehicleType = "boat"
    } else if (type.isBMX) {
        vehicleType = "bmx"
    }
}

function UpdateSpeed(speed: number, altitude: number) {
    if (vehicleType == "aircraft") {
        $(".speed-text").html((altitude).toFixed(0));
    } else {
        $(".speed-text").html((speed).toFixed(0));
    }
    $(".aircraft-speed-text").html((speed).toFixed(0));
}

// CARHUD DISPLAY TOGGLE
function UpdateEngineState(show: boolean) {
    if (show) {
        $(".car-engine").fadeIn(400);
    } else {
        $(".car-engine").fadeOut(400);
    }
}

function UpdateFuel(fuel: number) {
    // FUEL WARNING COLORS
    var curFuel = Number((fuel).toFixed(0));
    if (curFuel < 15) {
        $(".fuel-text").css("color", "#ff0000")
    } else {
        $(".fuel-text").css("color", "#ffffff")
    }
    $(".fuel-text").html(String(curFuel));
}

// UPDATES THE GPS LOCATION - TO BE CLEANED SOON
function UpdateMyGPS(data: any) {
    // IF THE GPS IS SET TO THE TOP
    if (data.streetOnTop) {
        // SHOW THE GPS IN THE TOP
        $(".car-street").fadeOut(750);
        $(".car-streetOnTop").fadeIn(750);
        $(".car-streetOnTop").html(data.direction + " on " + data.location);
    } else {
        // SHOW THE GPS IN THE BOTTOM LEFT
        $(".car-street").fadeIn(750);
        $(".car-streetOnTop").fadeOut(750);
        $(".car-street").html(data.direction + " on " + data.location);
    }
}

// MAIN VEHICLE HUD FUNCTION
function UpdateVehicleHud(data: any) {
    // SHOW THE HUD DEPENDING ON THE HUD STATUS
    $(".carhud-container").css("display", data.show ? "none" : "block");

    // VEHICLE TYPE CHECKS
    if (vehicleType == "bmx") {
        // BMX DOESN'T HAVE FUEL
        $(".fuel-text").fadeOut();
        $(".fuel-label").fadeOut();

        // BMX DOESN'T HAVE A CLOCK
        $(".time-text").fadeOut();
            
        // BMX DOESN'T HAVE ENGINES OR SEATBELTS
        $(".car-engine").fadeOut();
        $(".car-seatbelt").fadeOut();

        // MOVE LOCKS INDICATOR AROUND A BIT
        $(".car-locks").css("left", "17.3vw")
        $(".car-locks").css("bottom", "5.6vh")
    } else {
        // RESET LOCKS/ENGINE INDICATOR LOCATION
        $(".car-engine").css("left", "30vw")
        $(".car-locks").css("left", "27.5vw")
        $(".car-locks").css("bottom", "3.2vh")

        $(".time-text").fadeIn();
        $(".fuel-text").fadeIn();
        $(".fuel-label").fadeIn();
    }

    // IF THE VEHICLE IS AN AIRCRAFT, USE MSL ALTITUDE INSTEAD OF MPH
    if (vehicleType == "aircraft") {
        $(".speed-type").html("FT");
        // SHOW AND POPULATE THE AIRCRAFT SPEED
        $(".aircraft-speed-text").fadeIn();
        $(".aircraft-speed-label").fadeIn();
        $(".aircraft-speed-label").html("KNTS");
    } else if (vehicleType == "boat") {
        // IF THE VEHICLE IS A BOAT, USE KNOTS INSTEAD OF MPH
        $(".speed-type").html("KNTS");
        // HIDE THE AIRCRAFT SPEED
        $(".aircraft-speed-text").fadeOut();
        $(".aircraft-speed-label").fadeOut();
    } else {
        // IF THE VEHICLE IS A CAR, USE MPH
        $(".speed-type").html("MPH");
        // HIDE THE AIRCRAFT SPEED
        $(".aircraft-speed-text").fadeOut();
        $(".aircraft-speed-label").fadeOut();
    }
}
