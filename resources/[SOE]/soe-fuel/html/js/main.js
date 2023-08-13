// NUI EVENT LISTENER
window.onload = function() {
    window.addEventListener("message", (event) => {
        switch(event.data.type) {
            case "toggleFuelUI":
                ToggleFuelUI(event.data.show);
                break;
            case "updateFuelUI":
                UpdateFuelUI(event.data);
                break;
        }
    });
}

// UPDATES UI CONTENTS WITHIN LUA LOOP
function UpdateFuelUI(data) {
    $(".fuel_activeprice").html(data.price);
    $(".fuel_activepercent").html(data.progress);
}

// TOGGLES UI VISIBILITY
function ToggleFuelUI(toShow) {
    if (toShow) {
        $("#fuel_container").css("display", "flex");
        $("#fuel_container").animate({right: "1%"}, 950, () => {})
    } else {
        $("#fuel_container").animate({right: "-50%"}, 350, () => {
            $("#fuel_container").css("display", "none");
        })
    }
}
