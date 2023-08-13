var DEBUG = true;
var CHARID;

// Methods
function devText(item) {
    $('.dev-text').text(item);
}

function getRandomInt(max) {
    return Math.floor(Math.random() * Math.floor(max) + 1);
}

function syncInventory(json, container = 'left', title = 'Inventory') {
    var inventory = json;
    $('.inventory-title-' + container).html(title);
    
    console.log(JSON.stringify(inventory));

    inventory = JSON.parse(JSON.stringify(inventory));
    console.log(inventory);
    // Add Items
    jQuery.each(inventory.items, function(item) {
        if ($('.item[data-uid=' + this.uid + ']').length > 0) {
            var amount = this.amt;
            var singleWeight = this.weight / amount;
            var newWeight = (singleWeight * amount).toFixed(2);
            $('.item[data-uid=' + this.uid + ']')
                .data('amount', amount)
                .data('weight', newWeight)
                .find(".amount").html('<i class="fas fa-hashtag"></i>' + amount + '');

            $('.item[data-uid=' + this.uid + ']')
                .find(".weight").html('<i class="fas fa-weight-hanging"></i>' + newWeight + '');


        } else {
            var amount = this.amt;
            var singleWeight = this.weight / amount;
            var newWeight = (singleWeight * amount).toFixed(2);
            var name = this.item;
            // (container, id, name, amount, weight, image, description)
            addItem(container, getRandomInt(999999), name, amount, newWeight, this.item, this.description, this.displayname.single, this.displayname.plural, this.uid, JSON.stringify(this.metadata));
        }

    });

    // Add Weapons
    jQuery.each(inventory.weapons, function(item) {
        if ($('.item[data-uid=' + this.uid + ']').length > 0) {
            var amount = this.amt;
            var singleWeight = this.weight / amount;
            var newWeight = (singleWeight * amount).toFixed(2);
            $('.item[data-uid=' + this.uid + ']')
                .data('amount', amount)
                .data('weight', newWeight)
                .find(".amount").html('<i class="fas fa-hashtag"></i>' + newAmount + '');

            $('.item[data-uid=' + this.uid + ']')
                .find(".weight").html('<i class="fas fa-weight-hanging"></i>' + newWeight + '');
        } else {
            var amount = this.amt;
            var singleWeight = this.weight / amount;
            var newWeight = (singleWeight * amount).toFixed(2);
            var name = this.item;
            // (container, id, name, amount, weight, image, description)
            addItem(container, getRandomInt(999999), name, amount, newWeight, this.item, this.description, this.displayname.single, this.displayname.plural, this.uid, JSON.stringify(this.metadata));
        }
    });


    updateWeight();
}

function removeItems(ids) {
    jQuery.each(ids, function(i, id) {
        $('.item[data-uid=' + id + ']').remove();
    });
}

function clearInventory(container = 'right') {
    $('#' + container).empty();
    updateWeight();
}

function removePanel(container = 'right') {
    $('.col-' + container).fadeOut();
}

function showPanel(container = 'right') {
    console.log("showPanel: " + container);
    $('.col-' + container).fadeIn();
}


function updateWeight() {

    $(".inventory").each(function(index) {
        var weight = 0;
        $(this).find('.item').each(function(i) {
            if (!$(this).hasClass('gu-mirror')) {
                weight = parseFloat(weight) + parseFloat($(this).data('weight'));
            }
        });
        var inventory = index + 1;
        if (inventory == 1) {
            // Change weights for launch
            if (weight.toFixed(2) > 80) {
                var color = 'red';
            } else if (weight.toFixed(2) > 60) {
                var color = 'orange';
            } else {
                var color = 'green';
            }
            $('.inventory-' + inventory + '-weight').html('<span class="color-' + color + '"><i class="fas fa-weight-hanging"></i>' + weight.toFixed(2) + ' lbs</span>');
        } else {
            $('.inventory-' + inventory + '-weight').html('<i class="fas fa-weight-hanging"></i>' + weight.toFixed(2) + ' lbs');
        }
        weight = 0;
    });
    if ($('#hand').hasClass('occupied')) {
        $('.inventory-hand-weight').html('<i class="fas fa-weight-hanging"></i>' + $('.in-hand').data('weight') + ' lbs');
    } else {
        $('.inventory-hand-weight').html('<i class="fas fa-weight-hanging"></i>0 lbs');
    }
}

function clearHand() {
    $('#hand').removeClass('occupied');
    $('.in-hand').appendTo('#left');
    $('.in-hand').removeClass('in-hand');
    $('.description-text').html('');
    $('#input-amount').val(1);
}

