// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let type = event.data.type
    switch(type) {
        case "UI.Reset":
            ResetUI();
            break;
    }
})

// WHEN TRIGGERED, RESET ALL UI IN CASE OF MALFUNCTION
function ResetUI() {
    // RESET TABLET
    $("#tablet_container").animate({bottom: "-100%"}, 250, () => {
        $("#tablet_container").css("display", "none");
    })

    // RESET MYTHIC NOTIFICATIONS LOG
    $('#notification-logs').fadeOut();

    // RESET TOOL TIP
    $(".tooltip_container").animate({right: "-20%"}, 300, () => {
        $(".tooltip_container").css("display", "none");
    })

    // RESET ONSCREEN TEXT
    $('#onscreen_text').fadeOut();

    // RESET PLAYER COUNTER
    $('#counter_container').fadeOut();

    // CLOSE SETTINGS
    $('#settings_container').fadeOut();

    // RESET FOOD MENUs
    $('#foodmenu_container').animate({top: "-105%"}, 250, () => {
        $('#foodmenu_container').css("display", "none");
        $('#foodmenu_container').empty();
    })
}
