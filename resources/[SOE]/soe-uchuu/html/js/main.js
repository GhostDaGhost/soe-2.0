function doLogin() {
    //slideTo(2);
    //populateCharacters({"18456": {"Name": "Paul Bamber", "DOBString": "12/19/1990 (29)", "Department": "SASP", "JobTitle": "Trooper"},
    //"23812": {"Name": "Johnny Test", "DOBString": "02/19/1982 (29)", "Department": "SAFR", "JobTitle": "Medic"}});
    var username = $('.login-username').val();
    var password = $('.login-password').val();
    // TRIGGER: Do login with callback
    $.post('https://soe-uchuu/Uchuu.ButtonPush', JSON.stringify({
        eventType: "login",
        username: username,
        password: password
    })).done(function (data) {
        if (data.status) {
            // Login Success
            slideTo(2);
            populateCharacters(data.data.Characters)
        } else {
            // Login Failed
            $('.login-error').removeClass('d-none');
            $('.login-error').text(data.message);
            setTimeout(function () {
                $('.login-error').toggleClass('d-none');
                $('.login-error').text('');
            }, 5000);
        }
    });
}

function doRegister() {
    var username = $('.register-username').val();
    var password = $('.register-password').val();
    var repeatPassword = $('.register-repeatPassword').val();
    var forumUsername = $('.register-forumUsername').val();
    var forumPassword = $('.register-forumPassword').val();
    if (password != repeatPassword) {
        $('.register-error').removeClass('d-none');
        $('.register-error').text('Passwords do not match!');
        setTimeout(function () {
            $('.register-error').toggleClass('d-none');
            $('.register-error').text('');
        }, 5000);
        return false;
    }
    // TRIGGER: Do register with callback
    $.post('https://soe-uchuu/Uchuu.ButtonPush', JSON.stringify({
        eventType: "register",
        username: username,
        password: password,
        forumUsername: forumUsername,
        forumPassword: forumPassword
    })).done(function (data) {
        if (data.status) {
            // Register Success
            slideTo(2);
        } else {
            // Register Failed
            $('.register-error').removeClass('d-none');
            $('.register-error').text(data.message);
            setTimeout(function () {
                $('.register-error').toggleClass('d-none');
                $('.register-error').text('');
            }, 5000);
        }
    });
}

function doCharacterCreate() {
    var firstName = $('.newCharacter-firstName').val();
    var lastName = $('.newCharacter-lastName').val();
    var dob = $('.newCharacter-dob').val();
    var gender = $('.newCharacter-form .btn.active input').val();

    // TRIGGER: Do Character Create with callback
    //console.log("DEBUG 1");
    $.post('https://soe-uchuu/Uchuu.ButtonPush', JSON.stringify({
        eventType: "charCreate",
        FirstGiven: firstName,
        LastGiven: lastName,
        DOB: formatDate(dob),
        Gender: gender
    })).done(function (data) {
        // console.log("HEH");
        // console.log(data);
        data = JSON.parse(data);
        if (data.status) {
            // Update character list
            // Return to character select
            // console.log("We got here!");
            // console.log(data.data.Characters);
            populateCharacters(data.data.Characters);
            slideTo(2);
        } else {
            // Character Failed
            $('.newCharacter-error').removeClass('d-none');
            $('.newCharacter-error').text('Character Creation Failed');
            setTimeout(function () {
                $('.newCharacter-error').toggleClass('d-none');
                $('.newCharacter-error').text('');
            }, 5000);
        }
    });
}

function copyToClipboard(text) {
    var dummy = document.createElement("textarea");
    document.body.appendChild(dummy);
    dummy.value = text;
    dummy.select();
    document.execCommand("copy");
    document.body.removeChild(dummy);
}

function slideTo(panel) {
    var panelTo = panel;
    $('.panel-in').addClass('panel-off');
    $('.panel-in').removeClass('panel-in');
    $('.panel-' + panelTo).addClass('panel-in');
    if (panel <= 3) {
        $('#form-wizard .current').removeClass('current');
        $('.wizard-link-' + panelTo).addClass('current');
    }
}