function disableInput() {
    $('.btn').addClass('disabled');
    $('.btn').attr('disabled', true);
}

function enableInput() {
    $('.btn:disabled').removeClass('disabled');
    $('.btn:disabled').attr('disabled', false);
}

function selectItem(item, from) {
    updateWeight();
    // $('#selected-option').html('');
    if ($('#hand').hasClass('occupied') && $(item).hasClass('in-hand')) {
        //revert to left
        moveItem(item, 'left', from);
        $(item).removeClass('in-hand');
        $('#hand').removeClass('occupied');
        $('.description-text').html('');
        disableInput();
        updateWeight();
    } else {
        clearHand();
        selectedName = $(item).data('name');
        selectedAmount = $(item).data('amount');
        selectedId = $(item).data('id');

        enableInput();
        updateWeight();

        moveItem(item, 'hand', from);
        $('.description-text').html($(item).data('description'));
        var metadata = $(item).data('metadata');
        if (metadata.isUsable === false) {
            $('.use-button').attr('disabled', true);
        } else {
            $('.use-button').attr('disabled', false);
        }
    }
}

function mergeItem(item) {
    var metadata = $(item).data('metadata');
    selectedId = $(item).data('id');
    if (metadata.canStack === false) {
        containers.cancel(true);
        return false;
    }
    var inHand = $('.in-hand');
    var id = inHand.data('id');

    var newAmount = inHand.data('amount') + $(item).data('amount');
    var newWeight = parseFloat(inHand.data('weight')) + parseFloat($(item).data('weight'));
    selectedAmount = newAmount;
    inHand.remove();
    $(item).remove();

    addItem('left', inHand.data('id'), inHand.data('name'), newAmount, newWeight.toFixed(2), inHand.data('image'), inHand.data('description'), inHand.data('singular'), inHand.data('plural'), inHand.data('uid'), JSON.stringify(inHand.data('metadata')));
    clearHand();
    selectItem($('.item[data-id="' + id + '"]'), 'left');
    updateWeight();

    $.post('http://soe-inventory/mergeItem', JSON.stringify({
        item: inHand.data('name'),
        oldAmt: $(item).data('amount'),
        newAmt: newAmount,
        oldUID: $(item).data('uid'),
        newUID: inHand.data('uid')
    }));
}

function dropItem(item, amount) {
    updateWeight();
    $.post('http://soe-inventory/dropItem', JSON.stringify({
        item: $(item).data('name'),
        amt: amount,
        uid: $(item).data('uid')
    }));
    $.post('http://soe-inventory/handleUI', JSON.stringify({
        close: true
    }));
    $('.wrapper').fadeOut();
    $('#left').empty();
    $('#right').empty();
    $('#hand').empty();
    clearHand();
    disableInput();
}

function moveItem(item, container, from) {
    if (container == 'hand') {
        clearHand();
        $(item).addClass('in-hand');
        $('#hand').addClass('occupied');
        $('.description-text').html($(item).data('description'));
        $(item).appendTo('#' + container);
        enableInput();
    } else {
        if ($(item).hasClass('in-hand')) {
            clearHand();
            $(item).appendTo('#' + container);
        } else {
            $(item).removeClass('in-hand');
            $(item).appendTo('#' + container);
        }
    }
    $.post('http://soe-inventory/moveItem', JSON.stringify({
        uid: $(item).data('uid'),
        amt: Number($(item).data('amount')),
        item: $(item).data('name'),
        fromContainer: from,
        toContainer: container
    }));
    updateWeight();
}

