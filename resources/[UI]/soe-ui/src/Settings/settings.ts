import { LoadLicensePreferences } from "../License/license";

let currentMenu = 'General';
let currentBlackboxSize = 12;
const $settingsContent = $('#settings_content');

// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let data = event.data
    switch(data.type) {
        case 'Settings.OpenUI':
            OpenSettingsUI();
            break;
        case 'Settings.ToggleBlackboxes':
            ToggleBlackboxes(data.show);
            break;
    }
})

// WHEN TRIGGERED, OPEN SETTINGS UI
function OpenSettingsUI() {
    OpenGeneralSubmenu();
    $('#settings_container').fadeIn(200);
}

// WHEN TRIGGERED, CLOSE SETTINGS UI
function CloseSettingsUI() {
    $('#settings_container').fadeOut();
    $.post("https://soe-ui/Settings.CloseUI", JSON.stringify({}));
}

// WHEN TRIGGERED, TOGGLE BLACKBOXES
function ToggleBlackboxes(showBoxes: boolean) {
    if (showBoxes) {
        $('#blackboxes_container').css('display', 'block');
    } else {
        $('#blackboxes_container').css('display', 'none');
    }
}

// WHEN TRIGGERED, CHANGE BLACKBOX HEIGHT
function ChangeBlackboxHeight(newBoxSize: string) {
    currentBlackboxSize = Number(newBoxSize);

    $('#blackboxes_box1').css('height', `${newBoxSize}vh`);
    $('#blackboxes_box2').css('height', `${newBoxSize}vh`);
}

// WHEN TRIGGERED, SHOW GENERAL SUBMENU
function OpenGeneralSubmenu() {
    currentMenu = 'General';
    $settingsContent.html('');

    // GET AND SET DEFAULT SETTINGS
    $.post('https://soe-ui/Settings.GetSettings', JSON.stringify({getType: 'General'})).done((data) => {
        let sound = String(data.sound);

        // TRANSITION INTO WHOLE NUMBER... YES I KNOW... PAIN.
        if (sound.includes('0.')) {
            sound = sound.substring(2);
        }

        $('#settings_localsfxrange').val(Number(sound));
        $('#settings_boomboxtoggle').prop('checked', Boolean(data.mutedBoomboxes));
        $('#settings_dispatchsfxtoggle').prop('checked', Boolean(data.mutedDispatchPing));
        $('#settings_phonenotiftoggle').prop('checked', Boolean(data.mutedPhone));
        $('#settings_radioanimswitch').val(String(data.radioAnim));
    });

    $settingsContent.html(`
        <p class="settings_heading">Sounds:</p>

        <p class="settings_label" style="margin-top: 2%;">Volume of local SFX (seatbelt, etc):</p>
        <input type="range" class="settings_setting_slider" id="settings_localsfxrange" min="0" max="10" step="1">

        <p class="settings_label" style="margin-top: 4.4%;">Mute Boomboxes:</p>
        <div class="settings_setting_checkbox">
            <input type="checkbox" id="settings_boomboxtoggle">
        </div>

        <p class="settings_heading" style="margin-top: -4%;">Dispatch:</p>

        <p class="settings_label" style="margin-top: 2%;">Mute Alert Ping:</p>
        <div class="settings_setting_checkbox">
            <input type="checkbox" id="settings_dispatchsfxtoggle">
        </div>

        <p class="settings_heading" style="margin-top: -4%;">Phone:</p>

        <p class="settings_label" style="margin-top: 2%;">Mute Phone Notifications:</p>
        <div class="settings_setting_checkbox">
            <input type="checkbox" id="settings_phonenotiftoggle" style="margin-left: 120.5%;">
        </div>

        <p class="settings_heading" style="margin-top: -5.6%;">Radio:</p>

        <p class="settings_label" style="margin-top: 2%;">Animation:</p>
        <select class="settings_setting_dropdown" id="settings_radioanimswitch" style="margin-left: 14.9%; top: 68.2%; position: absolute;">
            <option value="Shoulder Mic" class="dropdown_option">Shoulder Mic</option>
            <option value="Hold Radio" class="dropdown_option">Hold Radio</option>
        </select>
    `);
}

