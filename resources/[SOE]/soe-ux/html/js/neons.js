// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let data = event.data
    switch(data.type) {
        case 'OpenNeonUnderglowController':
            OpenNeonUnderglowController();
            break;
    }
})

// WHEN TRIGGERED, SHOW NEON UNDERGLOW CONTROLLER
function OpenNeonUnderglowController() {
    $("#neoncontroller_container").fadeIn(300);
}

// WHEN TRIGGERED, HIDE NEON UNDERGLOW CONTROLLER
function CloseNeonUnderglowController() {
    $.post("https://soe-ux/NeonController.CloseUI", JSON.stringify({}));
    $("#neoncontroller_container").fadeOut(250);
}

// WHEN TRIGGERED, TURN NEONS ON AND SEND TO LUA
function NeonOnButtonClicked() {
    $.post("https://soe-ux/NeonController.PushEvent", JSON.stringify({
        type: "On"
    }));
}

// WHEN TRIGGERED, TURN NEONS OFF AND SEND TO LUA
function NeonOffButtonClicked() {
    $.post("https://soe-ux/NeonController.PushEvent", JSON.stringify({
        type: "Off"
    }));
}

// WHEN TRIGGERED, TOGGLE NEON FLASH AND SEND TO LUA
function NeonFlashButtonClicked() {
    $.post("https://soe-ux/NeonController.PushEvent", JSON.stringify({
        type: "Flash"
    }));
}

// WHEN TRIGGERED, TOGGLE NEON SEQUENCE AND SEND TO LUA
function NeonSequenceButtonClicked() {
    $.post("https://soe-ux/NeonController.PushEvent", JSON.stringify({
        type: "Sequence"
    }));
}

// WHEN TRIGGERED, SAVE RGB VALUES AND SEND TO LUA
function NeonSaveButtonClicked() {
    let $red = $('#neoncontroller_red_input').val();
    if ($red == '') {
        return;
    }

    let $green = $('#neoncontroller_green_input').val();
    if ($green == '') {
        return;
    }

    let $blue = $('#neoncontroller_blue_input').val();
    if ($blue == '') {
        return;
    }

    $.post("https://soe-ux/NeonController.PushEvent", JSON.stringify({
        type: "RGB Setting",
        red: $red,
        green: $green,
        blue: $blue
    }));
}

// GENERAL INTERACTION FUNCTION
$(() => {
    // CLOSES NEON CONTROLLER WHEN 'ESCAPE' OR 'TAB' IS PRESSED
    $(document).on("keydown", (event) => {
        switch(event.key) {
            case "Escape":
                CloseNeonUnderglowController()
                break;
            case "Tab":
                CloseNeonUnderglowController()
                break;
        }
    });
})
