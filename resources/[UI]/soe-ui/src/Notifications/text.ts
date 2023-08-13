// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let data = event.data
    switch(data.type) {
        case "Notif.DisplayOnscreenText":
            DoOnscreenText(data.text);
            break;
        case "Notif.RemoveOnscreenText":
            $('#onscreen_text').fadeOut();
            break;
    }
})

// WHEN TRIGGERED, CREATE AN ONSCREEN TEXT
function DoOnscreenText(screenText: string) {
    $('#onscreen_text').fadeIn(450);
    $('#onscreen_text').html(screenText);
}