// WHEN TRIGGERED, SHOW UI SUBMENU
function OpenUISubmenu() {
    currentMenu = 'UI';
    $settingsContent.html('');

    // GET AND SET DEFAULT SETTINGS
    $.post('https://soe-ui/Settings.GetSettings', JSON.stringify({getType: 'UI'})).done((data) => {
        $('#settings_chatsizeinput').val(String(data.chatSize));
        $('#settings_blackboxsizeinput').val(String(currentBlackboxSize));

        $('#settings_helpchattoggle').prop('checked', Boolean(data.mutedHelpChat));
        $('#settings_staffchattoggle').prop('checked', Boolean(data.mutedStaffChat));
        $('#settings_exitmsgtoggle').prop('checked', Boolean(data.mutedExitMsgs));
        $('#settings_stafftagtoggle').prop('checked', Boolean(data.hideStaffTag));

        $('#settings_blackboxtoggle').prop('checked', Boolean(data.blackboxes));
        $('#settings_roundedmaptoggle').prop('checked', Boolean(data.roundedMap));
        $('#settings_mapbordertoggle').prop('checked', Boolean(data.showMapBorder));

        $('#settings_licensechatmsgtoggle').prop('checked', Boolean(data.useChatMessageForLicense));
        $('#settings_licensefadetoggle').prop('checked', Boolean(data.shouldLicenseFade));
        $('#settings_licensefadetimerinput').val(String(data.licenseFadeTime));
        $('#settings_licensedurationtimerinput').val(String(data.licenseTimer));
    });

    $settingsContent.html(`
        <p class="settings_heading">Chat:</p>

        <p class="settings_label" style="margin-top: 2%;">Mute Help Chat:</p>
        <div class="settings_setting_checkbox">
            <input type="checkbox" id="settings_helpchattoggle">
        </div>

        <p class="settings_label" style="margin-top: -4%;">Mute Staff Chat (Staff Only):</p>
        <div class="settings_setting_checkbox" style="margin-left: 35.1%;">
            <input type="checkbox" id="settings_staffchattoggle">
        </div>

        <p class="settings_label" style="margin-top: -4%;">Mute Exit Messages (Staff Only):</p>
        <div class="settings_setting_checkbox" style="margin-left: 40%;">
            <input type="checkbox" id="settings_exitmsgtoggle">
        </div>

        <p class="settings_label" style="margin-top: -4%;">Set Chat Size:</p>
        <div class="settings_setting_inputbox" style="margin-left: 18.5%; margin-top: -3.2%;">
            <input id="settings_chatsizeinput" type="number" maxlength="6" placeholder="1.0-3.0 (Default: 1.5)">
        </div>

        <p class="settings_label" style="margin-top: 4%;">Hide Staff Tag in Messages (Staff Only):</p>
        <div class="settings_setting_checkbox" style="margin-left: 48.3%;">
            <input type="checkbox" id="settings_stafftagtoggle">
        </div>

        <p class="settings_heading" style="margin-top: -5.5%;">Cinematic Blackboxes:</p>

        <p class="settings_label" style="margin-top: 2%;">Enabled:</p>
        <div class="settings_setting_checkbox" style="margin-left: 14%;">
            <input type="checkbox" id="settings_blackboxtoggle">
        </div>

        <p class="settings_label" style="margin-top: -5%;">Set Box Height:</p>
        <div class="settings_setting_inputbox" style="margin-left: 20%; margin-top: -3.2%;">
            <input id="settings_blackboxsizeinput" type="number" maxlength="3" placeholder="1-100">
        </div>

        <p class="settings_heading" style="margin-top: 3%;">Minimap:</p>

        <p class="settings_label" style="margin-top: 2%;">Rounded Map:</p>
        <div class="settings_setting_checkbox" style="margin-left: 19.8%;">
            <input type="checkbox" id="settings_roundedmaptoggle">
        </div>

        <p class="settings_label" style="margin-top: -5.5%;">Map Border (Must be round):</p>
        <div class="settings_setting_checkbox" style="margin-left: 34.95%;">
            <input type="checkbox" id="settings_mapbordertoggle">
        </div>

        <p class="settings_heading" style="margin-top: -5.5%;">Licenses:</p>

        <p class="settings_label" style="margin-top: 2%;">Disappear after a duration (Press H to clear all):</p>
        <div class="settings_setting_checkbox" style="margin-left: 56.8%;">
            <input type="checkbox" id="settings_licensefadetoggle">
        </div>

        <p class="settings_label" style="margin-top: -6.3%;">Set Fade Timer (ms):</p>
        <div class="settings_setting_inputbox" style="margin-left: 26.2%; margin-top: -3.2%;">
            <input id="settings_licensefadetimerinput" type="number" maxlength="5" placeholder="3500">
        </div>

        <p class="settings_label" style="margin-top: 2.2%;">Set duration until fade timer (ms):</p>
        <div class="settings_setting_inputbox" style="margin-left: 40.9%; margin-top: -3.2%;">
            <input id="settings_licensedurationtimerinput" type="number" maxlength="5" placeholder="10000">
        </div>

        <p class="settings_label" style="margin-top: 2%;">Chat Message License:</p>
        <div class="settings_setting_checkbox" style="margin-left: 28.1%;">
            <input type="checkbox" id="settings_licensechatmsgtoggle">
        </div>
    `);
}

