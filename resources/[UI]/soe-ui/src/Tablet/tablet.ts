// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let type = event.data.type
    switch(type) {
        case "Tablet.ShowUI":
            ShowTabletUI();
            break;
    }
})

// DISPLAYS TABLET UI
function ShowTabletUI() {
    $("#tablet_container").css("display", "block");
    $("#tablet_container").animate({bottom: "40%"}, 650, () => {})
}

// CLOSES TABLET UI
function CloseTabletUI() {
    $.post("https://soe-ui/Tablet.CloseUI", JSON.stringify({}));
    $("#tablet_container").animate({bottom: "-100%"}, 250, () => {
        $("#tablet_container").css("display", "none");
    })
}

// GENERAL INTERACTION FUNCTION
$(() => {
    // CLOSES UI WHEN 'ESCAPE' IS PRESSED
    $(document).on('keydown', (event) => {
        switch(event.key) {
            case 'Escape':
                CloseTabletUI()
                break;
        }
    });
})
