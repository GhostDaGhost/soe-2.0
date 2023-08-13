// NUI EVENT LISTENER
window.onload = () => {
    window.addEventListener('message', (event) => {
        let data = event.data
        switch(data.type) {
            case "DoHeadbag":
                ToggleHeadbag(data.show);
                break;
            default:
                console.log("Invalid type passed to NUI (" + data.type + ")");
                break;
        }
    });
}

// TOGGLES HEADBAG STATUS
function ToggleHeadbag(show) {
    if (show) {
        $('.headbag-container').fadeIn(500);
    } else {
        $('.headbag-container').fadeOut(500);
    }
}
