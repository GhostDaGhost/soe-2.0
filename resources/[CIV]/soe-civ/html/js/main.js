// NUI EVENT LISTENER
window.onload = function() {
    window.addEventListener("message", function (event) {
        switch(event.data.type) {
            case "setScubaStatus":
                SetScubaStatus(event.data);
                break;
            case "toggleScubaUI":
                ToggleScubaUI(event.data);
                break;
        }
    });
}

// UPDATES SCUBA GEAR STATUS
function SetScubaStatus(data) {
    $("#full_scubagear").css("clip-path", "polygon(0 " + data.percent + "%, 100% "+ data.percent +"%, 100% 100%, 0% 100%)");
}

// TOGGLES SCUBA GEAR AMOUNT VISIBILITY
function ToggleScubaUI(data) {
    if (data.bool) {
        $("#full_scubagear").css("opacity", 1.0);
        $("#empty_scubagear").css("opacity", 0.5);
    }
    else {
        $("#full_scubagear").css("opacity", 0.0);
        $("#empty_scubagear").css("opacity", 0.0);
    }
}
