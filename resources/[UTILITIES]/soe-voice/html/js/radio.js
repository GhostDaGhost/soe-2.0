var radioOn = false;
const $radio = $('#radio_container');
const $radioListElem = $('#voice_radiolist');
//const $radioFXSettingsUI = $('#radiofx_container');

const onClicks = 5; // CHANGE THIS BY HOWEVER MANY ON CLICKS YOU ADD
const offClicks = 7; // CHANGE THIS BY HOWEVER MANY OFF CLICKS YOU ADD

// WHEN JAVASCRIPT STARTS UP
window.onload = () => {
    // LOAD UP MIC CLICKS
    LoadMicClicks();

    // NUI EVENT LISTENER
    window.addEventListener("message", (event) => {
        let data = event.data
        switch(data.type) {
            case "openRadio":
                OpenRadio(data.channel);
                break;
            case "playMicClick":
                PlayMicClick(data);
                break;
            case 'Radio.ResetUI':
                CloseRadio();
                console.log('[Radio] UI resetted.');
                break;
            case 'Radio.ClearList':
                ClearDispatchList();
                break;
            case 'Radio.ModifyList':
                ModifyDispatchList(data);
                break;
            case 'Radio.ToggleList':
                ToggleDispatchList(data.show);
                break;
            /*case "openRadioFXConfig":
                RadioFXConfig();
                break;*/
            default:
                console.log("Invalid type passed to NUI (" + data.type + ")");
                break;
        }
    });
}

// WHEN TRIGGERED, CLEAR THE RADIO DISPATCH LIST
function ClearDispatchList() {
    $radioListElem.empty();
}

// PLAYS MIC CLICK FOR RADIO
function PlayMicClick(data) {
    if (data.sound && data.volume) {
        let sound = document.getElementById(data.sound);
        sound.load();
        sound.volume = data.volume;
        sound.play();
    }
}

// CLOSES RADIO AND CALLS TO LUA TO SHUT OFF NUI FOCUS
function CloseRadio() {
    $('#radio_info').remove()
    $.post("https://soe-voice/Radio.CloseUI", JSON.stringify({}));

    $radio.animate({bottom: "-80%"}, 250, () => {
        $radio.css("display", "none");
    })
}

// WHEN TRIGGERED, LOAD UP MIC CLICKS
function LoadMicClicks() {
    for (let onClick = 1; onClick < onClicks + 1; onClick++) {
        $('body').append(`<audio id="audio_on${onClick}" src="ogg/mic_click_on${onClick}.ogg"></audio>`);
    }

    for (let offClick = 1; offClick < offClicks + 1; offClick++) {
        $('body').append(`<audio id="audio_off${offClick}" src="ogg/mic_click_off${offClick}.ogg"></audio>`);
    }
    console.log('[UI] Mic Clicks loaded.');
}

// WHEN TRIGGERED, TOGGLE THE LIST
function ToggleDispatchList(showList) {
    if (showList) {
        $('#radiolist_container').css("display", "block");
        $('#radiolist_container').animate({right: "1%"}, 850, () => {})
    } else {
        $('#radiolist_container').animate({right: "-50%"}, 250, () => {
            $('#radiolist_container').css("display", "none");
        })
    }
}

// WHEN TRIGGERED, MODIFY THE RADIO DISPATCH LIST
function ModifyDispatchList(listData) {
    if (listData.frequency != null) {
        $('#radiolist_header').html(`Radio Frequency - ${listData.frequency}`);
    }

    if (listData.remove != null) {
        $('#voice_radiolist-item-' + listData.memberID).remove();
    }

    if (listData.memberName != null) {
        let divID = "voice_radiolist-item-" + listData.memberID;
        let divContent = (listData.self ? "\uD83D\uDD38" : "\uD83D\uDD39") + listData.memberName;

        $radioListElem.append(`<div id=${divID}>${divContent}</div>`);
    }

    if (listData.isTalking != null) {
        let divID = "voice_radiolist-item-" + listData.memberID;
        if (listData.isTalking) {
            $(`#${divID}`).addClass('talking');
        } else {
            $(`#${divID}`).removeClass('talking');
        }
    }
}

