var selectedAccountATM = null;
var selectedAccountID = null;
var accounts = {};
// var openCardAtIndexZero = false;

var functionWaitingForInput = null;
var amountInput = null;

var enteredPin = null;

var messagePresets = {
    "TransactionCancelled": {
        icon: "<i class=\"far fa-times-circle\"></i>",
        message: "Transaction Cancelled",
    },
    "InsufficientFunds": {
        icon: "<i class=\"far fa-times-circle\"></i>",
        message: "Insufficient Funds",
    },
    "ProcessingTransaction": {
        icon: "<i class=\"far fa-clock\"></i>",
        message: "Processing Transaction",
    },
    "TransactionSuccess": {
        icon: "<i class=\"fas fa-check\"></i>",
        message: "Transaction Successful",
    },
    "UnexpectedError": {
        icon: "<i class=\"fas fa-exclamation-triangle\"></i>",
        message: "Unexpected error, please try again later",
    },
    "IncorrectPin": {
        icon: "<i class=\"fas fa-ban\"></i>",
        message: "Incorrect pin entered, please try again",
    },
}

$('#atm-header-date').html(getDate());

window.addEventListener('message', (event) => {
    // console.log("event received: " + JSON.stringify(event.data));
    switch (event.data.type) {
        case "OpenUI":
            $('body').addClass('active');
            $('.debit-card-container').show();
            loadPage("ChoosePayment");
            $('#atm-header-logo').html(ConvertToCurrency(event.data.price));
            // console.log("ATM Opened");
            break;
        case 'Shops.HideUI':
            console.log('[Payment UI] UI resetted.');
            $.post('https://soe-shops/CancelTransaction', JSON.stringify({}));
            CloseUI();
            break;
        case "ReceiveAccountData":
            // Check if selected account is null, and set if it is

            console.log(event.data.accountsData);

            if (event.data.accountsData) {
                if (selectedAccountATM == null) {
                    // Save other associated accounts into array for later usage
                    $.each(event.data.accountsData, function(index, val) {
                        accounts[index] = JSON.parse(val.ItemMeta);
                    });
                }

                // Clear old cards
                $('#atm-card-selection-col').html('');

                // Add bank cards to selection column
                var cardSelection = document.querySelector("#atm-card-selection-col");
                var template = document.querySelector("#debit-card-template");

                var clone = template.content.cloneNode(true);
                clone.querySelector('.card').style.cssText += 'background-color: #85bb65';
                clone.querySelector('#card-number').textContent = ConvertToCurrency(event.data.cashData);
                clone.querySelector('#card-type').textContent = "Cash Money";
                clone.querySelector('#card-bank').textContent = "";
                clone.querySelector('#account-name-title').textContent = "";
                clone.querySelector('#account-number-title').textContent = "";
                clone.querySelector('.card').id = 'cash';
                cardSelection.appendChild(clone);

                $.each(event.data.accountsData, function(index, val) {
                    val = JSON.parse(val.ItemMeta);

                    // console.log(val);
                    // Clone new card, insert into column
                    var clone = template.content.cloneNode(true);

                    // Card Number
                    clone.querySelector('#card-number').textContent = val.cardnumber.toString().replace(/(\d{4})(\d{4})(\d{4})(\d{4})/, "$1-$2-$3-$4");

                    // Card Name
                    clone.querySelector('#account-name').textContent = (val.firstnames.split(" ").map((n)=>n[0]).join(" ") + " " + val.surname).toUpperCase();

                    // Card Type
                    clone.querySelector('#card-type').textContent = val.cardtype;

                    // Account Number
                    clone.querySelector('#card-issue-date').textContent = val.accountnumber || 00000000;

                    clone.querySelector('.card').id = index;
                    cardSelection.appendChild(clone);

                    // console.log("Card generated, account: " + val.accountNumber);
                });
            } else {
                console.warn("Accounts Data nil");
            }
            break;
        case "SendTransactionStatus":
            var result = event.data.response;
            if (result.status) {
                console.log("Transaction success.");
                loadPage("ShowMessage", messagePresets.TransactionSuccess);
                setTimeout(() => {
                    CloseUI();
                }, 1000);
            } else {
                console.warn("Transaction failed.");
                console.log(result.message)

                switch (result.message) {
                    case 'Card/Pin Match Failed.':
                        $('.card').removeClass("active");
                        loadPage("ShowMessage", messagePresets.IncorrectPin);
                        break;
                    case 'Invalid Transaction.':
                        $('.card').removeClass("active");
                        loadPage("ShowMessage", messagePresets.UnexpectedError);
                        setTimeout(() => {
                            CloseUI()
                        }, 1000);
                        break;
                    case 'Insufficient Funds.':
                        $('.card').removeClass("active");
                        loadPage("ShowMessage", messagePresets.InsufficientFunds);
                        break;
                    default:
                        $('.card').removeClass("active");
                        loadPage("ShowMessage", messagePresets.UnexpectedError);
                        break;
                }

                setTimeout(() => {
                    loadPage('ChoosePayment');
                }, 1000);
            }
            break;
    }
});

