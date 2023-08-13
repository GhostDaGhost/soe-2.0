let myVoiceRange: number = 2;
let isBroadcasting: any = false;

// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let data = event.data
    switch(data.type) {
        case "Status.UpdateVoice":
            UpdateMyVoice(data);
            break;
        case "Status.UpdateVOIPRange":
            SetVoiceRangeState(data.range);
            break;
        case "Status.SetTransmittingState":
            SetTransmittingState(data.isTransmitting, data.channelType);
            break;
        case "Status.PopulateUI":
            UpdateMyStatusCircles(data);
            break;
        case "Status.Display":
            ToggleStatusCircles(data.show);
            break;
        case 'UI.RoundmapBorder':
            ToggleRoundmapBorder(data.show, data.moreThick);
            break;
    }
})

// WHEN TRIGGERED, TOGGLES THE CIRCLE STATUS UI VISIBILITY
function ToggleStatusCircles(showCircles: boolean) {
    if (showCircles) {
        $("#status_circles-container").fadeIn();
    } else {
        $("#status_circles-container").fadeOut();
    }
};

// UPDATES THE VOIP STATUS CIRCLE BY RADIO
function SetTransmittingState(isTransmitting: boolean, channelType: any) {
    // IF PLAYER IS BROADCASTING ON THE RADIO, SET OUR STATE
    if (isTransmitting) {
        $('#voice i').removeClass('fas fa-microphone').addClass('fas fa-headset');
        isBroadcasting = channelType;
    } else {
        isBroadcasting = false;
        $('#voice i').removeClass('fas fa-headset').addClass('fas fa-microphone');
    }
}

// WHEN TRIGGERED, TOGGLES ROUND MINIMAP BORDER VISIBILITY
function ToggleRoundmapBorder(showBorder: boolean, moreThick: boolean) {
    if (showBorder) {
        $("#roundminimap_border").fadeIn();
        if (moreThick) {
            //$("#roundminimap_border").css('border', '0.3vh solid #a0a0a0');
            document.getElementById('roundminimap_border').style.border = '0.3vh solid #a0a0a0';
        } else {
            //$("#roundminimap_border").css('border', '0.15vh solid #a0a0a0');
            document.getElementById('roundminimap_border').style.border = '0.15vh solid #a0a0a0';
        }
    } else {
        $("#roundminimap_border").fadeOut();
    }
}

// UPDATES THE VOIP STATUS CIRCLE BY RANGE
function SetVoiceRangeState(range: number) {
    myVoiceRange = range;

    // UPDATE CIRCLE HEIGHT DEPENDING ON VOICE RANGE
    if (myVoiceRange == 1) {
        $("#voice span").css("height", "25%")
    } else if (myVoiceRange == 2) {
        $("#voice span").css("height", "50%")
    } else if (myVoiceRange == 3) {
        $("#voice span").css("height", "100%")
    }
}

// UPDATES THE VOIP STATUS CIRCLE
function UpdateMyVoice(data: any) {
    // IF PLAYER IS BROADCASTING ON THE RADIO, LIGHT THE CIRCLE UP AS PURPLE
    if (isBroadcasting == "Secondary" || isBroadcasting == "Primary") {
        if (data.isTalking) {
            if (isBroadcasting == "Secondary") {
                $("#voice span").css("background", "#718000")
            } else {
                $("#voice span").css("background", "#55247ca2")
            }
        } else {
            $("#voice span").css("background", "#747474")
        }
    } else {
        // IF PLAYER IS TALKING NORMALLY, LIGHT THE CIRCLE UP AS RED
        if (data.isTalking) {
            $("#voice span").css("background", "#c72b2b98")
        } else {
            $("#voice span").css("background", "#747474")
        }
    }
}

// WHEN TRIGGERED, UPDATES THE CIRCLE STATUS UI
function UpdateMyStatusCircles(data: any) {
    for (let i: number = 0; i < data.status.length; i++) {
        let statusName = data.status[i].name;
        let value = Math.floor(data.status[i].value);

        // COLOR HEALTH CIRCLE AS RED WHEN TOO LOW
        if (statusName == "health") {
            if (value <= 45) {
                $("#health span").css("background", "#8a0000")
                if (document.querySelector(`#${statusName}`).classList.contains("dying") == false) {
                    document.querySelector(`#${statusName}`).classList.add("dying");	
                }
            } else {
                $("#health span").css("background", "#48aa38")
                if (document.querySelector(`#${statusName}`)) {
                    document.querySelector(`#${statusName}`).classList.remove("dying");
                }
            }
        } 

        // UPDATE STATUS VALUES AS USUAL
        $(`#${statusName} span`).css("width", "105%")
        $(`#${statusName} span`).css("height", value + "%")
    }
};
