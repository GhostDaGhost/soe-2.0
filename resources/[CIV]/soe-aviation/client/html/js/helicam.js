const speedConversion = 2.236936 // MPH

// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let data = event.data
    switch(data.type) {
        case 'Helicam.ToggleUI':
            ToggleHelicam(data.show);
            break;
        case 'Helicam.PopulateUI':
            DisplayHelicamInfo(data.vehData);
            break;
        case 'Helicam.ResetUI':
            $('#helicam_container').fadeOut();
            console.log('[Helicam] UI resetted.');
            break;
    }
});

// WHEN TRIGGERED, TOGGLE HELICAM UI
function ToggleHelicam(showHelicam) {
    if (showHelicam) {
        $("#helicam_container").fadeIn(350);
    } else {
        $("#helicam_container").fadeOut();
    }
}

// WHEN TRIGGERED, UPDATE TARGET INFO
function DisplayHelicamInfo(vehicleData) {
    let speed = vehicleData.speed;
    if (speed == undefined) {
        speed = 0;
    }

    let model = vehicleData.model;
    if (model == undefined) {
        model = 'Unknown';
    }

    let plate = vehicleData.plate;
    if (plate == undefined) {
        plate = 'Unknown';
    }

    let hdg = vehicleData.hdg;
    if (hdg == undefined) {
        hdg = 'North';
    }

    let street = vehicleData.street;
    if (street == undefined) {
        street = 'Unknown';
    }

    speed = (Number(speed) * speedConversion).toFixed(0);
    $("#helicam_container").html(
        `Speed: <span style='color:#22a0c7;'>${speed}</span>
        Model: <span style='color:#22a0c7;'>${model}</span>
        Plate: <span style='color:#22a0c7;'>${plate}</span>
        Street: <span style='color:#22a0c7;'>${hdg} on ${street}</span>`
    );
}