async function PerformAPICallback(api, dataString) {
    const response = await fetch(`https://${GetParentResourceName()}/` + api, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: dataString
    })
    const data = response.json();
    return data;
}

function ConvertToCurrency(num) {
    // console.log(num);
    var formattedNum = null;
    if (num < 0) {
        formattedNum = "- $" + num.toString().substring(1).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    } else {
        formattedNum = "$" + num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
    return formattedNum;
}

function getDate()
{
    var days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
    var months = ['January','February','March','April','May','June','July','August','September','October','November','December'];

    var currentDate = new Date();

    return days[currentDate.getDay()] + ', ' + currentDate.getDate() + ' ' + months[currentDate.getMonth()] + ' ' + currentDate.getFullYear();
}

function loadPage(page, data)
{
    switch (page) {
        case 'ChoosePayment':
            $('.atm-menu-container').hide();
            $('#choose-payment.atm-menu-container').show();
            break;
        case 'InsertPin':
            $('.atm-menu-container').hide();
            $('#insert-pin.atm-menu-container').show();
            break;
        case 'ShowMessage':
            $('.atm-menu-container').hide();
            $('#message-display.atm-menu-container').show();
            $('#message-icon').html(data.icon);
            $('#message-text').html(data.message);
            break;
        default:
            console.log("Unexpected page attempted to load (" + page + ")");
            break;
    }
}

function isInt(num)
{
    num = parseInt(num);
    if (typeof num === 'number' && (num % 1) === 0) {
        // Button data is an integer
        return true;
    } else {
        return false;
    }
}

function onAtmButtonClick(id)
{
    $('body').show();
    switch (id) {
        case 'Exit':
            $.post('https://soe-shops/CancelTransaction', JSON.stringify({}));
            CloseUI();
            break;
        case 'Cancel':
            loadPage("ShowMessage", messagePresets.TransactionCancelled);
            $.post('https://soe-shops/CancelTransaction', JSON.stringify({}));
            functionWaitingForInput = null;
            setTimeout(() => {
                console.log("Closing ATM UI");
                CloseUI();
            }, 1000);

            break;
        default:
            if (isInt(id)) {
                amountInput = id;
                // console.log('Amount saved: ' + amountInput);
                loadPage("ConfirmTransaction");
            } else {
                // console.warn("Amount is not an integer (" + id + ")");
            }
            break;
    }
}

function CloseUI()
{
    $('.atm-menu-container').hide();
    $('.debit-card-container').hide();
    $('body').removeClass('active');

    selectedAccountATM = null;
    accounts = {};
    functionWaitingForInput = null;
    amountInput = null;

    $.post(`https://${GetParentResourceName()}/CloseUI`, JSON.stringify({}));
}


// *********************************
//       Interaction functions
// *********************************

// Detect if any ATM button has been clicked
$(document).on('click', ".atm-button", function (event) {
    var id = $(this).attr("id");
    onAtmButtonClick(id);
});

// Detect when pin entered
$(document).on('click', "block", function (event) {
    switch ($(this).attr("value")) {
        case 'submit':
            enteredPin = $('#pin-input').val();

            $('#pin-input').val('');
            
            ProcessTransaction();
            break;
        case 'cancel':
            loadPage("ShowMessage", messagePresets.TransactionCancelled);
            $.post('https://soe-shops/CancelTransaction', JSON.stringify({}));
            setTimeout(() => {
                console.log("Closing ATM UI");
                CloseUI();
            }, 1000);
            break;
        default:
            $('#pin-input').val($('#pin-input').val() + $(this).attr("value"));
            enteredPin = $('#pin-input').val();
            // console.log($('#pin-input').val());
            break;
    }
});

function ProcessTransaction() {
    var apiArgs;

    if (selectedAccountID == "cash") {
        apiArgs = JSON.stringify({
            type: 'cash'
        })
    } else {
        apiArgs = JSON.stringify({
            type: 'debit',
            cardnumber: selectedAccountATM.cardnumber,
            pin: enteredPin
        })
    }

    console.log(apiArgs);

    var APICallback = PerformAPICallback('ProcessTransaction', apiArgs);

    loadPage('ShowMessage', messagePresets.ProcessingTransaction);
}

// Detect when player has selected an account
$('#atm-card-selection-col').on('click', ".card", function (event) {
    if (selectedAccountATM == null || selectedAccountATM == accounts[this.id]) {
        // Set selected account as new selection
        selectedAccountATM = accounts[this.id];
        selectedAccountID = this.id;

        // Remove active class from other cards before setting new one
        $('.card').removeClass("active");

        // Set active class on latest selected card
        $(this).addClass("active");

        if (this.id == 'cash') {
            ProcessTransaction();
        } else {
            loadPage('InsertPin');
        }

        var storeCard = $(this).parent().parent().clone();

        $('#atm-card-selection-col').html('');

        storeCard.appendTo("#atm-card-selection-col");

    } else {
        console.warn("Account already selected");
    }
});