// WHEN TRIGGERED, CREATE A RADIO HINT
function CreateToolTip(name, width, height, bottom, right) {
    let $hint = $(document.createElement('p'))

    $hint.html(name)
    $hint.attr('id', 'radio_info')

    $hint.css('right', right)
    $hint.css('bottom', bottom)
    $hint.css('width', width)
    $hint.css('height', height)

    $('body').append($hint)
}

// WHEN TRIGGERED, OPEN RADIOFX SETTINGS UI
/*function RadioFXConfig() {
    $radioFXSettingsUI.fadeIn(300);
}

// WHEN TRIGGERED, HIDE RADIOFX SETTINGS UI
function CloseRadioFXConfig() {
    $.post("https://soe-voice/RadioFX.CloseUI", JSON.stringify({}));
    $radioFXSettingsUI.fadeOut(250);
}

// WHEN TRIGGERED, SAVE ALL RADIOFX SETTINGS
function SaveButtonClicked() {
    let $lowFreq = $('#radiofx_input_lowfreq').val();
    let $highFreq = $('#radiofx_input_highfreq').val();
    let $fudge = $('#radiofx_input_fudge').val();

    $.post("https://soe-voice/RadioFX.SaveSettings", JSON.stringify({
        lowFreq: $lowFreq,
        highFreq: $highFreq,
        fudge: $fudge,
    }));
}*/

// OPENS RADIO AFTER LUA TRIGGER
function OpenRadio(channel) {
    let $input = $("#radio_channel-input");
    $input.val("");

    if (!radioOn) {
        $input.attr("placeholder", "Off");
        $input.attr('readonly', true);
    } else {
        $input.attr('readonly', false);
        if (channel > 0) {
            $input.val(channel)
        } else {
            $input.attr("placeholder", "1-1000");
        }
    }

    $radio.css("display", "block");
    $radio.animate({bottom: "4%"}, 650, () => {
        $input.focus()
    })
}

