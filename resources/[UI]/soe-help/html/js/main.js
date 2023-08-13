// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let type = event.data.type
    switch(type) {
        case 'Help.Open':
            $("#help").fadeIn(550);
            break;
        case 'Help.ResetUI':
            CloseHelpUI();
            console.log('[Help] UI resetted.');
            break;
        default:
            console.log("Invalid type passed to NUI (" + type + ")");
            break;
    }
});

// WHEN TRIGGERED, CLOSE HELP UI
function CloseHelpUI() {
    $("#help").fadeOut(350);
    $.post("https://soe-help/Help.CloseUI", JSON.stringify({}));
}

// GENERAL INTERACTION FUNCTION
$(() => {
    // CLOSES UI WHEN 'ESCAPE' IS PRESSED
    $(document).on("keydown", (event) => {
        switch(event.key) {
            case "Escape":
                CloseHelpUI()
                break;
        }
    });
})