function populateCharacters(characters) {
    var charCount = 0;
    $('.characters-container').html('');
    $.each(characters, function (charid, character) {
        charCount++;
        var CharID = charid;
        var Name = character['FirstGiven'] + " " + character['LastGiven'];
        var DOBString = getDOBString(character['DOB']);
        var Employer = character['Employer'];
        var JobTitle = character['JobTitle'];
        var Image = Employer.toLowerCase();
        if (Employer == 'Citizen') {
            JobTitle = 'State of San Andreas';
            Image = 'state';
        }
        $('.characters-container').append('<div class="character" data-charid="' + CharID + '"><p class="character-name">' + Name + '</p><p class="character-dob">' + DOBString + '</p><p class="employment-employer">' + Employer + '</p><p class="employment-title">' + JobTitle + '</p><img src="img/' + Image + '-logo.png" alt="" class="employment-logo centered"></div>');
    });
    if (charCount >= 10) {
        $('.new-character').addClass('d-none');
    }
}

function populateSpawns(spawns) {
    $('.spawns-container').html('');
    $.each(spawns, function (spawnid, spawn) {
        var SpawnID = spawnid;
        var Name = spawn['Name'];
        var Cost = spawn['Cost'];
        var Description = spawn['Description'];

        $('.spawns-container').append('<div class="spawn" data-spawnid="' + SpawnID + '"><p class="spawn-name">' + Name + '</p><p class="spawn-cost">$' + Cost + '</p><p class="spawn-description">' + Description + '</p></div>');
    });
}

function getDOBString(DOB) {
    var dateArray = DOB.split("-");
    var DOBDate = new Date(Number(dateArray[0]), Number(dateArray[1]), Number(dateArray[2]));
    var currentDate = new Date();

    var currentDate = new Date();
    var DOBDate = new Date(dateArray[0], dateArray[1], dateArray[2]);
    var age = currentDate.getFullYear() - DOBDate.getFullYear();
    var m = currentDate.getMonth() - DOBDate.getMonth();
    if (m < 0 || (m === 0 && currentDate.getDate() < DOBDate.getDate())) {
        age--;
    }
    return DOB + " (Age: " + age + ")";
}

function formatDate(date) {
    var dateArray = date.split("/");
    var newDate = dateArray[2] + "-" + dateArray[0] + "-" + dateArray[1];
    return newDate;
}

$(function () {
    $('.login-form').submit(function (e) {
        e.preventDefault();
        doLogin();
    });

    $('.register-form').submit(function (e) {
        e.preventDefault();
        doRegister();
    });

    $('.newCharacter-form').submit(function (e) {
        e.preventDefault();
        if (moment(moment($('.newCharacter-dob').val()).format('MM/DD/YYYY'), 'MM/DD/YYYY', true).isValid()) {
            var birthdate = moment($('.newCharacter-dob').val());
            var age = moment().diff(birthdate, 'years');
            if (age < 18) {
                $('.newCharacter-error').removeClass('d-none');
                $('.newCharacter-error').text('Character must be at least 18!');
                setTimeout(function () {
                    $('.newCharacter-error').toggleClass('d-none');
                    $('.newCharacter-error').text('');
                }, 5000);
            } else {
                doCharacterCreate();
            }
        } else {
            // Invalid DOB
            $('.newCharacter-error').removeClass('d-none');
            $('.newCharacter-error').text('Invalid Date of Birth');
            setTimeout(function () {
                $('.newCharacter-error').toggleClass('d-none');
                $('.newCharacter-error').text('');
            }, 5000);
        }

    });

    $('.url').click(function () {
        copyToClipboard($(this).text());
    });

    $('body').on('click', '.character', function () {
        //slideTo(3);
        //populateSpawns({"1": {"Name": "Banner Hotel - Alta", "Cost": 250, "Description": "Something I figure out later"}, "2": {"Name": "Paleto Hotel - Paleto", "Cost": 250, "Description": "Something I figure out later"}, "3": {"Name": "Banner Hotel - Harmony", "Cost": 250, "Description": "Something I figure out later"}});
        var charid = $(this).attr('data-charid');
        // TRIGGER: Do select character with callback
        $.post('https://soe-uchuu/Uchuu.ButtonPush', JSON.stringify({
            eventType: "charSelect",
            CharID: charid
        })).done(function (data) {
            if (data.status) {
                // Update spawn list
                populateSpawns(data.data);
                slideTo(3);
            } else {
                // Invalid Character?
            }
        });
    });

    $('body').on('click', '.spawn', function () {
        var spawnid = $(this).attr('data-spawnid');
        // TRIGGER: Do spawn
        $.post('https://soe-uchuu/Uchuu.ButtonPush', JSON.stringify({
            eventType: "spawnSelect",
            SpawnID: spawnid
        }));
        $('html').fadeOut(1000);
    });
});