function splitItem(item, amount, container = 'left') {
    var newAmount = $('.item[data-id="' + selectedId + '"]').data('amount') - amount;
    var itemWeight = $('.item[data-id="' + selectedId + '"]').data('weight') / $('.item[data-id="' + selectedId + '"]').data('amount');
    var newWeight = (itemWeight * newAmount).toFixed(2);
    var cloneWeight = (itemWeight * amount).toFixed(2);
    var displayName = newAmount == 1 ? $('.item[data-id="' + selectedId + '"]').data('singular') : $('.item[data-id="' + selectedId + '"]').data('plural');
    var randomUID = String(Date.now()) + String(CHARID) + String(getRandomInt(999999));
    selectedAmount = newAmount;

    $('.item[data-id="' + selectedId + '"]')
        .data('amount', newAmount)
        .data('weight', newWeight)
        .find(".amount").html('<i class="fas fa-hashtag"></i>' + newAmount + '');

    $('.item[data-id="' + selectedId + '"]')
        .find(".weight").html('<i class="fas fa-weight-hanging"></i>' + newWeight + '');


    $('.item[data-id="' + selectedId + '"]').find(".name").text(displayName);
    $.post('http://soe-inventory/updateItem', JSON.stringify({
        oldUID: $('.item[data-id="' + selectedId + '"]').attr('data-uid'),
        newUID: randomUID,
        newAmt: $('#input-amount').val(),
        oldAmt: newAmount,
        item: $('.item[data-id="' + selectedId + '"]').attr('data-name')

    }));
    addItem(container, getRandomInt(999999), $('.item[data-id="' + selectedId + '"]').attr('data-name'), $('#input-amount').val(), cloneWeight, $('.item[data-id="' + selectedId + '"]').attr('data-image'), $('.item[data-id="' + selectedId + '"]').attr('data-description'), $('.item[data-id="' + selectedId + '"]').attr('data-singular'), $('.item[data-id="' + selectedId + '"]').attr('data-plural'), randomUID, $('.item[data-id="' + selectedId + '"]').attr('data-metadata'));

    clearHand();
    selectItem($('.item[data-id="' + selectedId + '"]'), 'left');
    updateWeight();

}

function useItem(item) {
    // Use Item Logic Here
    var metadata = $(item).data('metadata');
    selectedId = $(item).data('id');
    if (metadata.isUsable === false) {
        return false;
    }

    // var newAmount = parseInt($(item).data('amount'));
    var newAmount = 0 - parseInt($('#input-amount').val());

    console.log(newAmount);

    // if (metadata.consumeOnUse !== false) {
    //     console.log("consumeOnUse");
    //     newAmount = 0 + parseInt($('#input-amount').val());
    //     var itemWeight = $('.item[data-id="' + selectedId + '"]').data('weight') / $('.item[data-id="' + selectedId + '"]').data('amount');
    //     var newWeight = (itemWeight * newAmount).toFixed(2);
    // } else {
    //     var newAmount = parseInt($(item).data('amount'));
    // }


    $.post('http://soe-inventory/useItem', JSON.stringify({
        uid: $('.item[data-id="' + selectedId + '"]').attr('data-uid'),
        amt: newAmount,
        item: $('.item[data-id="' + selectedId + '"]').attr('data-name')
    }));

    $.post('http://soe-inventory/handleUI', JSON.stringify({
        close: true
    }));
    $('.wrapper').fadeOut();
    $('#left').empty();
    $('#right').empty();
    $('#hand').empty();
    clearHand();
    disableInput();

    if (metadata.consumeOnUse !== false) {
        if (newWeight == 0) {
            //No more of item, remove
            $('.item[data-id="' + selectedId + '"]').remove();
            clearHand();
        } else {
            $('.item[data-id="' + selectedId + '"]')
                .data('amount', newAmount)
                .data('weight', newWeight)
                .find(".amount").html('<i class="fas fa-hashtag"></i>' + newAmount + '');

            $('.item[data-id="' + selectedId + '"]')
                .find(".weight").html('<i class="fas fa-weight-hanging"></i>' + newWeight + '');
        }
    }
}

function addItem(container, id, name, amount, weight, image, description, singular, plural, uid, metadata = '{}') {
    var nameDisplay = amount > 1 ? plural : singular;
    var data = JSON.parse(metadata);
    if (name == 'cellphone') {
        var primary = 'phone-' + data.isPrimaryPhone;
        $('#' + container).append('<div class="item '+primary+'" data-toggle="tooltip" title="' + nameDisplay + '" data-id="' + id + '" data-name="' + name + '" data-image="' + image + '" data-amount="' + amount + '" data-weight="' + weight + '" data-description="' + description + '" data-singular="' + singular + '" data-plural="' + plural + '" data-uid="' + uid + '" data-metadata=\'' + metadata + '\'><img src="images/' + data.phoneStyle + '.png" alt=""><div class="amount"><i class="fas fa-hashtag"></i>' + amount + '</div><div class="weight"><i class="fas fa-weight-hanging"></i>' + weight + '</div><div class="name">' + nameDisplay + '</div></div>');
    } else {
        $('#' + container).append('<div class="item" data-toggle="tooltip" title="' + nameDisplay + '" data-id="' + id + '" data-name="' + name + '" data-image="' + image + '" data-amount="' + amount + '" data-weight="' + weight + '" data-description="' + description + '" data-singular="' + singular + '" data-plural="' + plural + '" data-uid="' + uid + '" data-metadata=\'' + metadata + '\'><img src="images/' + image + '.png" alt=""><div class="amount"><i class="fas fa-hashtag"></i>' + amount + '</div><div class="weight"><i class="fas fa-weight-hanging"></i>' + weight + '</div><div class="name">' + nameDisplay + '</div></div>');
    }
    
    updateWeight();
}

