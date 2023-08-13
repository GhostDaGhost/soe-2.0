// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let data = event.data
    switch(data.type) {
        case 'Notif.ShowTooltip':
            ShowTooltip(data.icon, data.text, data.color);
            break;
        case 'Notif.HideTooltip':
            HideTooltip();
            break;
    }
})

function HideTooltip() {
    $(".tooltip_container").animate({right: "-20%"}, 300, () => {
        $(".tooltip_container").css("display", "none");
    })
}

function ShowTooltip(tipIcon: string, tipText: string, tipColor: string) {
    let _tipText = tipText;
    if (_tipText == undefined) {
        _tipText = '[E] Interact';
    }

    let _tipIcon = tipIcon;
    if (_tipIcon == undefined) {
        _tipIcon = 'fas fa-globe';
    }

    let _tipColor = tipColor;
    if (_tipColor == undefined) {
        _tipColor = 'inform';
    }

    let tipColor_rgba = 'rgba(51, 112, 165, 0.85)';
    if (_tipColor == 'error') {
        tipColor_rgba = 'rgba(167, 6, 11, 0.75)';
    } else if (_tipColor == 'success') {
        tipColor_rgba = 'rgba(21, 100, 15, 0.95)';
    }

    $('.tooltip_container').css('background-color', tipColor_rgba);
    $('#tooltip_text').html(`<i id='tooltip_icon' class='${_tipIcon}'></i> &nbsp;&nbsp;| &nbsp;${_tipText}`);

    $(".tooltip_container").css("display", "flex");
    $(".tooltip_container").animate({right: "1%"}, 650, () => {})
}