// WHEN TRIGGERED, SAVE UI SETTINGS
function SaveUISettings() {
    let inputtedSettings = {};
    switch(currentMenu) {
        case 'General':
            let localSFX = $('#settings_localsfxrange').val();

            let mutedBoomboxes = $('#settings_boomboxtoggle').is(':checked');
            let mutedDispatchPing = $('#settings_dispatchsfxtoggle').is(':checked');
            let mutedPhone = $('#settings_phonenotiftoggle').is(':checked')

            let radioAnimation = $('#settings_radioanimswitch').children("option:selected").val()

            inputtedSettings = JSON.stringify({
                localSFX: Number(localSFX),
                mutedBoomboxes: Boolean(mutedBoomboxes),
                mutedDispatchPing: Boolean(mutedDispatchPing),
                mutedPhone: Boolean(mutedPhone),
                radioAnimation: String(radioAnimation)
            });
            break;
        case 'UI':
            let mutedHelpChat = $('#settings_helpchattoggle').is(':checked');
            let mutedStaffChat = $('#settings_staffchattoggle').is(':checked');
            let mutedExitMsgs = $('#settings_exitmsgtoggle').is(':checked');
            let chatSize = $('#settings_chatsizeinput').val();
            let hideStaffTag = $('#settings_stafftagtoggle').is(':checked');

            let blackboxes = $('#settings_blackboxtoggle').is(':checked');
            let blackboxSize = $('#settings_blackboxsizeinput').val();
            let roundedMap = $('#settings_roundedmaptoggle').is(':checked');
            let mapBorder = $('#settings_mapbordertoggle').is(':checked');

            let useLicenseChatMsg = $('#settings_licensechatmsgtoggle').is(':checked');
            let _licenseFade = $('#settings_licensefadetoggle').is(':checked');
            let _licenseFadeTime = $('#settings_licensefadetimerinput').val();
            let _licenseTimer = $('#settings_licensedurationtimerinput').val();

            ToggleBlackboxes(Boolean(blackboxes));
            ChangeBlackboxHeight(String(blackboxSize));
            LoadLicensePreferences(Boolean(_licenseFade), Number(_licenseTimer), Number(_licenseFadeTime))

            inputtedSettings = JSON.stringify({
                mutedHelpChat: Boolean(mutedHelpChat),
                mutedStaffChat: Boolean(mutedStaffChat),
                mutedExitMsgs: Boolean(mutedExitMsgs),
                chatSize: String(chatSize),
                hideStaffTag: Boolean(hideStaffTag),
                blackboxes: Boolean(blackboxes),
                roundedMap: Boolean(roundedMap),
                showMapBorder: Boolean(mapBorder),
                licenseFade: Boolean(_licenseFade),
                licenseTimer: Number(_licenseTimer),
                licenseFadeTime: Number(_licenseFadeTime),
                useLicenseChatMsg: Boolean(useLicenseChatMsg)
            });
            break;
        default:
            console.log(`[Settings] Unknown menu type detected. (${currentMenu})`);
            break;
    }

    $.post("https://soe-ui/Settings.Save", JSON.stringify({inputtedSettings}));
}

// GENERAL INTERACTION FUNCTION
$(() => {
    // CLOSES UI WHEN 'ESCAPE' IS PRESSED
    $(document).on('keydown', (event) => {
        switch(event.key) {
            case 'Escape':
                CloseSettingsUI()
                break;
        }
    });

    // WHEN CLICKED, SAVE SETTINGS IN CURRENT MENU
    $('#settings_savebutton').on('click', function() {
        SaveUISettings();
    });

    // WHEN CLICKED, RESET UI INSTANCES
    $('#settings_resetbutton').on('click', function() {
        $.post("https://soe-ui/Settings.ResetPressed", JSON.stringify({}));
    });

    // WHEN A SUBMENU BUTTON IS PRESSED, CHANGE PAGE
    $('.settings_pagebutton').on('click', function() {
        let button = $(this);

        switch(button.html()) {
            case "General":
                OpenGeneralSubmenu();
                break;
            case "UI":
                OpenUISubmenu();
                break;
            default:
                console.log(`[Settings] Unknown page type detected. (${button.html()})`);
                break;
        }
    });
})