function makePopup(title, max, callback) {
    $('.confirm-button').unbind('click');
    $('.confirm-button').addClass('disabled');
    $('.confirm-button').attr('disabled', true);
    $('.popup-value').val('');
    $('.popup-value').attr('maxlength', max);
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
    $('.confirm-button').click(callback);
    $('.cancel-button').click(function() {
        $('.popup-value').val('');
        $('.popup').fadeOut();
    });
}

function itemAlert(item, amount, type, displayname) {
    if (type == 'remove') {
        var icon = "-";
    } else {
        var icon = "+";
    }
    var id = getRandomInt(9999);
    $('.alert-container').append('<div id="' + id + '" class="alert-item" style="display:none;"><img src="images/' + item + '.png">' + icon + ' ' + amount + ' ' + displayname + '</div>');
    $('#' + id).fadeIn();
    setTimeout(function() { $('#' + id).fadeOut(); }, 5000);
}

function fillTable(data, title = 'Title') {
    $('.datatable-title-left').html(title);
    data = JSON.parse(JSON.stringify(data));
    dataTable.clear();
    // Add Items
    jQuery.each(data.entries, function(item) {
        var dateString = getDateString(this.bookingDate * 1000)
        var itemName = null;

        if (this.bookingDisplayName != null) {
            itemName = titleCase(this.bookingDisplayName)
        }

        var bookingItem = this.bookingItem || 'Not Found';
        var tagNumber = this.tagNumber || 'Not Found';
        var bookingDate = dateString || 'Not Found';
        var bookingOfficer = this.bookingOfficer || 'Not Found';
        var bookingDepartment = this.bookingDepartment || 'Not Found';
        var bookingLocation = this.bookingLocation || 'Not Found';
        var bookingAmt = this.bookingAmt || 'Not Found';
        var bookingEventNumber = this.bookingEventNumber || 'Not Found';
        var bookingDisplayName = itemName || 'Not Found';
        dataTable.row.add(['<img src="images/' + bookingItem + '.png" alt="">', tagNumber, bookingDisplayName, bookingAmt, bookingLocation, bookingOfficer, bookingDepartment, bookingEventNumber, bookingDate]).draw(true);
    });
    $('.table-container').fadeIn();
}

function getDateString(unixTime) {
    var date = new Date(unixTime + 7200000); //GETS EST TIME

    var month = date.getMonth() + 1;
    if (month.toString().length < 2) {
        month = "0" + month;
    }

    var day = date.getDate();
    if (day.toString().length < 2) {
        day = "0" + day;
    }

    var year = date.getFullYear();


    var hour = date.getHours() + 1;
    if (hour.toString().length < 2) {
        hour = "0" + hour;
    }

    var minute = date.getMinutes() + 1;
    if (minute.toString().length < 2) {
        minute = "0" + minute;
    }

    var second = date.getSeconds() + 1;
    if (second.toString().length < 2) {
        second = "0" + second;
    }

    var stringDate = month + "-" + day + "-" + year + " " + hour + ":" + minute + ":" + second;

    return stringDate;
}

function titleCase(str) {
    var splitStr = str.toLowerCase().split(' ');
    for (var i = 0; i < splitStr.length; i++) {
        // You do not need to check if i is larger than splitStr length, as your for does that for you
        // Assign it back to the array
        splitStr[i] = splitStr[i].charAt(0).toUpperCase() + splitStr[i].substring(1);
    }
    // Directly return the joined string
    return splitStr.join(' ');
}

// Variables
var selectedName = '';
var selectedAmount = 0;
var selectedId = 0;
var containers = dragula([document.querySelector('#left'), document.querySelector('#right'), document.querySelector('#hand')], {
    revertOnSpill: true,
    accepts: function(el, target, source) {
        if ($(target).hasClass('occupied')) {
            if ($('.in-hand').data('name') == $(el).data('name')) {
                return true;
            } else {
                return false;
            }
        } else {
            return true;
        }
    },
});

