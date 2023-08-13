// POPUP 1 - INPUT
// POPUP 2 - CONFIRM
// POPUP 3 - SELECT

var errorType = 'text';
var errorMin = 0;
var errorMax = 0;
var popupTimer;
var textTimer;

// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let data = event.data
    switch(data.type) {
        case 'charid':
            MakePopup(data.message, 'charid', 4, 5);
            break;
        case 'text':
            MakePopup(data.message, 'text', 5, 255);
            break;
        case 'number':
            MakePopup(data.message, 'number', 1, 255);
            break;
        case 'name':
            MakePopup(data.message, 'text', 1, 32);
            break;
        case 'confirm':
            MakeConfirmation(data.message, data.yesText, data.noText);
            break;
        case 'selection':
            //console.log(typeof event.data.options);
            MakeSelection(data.message, data.options);
            break;
        case 'Input.ResetUI':
            HideInputUI();
            console.log('[Input] UI resetted.');
            break;
        default:
            console.log("Invalid type passed to NUI (" + data.type + ")");
            break;
    }
});

function HideInputUI() {
    $.post('https://soe-input/Input.ReturnData', JSON.stringify({
        input: null
    }));

    $('.popup-value').val('');
    $('.popup').fadeOut();
    $('.popup2').fadeOut();

    $('.popup3').fadeOut();
    $("#popup-select").empty();
}

function MakePopup(title, type, min, max) {
    errorType = type;
    errorMin = min;
    errorMax = max;

    if (type == 'text') {
        $('.popup-value').attr('type', 'text');
    } else if (type == 'number') {
        $('.popup-value').attr('type', 'number');
    } else if (type == 'charid') {
        $('.popup-value').attr('type', 'number');
    }

    $('.confirm-button').unbind('click');
    $('.confirm-button').addClass('disabled');
    $('.confirm-button').attr('disabled', true);
    $('.popup-value').val('');
    $('.popup .title').html(title);
    $('.popup').fadeIn();

    $('.popup-value').on('input', function() {
        if ($('.popup-value').val()) {
            $('.confirm-button').removeClass('disabled');
            $('.confirm-button').attr('disabled', false);
        } else {
            $('.confirm-button').addClass('disabled');
            $('.confirm-button').attr('disabled', true);
        }
    });

    $('.confirm-button').click(function() {
        if ($('.popup-value').val()) {
            //value has been given
            if ($('.popup-value').val().length > errorMax) {
                makeError('Input must be less than ' + errorMax + ' characters long. Try again.');
            } else if ($('.popup-value').val().length < errorMin) {
                makeError('Input must be more than ' + errorMin + ' characters long. Try again.');
            } else {
                $.post('https://soe-input/Input.ReturnData', JSON.stringify({
                    input: $('.popup-value').val()
                }));
                $('.popup').fadeOut();
            }
        } else {
            makeError('No Value Entered. Try Again.');
        }
    });

    $('.cancel-button').click(function() {
        $.post('https://soe-input/Input.ReturnData', JSON.stringify({
            input: null
        }));
        $('.popup-value').val('');
        $('.popup').fadeOut();
    });
    $(".popup-value").focus()
}

function MakeConfirmation(title, yesText, noText) {
    $('.popup-value').val('');
    $('.popup2 .title').html(title);
    $('.confirm-button-2').html(yesText);
    $('.cancel-button-2').html(noText);
    $('.popup2').fadeIn();

    $('.confirm-button-2').unbind('click');
    $('.confirm-button-2').on('click', function() {
        $.post('https://soe-input/Input.ReturnData', JSON.stringify({
            input: true
        }));
        $('.popup2').fadeOut();
    });

    $('.cancel-button-2').unbind('click');
    $('.cancel-button-2').on('click', function() {
        $.post('https://soe-input/Input.ReturnData', JSON.stringify({
            input: false
        }));
        $('.popup2').fadeOut();
    });
}

function MakeSelection(title, options) {
    $('.popup3 .title').html(title);
    $('.popup3').fadeIn();

    $("#popup-select").empty();
    options.forEach(option => {
        var newOption = new Option(option, option)
        $(newOption).addClass("text-dark");
        $("#popup-select").append(newOption);
    });
    
    $('.confirm-button-3').unbind('click');
    $('.confirm-button-3').on('click', function() {
        $.post('https://soe-input/Input.ReturnData', JSON.stringify({
            input: $('#popup-select').children("option:selected").val()
        }));
        $('.popup3').fadeOut();
    });

    $('.cancel-button-3').unbind('click');
    $('.cancel-button-3').on('click', function() {
        $.post('https://soe-input/Input.ReturnData', JSON.stringify({
            input: null
        }));
        $('.popup3').fadeOut();
    });
}

function makeError(message) {
    clearTimeout(popupTimer);
    clearTimeout(textTimer);

    $('.error-text').text(message);
    $('.error-popup').fadeIn();

    popupTimer = setTimeout(function() { $('.error-popup').fadeOut(); }, 4000);
    textTimer = setTimeout(function() { $('.error-text').text(''); }, 4100);
}

$(() => {
    $(document).on('keydown', function(event) {
        if (event.key == "Escape") {
            if ($('.popup2').is(':visible')) {
                return;
            }

            $('.popup-value').val('');
            $('.popup').fadeOut();
            $('.popup2').fadeOut();
            $('.popup3').fadeOut();

            $.post('https://soe-input/Input.ReturnData', JSON.stringify({
                input: null
            }));
        } else if (event.key == "Enter") {
            if ($('.popup2').is(':visible')) {
                return;
            }

            if ($('.popup-value').val()) {
                // value has been given
                if ($('.popup-value').val().length > errorMax) {
                    makeError('Input must be less than ' + errorMax + ' characters long. Try again.');
                } else if ($('.popup-value').val().length < errorMin) {
                    makeError('Input must be more than ' + errorMin + ' characters long. Try again.');
                } else {
                    $.post('https://soe-input/Input.ReturnData', JSON.stringify({
                        input: $('.popup-value').val()
                    }));
                    $('.popup').fadeOut();
                }
            } else {
                makeError('No Value Entered. Try Again.');
            }
        }
    });
});