// GENERAL INTERACTION FUNCTION
$(() => {
    // CLOSES RADIO WHEN 'ESCAPE' IS PRESSED
    $(document).on("keydown", (event) => {
        switch(event.key) {
            case "Escape":
                CloseRadio()
                //CloseRadioFXConfig()
                break;
        }
    });

    // SHOW POWER TOGGLE HINT WHEN CLOSE ENOUGH
    $('#radio_power').mouseenter(() => {
        CreateToolTip('Power', '2.6vw', '2.1vh', '55%', '5.5%');
    }).mouseleave(() => {
        $('#radio_info').remove()
    })

    // SHOW VOLUME SWITCHER HINT WHEN CLOSE ENOUGH
    $('#radio_volume').mouseenter(() => {
        CreateToolTip('+/- Volume', '2.8vw', '3.2vh', '48.2%', '8.4%');
    }).mouseleave(() => {
        $('#radio_info').remove()
    })

    // SHOW MIC CLICK VOLUME SWITCHER HINT WHEN CLOSE ENOUGH
    $('#radio_clicksvolume').mouseenter(() => {
        CreateToolTip('+/- Clicks Volume', '2.9vw', '4.75vh', '31.5%', '15.3%');
    }).mouseleave(() => {
        $('#radio_info').remove()
    })

    // SHOW MIC CLICK TOGGLE HINT WHEN CLOSE ENOUGH
    $('#radio_micclicks').mouseenter(() => {
        CreateToolTip('Mic Clicks', '2.8vw', '3.2vh', '45.7%', '11.1%');
    }).mouseleave(() => {
        $('#radio_info').remove()
    })

    // SHOW ON CLICK VARIANT SELECTOR HINT
    $('#radio_micclicks_onvariant').mouseenter(() => {
        CreateToolTip('On Click Variant Switch', '2.9vw', '6.3vh', '17.1%', '15.3%');
    }).mouseleave(() => {
        $('#radio_info').remove()
    })

    // SHOW OFF CLICK VARIANT SELECTOR HINT
    $('#radio_micclicks_offvariant').mouseenter(() => {
        CreateToolTip('Off Click Variant Switch', '2.9vw', '6.3vh', '17.1%', '2.1%');
    }).mouseleave(() => {
        $('#radio_info').remove()
    })

    // SHOW SUBMIX TOGGLE HINT WHEN CLOSE ENOUGH
    $('#radio_submix').mouseenter(() => {
        CreateToolTip('Submix', '2.9vw', '2vh', '9.5%', '2.1%');
    }).mouseleave(() => {
        $('#radio_info').remove()
    })

    // TOGGLE MIC CLICKS WHEN CLICKED
    $('#radio_micclicks').click(() => {
        $.post("https://soe-voice/Radio.ToggleMicClicks", JSON.stringify({}));
    })

    // TOGGLE SUBMIX WHEN CLICKED
    $('#radio_submix').click(() => {
        $.post("https://soe-voice/Radio.ToggleSubmix", JSON.stringify({}));
    })

    // TOGGLE RADIO POWER WHEN CLICKED
    $('#radio_power').click(() => {
        let $input = $("#radio_channel-input")
        if (!radioOn) {
            radioOn = true
            $input.attr("placeholder", "1-1000");
            $input.attr('readonly', false);
        } else {
            radioOn = false
            $input.val("")
            $input.attr("placeholder", "Off");
            $input.attr('readonly', true);
        }

        $.post("https://soe-voice/Radio.TogglePower", JSON.stringify({
            power: radioOn
        }));
    })

    $('#radio_volume').mousedown((event) => {
        switch(event.which) {
            case 1:
                $.post("https://soe-voice/Radio.ModifyVolume", JSON.stringify({
                    state: "increase"
                }));
                break;
            case 2:
                $.post("https://soe-voice/Radio.ModifyVolume", JSON.stringify({
                    state: "reset"
                }));
                break;
            case 3:
                $.post("https://soe-voice/Radio.ModifyVolume", JSON.stringify({
                    state: "decrease"
                }));
                break;
        }
    })

    $('#radio_clicksvolume').mousedown((event) => {
        switch(event.which) {
            case 1:
                $.post("https://soe-voice/Radio.ModifyClickVolume", JSON.stringify({
                    state: "increase"
                }));
                break;
            case 2:
                $.post("https://soe-voice/Radio.ModifyClickVolume", JSON.stringify({
                    state: "reset"
                }));
                break;
            case 3:
                $.post("https://soe-voice/Radio.ModifyClickVolume", JSON.stringify({
                    state: "decrease"
                }));
                break;
        }
    })

    // CHANGE ON VARIANT OF MIC CLICKS
    $("#radio_micclicks_onvariant").mousedown((event) => {
        switch(event.which) {
            case 1:
                $.post("https://soe-voice/Radio.ChangeClickVariant", JSON.stringify({
                    type: "On",
                    channelType: "Primary"
                }));
                break;
            case 3:
                $.post("https://soe-voice/Radio.ChangeClickVariant", JSON.stringify({
                    type: "On",
                    channelType: "Secondary"
                }));
                break;
        }
    })

    // CHANGE OFF VARIANT OF MIC CLICKS
    $("#radio_micclicks_offvariant").mousedown((event) => {
        switch(event.which) {
            case 1:
                $.post("https://soe-voice/Radio.ChangeClickVariant", JSON.stringify({
                    type: "Off",
                    channelType: "Primary"
                }));
                break;
            case 3:
                $.post("https://soe-voice/Radio.ChangeClickVariant", JSON.stringify({
                    type: "Off",
                    channelType: "Secondary"
                }));
                break;
        }
    })

    // SETS RADIO CHANNEL WHENEVER 'ENTER' OR 'TAB' IS SELECTED
    $('#radio_channel-input').on('keydown', function(event) {
        let $inputtedChannel = Number($(this).val());
        switch(event.key) {
            case "Enter": // PRIMARY RADIO SETTING
                $.post("https://soe-voice/Radio.SetChannel", JSON.stringify({
                    channel: ($inputtedChannel).toFixed(2),
                    powered: radioOn,
                    type: "Primary"
                }));
                break;
            case "Tab": // SECONDARY RADIO SETTING
                $.post("https://soe-voice/Radio.SetChannel", JSON.stringify({
                    channel: ($inputtedChannel).toFixed(2),
                    powered: radioOn,
                    type: "Secondary"
                }));
                break;
        }
    });
})