if ($("#data-table")[0]) {
    var dataTable = $("#data-table").DataTable({
        autoWidth: !1,
        responsive: !0,
        stateSave: true,
        stateDuration: 60,
        order: [
            [1, "desc"]
        ],
        lengthMenu: [
            [15, 30, 45, -1],
            ["15 Rows", "30 Rows", "45 Rows", "Everything"]
        ],
        language: {
            searchPlaceholder: "Search..."
        },
        sDom: '<"dataTables__top"flB>rt<"dataTables__bottom"ip><"clear">',
        initComplete: function() {}
    })
}
$('div.dataTables_length select').addClass('bg-dark-blue');

$(function() {
    // Events
    containers.on('drop', function(el, target, source) {
        var from = source.id;
        var to = target.id;
        if ($(target).hasClass('occupied') && $(el).data('name') != $('.in-hand').data('name')) {
            containers.cancel(true);
        } else if (from == "right" && to == "hand") {
            containers.cancel(true);
        } else if ($(target).attr('id') == 'hand') {
            if ($(el).data('name') == $('.in-hand').data('name')) {
                mergeItem(el);
                updateWeight();
            } else {
                selectItem(el, from);
                updateWeight();
            }
        } else {
            if ($(el).hasClass('in-hand')) {
                clearHand();
                moveItem(el, to, from);
                updateWeight();

                disableInput();
            } else {
                if (target.id != source.id) {
                    moveItem(el, to, from);
                    updateWeight();
                }
            }
        }

        updateWeight();
    });

    // DROP WHEN OUT OF CONTAINER
    // containers.on('cancel', function(el, target, source) {
    //  if(source.id == 'left'){
    //      dropItem(el);
    //  }
    // });


    $('#left').on('contextmenu', '.item', function(el) {
        el.preventDefault();
        //if (el.shiftKey) {
        //    if ($(this).parent().attr("id") == 'right') {
        //        moveItem(this, 'left', 'right');
        //    } else {
        //        if ($('#right').is(":visible")) {
        //            moveItem(this, 'right', 'left');
        //        }
        //    }
        //} else 
        if (el.ctrlKey) {
            dropItem(this, $(this).data('amount'));
        } else {
            if ($(this).data('name') == $('.in-hand').data('name')) {
                mergeItem(this);
            } else {
                selectItem(this, 'left');
            }
        }

        updateWeight();
    });

    $('#right').on('contextmenu', '.item', function(el) {
        el.preventDefault();
        //if (el.shiftKey) {
        //    if ($(this).parent().attr("id") == 'right') {
        //        moveItem(this, 'left', 'right');
        //    } else {
        //        moveItem(this, 'right', 'left');
        //    }
        //} else 
        if (el.ctrlKey) {
            //dropItem(this, $(this).data('amount'));
        } else {
            //if ($(this).data('name') == $('.in-hand').data('name')) {
            //    mergeItem(this);
            //} else {
            //    selectItem(this, 'right');
            //}
        }

        updateWeight();
    });

    $('.options').on('contextmenu', '.item', function(el) {
        el.preventDefault();
        selectItem(this, 'hand');
        updateWeight();
    });

    $('#left').on('dblclick', '.item', function(el) {
        useItem(el.currentTarget);
    });
    $('.options').on('dblclick', '.item', function(el) {
        //useItem(el.currentTarget);
    });

    $('.drop-button').on('click', function(el) {
        // DROP ITEM
        if ($('#input-amount').val() > selectedAmount) {
            $.post('http://soe-inventory/notEnough', JSON.stringify({}));
        } else {
            dropItem($('.item[data-id="' + selectedId + '"]'), $('#input-amount').val());
        }
    });

    $('.give-button').on('click', function(el) {
        // GIVE ITEM
        if ($('#input-amount').val() > selectedAmount) {
            $.post('http://soe-inventory/notEnough', JSON.stringify({}));
        } else {
            // GIVE LOGIC
            makePopup('Enter Player ID', 3, function() {
                if ($('.popup-value').val()) {
                    // Value given - do give

                    $.post('http://soe-inventory/giveItem', JSON.stringify({
                        uid: $('.item[data-id="' + selectedId + '"]').attr('data-uid'),
                        item: $('.item[data-id="' + selectedId + '"]').attr('data-name'),
                        amt: $('#input-amount').val(),
                        toID: $('.popup-value').val()
                    }));

                    $.post('http://soe-inventory/handleUI', JSON.stringify({
                        close: true
                    }));
                    $('.wrapper').fadeOut();
                    $('#left').empty();
                    $('#right').empty();
                    $('#hand').empty();
                    clearHand();
                    disableInput();
                }
                $('.popup').fadeOut();
            });
        }
    });
    $('.use-button').on('click', function(el) {
        // USE ITEM
        if ($('#input-amount').val() > selectedAmount) {
            // NOT ENOUGH
        } else {
            useItem($('.item[data-id="' + selectedId + '"]'));
        }
    });

    $('.split-button').on('click', function(el) {
        // SPLIT ITEM
        if ($('#input-amount').val() >= selectedAmount) {
            // NOT ENOUGH
        } else {
            splitItem(el, $('#input-amount').val());
            updateWeight();
        }
    });

    $('.min-button').on('click', function(el) {
        $('#input-amount').val(1);
    });
    $('.half-button').on('click', function(el) {
        $('#input-amount').val(Math.round(selectedAmount / 2));
    });
    $('.max-button').on('click', function(el) {
        $('#input-amount').val(selectedAmount);
    });


    window.addEventListener('message', function(event) {
        if (event.data.type == "showinv") {
            $('.wrapper').fadeIn();
            clearHand();
            disableInput();
            CHARID = event.data.charID;
            syncInventory(event.data.inv, event.data.container, event.data.title);
        } else if (event.data.type == "removeItem") {
            removeItems(event.data.removedItems);
        } else if (event.data.type == "hidePanel") {
            removePanel(event.data.panel);
        } else if (event.data.type == "showPanel") {
            showPanel(event.data.panel);
        } else if (event.data.type == "sendAlert") {
            if (event.data.amt >= 0) {
                itemAlert(event.data.item, event.data.amt, "add", event.data.displayname)
            } else {
                itemAlert(event.data.item, Math.abs(event.data.amt), "remove", event.data.displayname)
            }
        } else if (event.data.type == "sendEvidence") {
            fillTable(event.data.evidenceTable, "San Andreas Department of Justice Evidence Management Application")
        }
    });

    $(document).on('keydown', function(event) {
        // if (event.key == "Escape") {
        //     $.post('http://soe-inventory/handleUI', JSON.stringify({
        //         close: true
        //     }));
        //     $('.wrapper').fadeOut();
        //     $('.table-container').fadeOut();
        //     $('#left').empty();
        //     $('#right').empty();
        //     $('#hand').empty();
        //     $('.popup').fadeOut();
        //     clearHand();
        //     disableInput();
        // }
        if (event.key == "F7") {
            $.post('http://soe-inventory/handleUI', JSON.stringify({
                close: true
            }));
            $('.wrapper').fadeOut();
            $('.table-container').fadeOut();
            $('#left').empty();
            $('#right').empty();
            $('#hand').empty();
            $('.popup').fadeOut();
            clearHand();
            disableInput();
        }
    });

    // REMOVE ME AFTER DEV
    if (DEBUG) {
        $('.dev-text').show();

        $('.inventory').on('click', '.item', function(el) {
            devText('DEBUG ~ item: ' + $(this).data('name') + ' | uid: ' + $(this).data('uid') + ' | amount: ' + $(this).data('amount') + ' | weight: ' + $(this).data('weight') + ' | description: ' + $(this).data('description'));

        });
    }

    updateWeight();
    removePanel("right");

    // syncInventory({ "items": [{ "uid": 15937414949303359680, "item": "cellphone", "displayname": { "single": "Bottle of water", "plural": "Bottles of water where the title is too long" }, "amt": 35, "weight": 0.7, "description": "Hydration in a bottle", "metadata": {"phoneIMEI": 1276260329, "phoneOwner": "Nick Major", "phoneStyle": "blue", "phoneNumber": "555-264-9985", "phoneVolume": 5, "isPrimaryPhone": true} }, { "uid": 8232, "item": "water", "displayname": { "single": "Bottle of water", "plural": "Bottles of water" }, "amt": 35, "weight": 0.7, "description": "Hydration in a bottle", "metadata": {} }, { "uid": 323, "item": "multitool", "displayname": { "single": "Multitool", "plural": "Bag of multitools" }, "amt": 1, "weight": 10, "description": "What could this be used for?", "metadata": { "consumeOnUse": false, "isUsable": false } }], "weapons": [{ "uid": 963, "item": "pistol", "displayname": { "single": "9mm pistol", "plural": "9mm pistols" }, "amt": 1, "weight": 8, "description": "9mm pistol with a small red dot sight", "metadata": {} }], "cash": 200, "id": "Paul Bamber | 11-28-1990 | 555-18456 | Richman Mansion" }, 'left', 'My Inventory');
});