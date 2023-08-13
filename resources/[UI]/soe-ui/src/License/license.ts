let licenseInterval: any;
let licenseTimer = 10000;
let canLicenseFade = true;
let licenseFadeTime = 3500;
const $licenseUI = $('#license_container');

// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let data = event.data
    switch(data.type) {
        case 'License.Clear':
            ClearLicenses();
            break;
        case 'License.Show':
            ShowLicense(data.licenseData);
            break;
        case 'License.LoadPreferences':
            LoadLicensePreferences(data.licenseFade, data.licenseTimer, data.licenseFadeTime);
            break;
    }
})

// WHEN TRIGGERED, CLEAR ANY LICENSES ON SCREEN
function ClearLicenses() {
    if (canLicenseFade) {
        $licenseUI.fadeOut(licenseFadeTime);
    } else {
        $licenseUI.css('display', 'none');
    }
}

// WHEN TRIGGERED, LOAD LICENSE UI PREFERENCES
export function LoadLicensePreferences(licenseFade: boolean, _licenseTimer: number, _licenseFadeTime: number) {
    if (licenseFade != undefined) {
        canLicenseFade = licenseFade || false;
    }

    if (_licenseTimer != undefined) {
        licenseTimer = _licenseTimer || 10000;
    }

    if (_licenseFadeTime != undefined) {
        licenseFadeTime = _licenseFadeTime || 3500;
    }
}

// WHEN TRIGGERED, SHOW LICENSE UI
async function ShowLicense(licenseData: object) {
    if (licenseInterval != null) {
        clearInterval(licenseInterval);
    }
    $licenseUI.css('display', 'none');
    $licenseUI.css('display', 'block');

    $('#license_personimage').attr('src', licenseData['picture']);
    $('#license_signature').html(licenseData['firstGiven'].substring(0, 1) + '. ' + licenseData['lastGiven']);

    $('#license_id').html(`DL ` + `<span class='license_data'>${licenseData['licenseID']}</span>`);
    $('#license_expiry').html(`EXP ` + `<span class='license_data'>${licenseData['expiryDate']}</span>`);
    $('#license_issued').html(`ISS ` + `<span class='license_data'>${licenseData['issuedDate']}</span>`);

    $('#license_lastgiven').html(`LN ` + `<span class='license_data'>${licenseData['lastGiven'].toUpperCase()}</span>`);
    $('#license_firstgiven').html(`FN ` + `<span class='license_data'>${licenseData['firstGiven'].toUpperCase()}</span>`);

    $('#license_dob').html(`DOB ` + `<span class='license_data'>${licenseData['DOB']}</span>`);
    $('#license_gender').html(`SEX ` + `<span class='license_data'>${licenseData['gender'].substring(0, 1).toUpperCase()}</span>`);
    $('#license_ssn').html(`SSN ` + `<span class='license_data'>${licenseData['SSN']}</span>`);

    if (canLicenseFade) {
        licenseInterval = setInterval(() => {
            $licenseUI.fadeOut(licenseFadeTime);
        }, licenseTimer)
    }
}
