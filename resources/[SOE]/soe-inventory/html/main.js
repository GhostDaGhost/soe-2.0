var devData = {
	"inventory1": {
		"items": [
			{
				"weight": 0.002,
				"metadata": "{}",
				"uid": "34",
				"amt": 1,
				"item": "cash",
				"description": "Cold hard cash.",
				"displayname": {
					"plural": "Dollars Cash",
					"single": "Dollar Cash"
				}
			},
			{
				"weight": 0.006,
				"metadata": "{}",
				"uid": "35",
				"amt": 3,
				"item": "cash",
				"description": "Cold hard cash.",
				"displayname": {
					"plural": "Dollars Cash",
					"single": "Dollar Cash"
				}
			},
			{
				"weight": 0.002,
				"metadata": "{}",
				"uid": "33",
				"amt": 1,
				"item": "cash",
				"description": "Cold hard cash.",
				"displayname": {
					"plural": "Dollars Cash",
					"single": "Dollar Cash"
				}
			},
			{
				"weight": 2.037,
				"metadata": "{}",
				"uid": "32",
				"amt": 7,
				"item": "lockpick",
				"description": "A tool used to enter locked objects and vehicles.",
				"displayname": {
					"plural": "Lockpicks",
					"single": "Lockpick"
				}
			},
			{
				"weight": 0.4120000000000001,
				"metadata": "{}",
				"uid": "19",
				"amt": 206,
				"item": "cash",
				"description": "Cold hard cash.",
				"displayname": {
					"plural": "Dollars Cash",
					"single": "Dollar Cash"
				}
			},
			{
				"weight": 0.2,
				"metadata": "{}",
				"uid": "20",
				"amt": 100,
				"item": "cash",
				"description": "Cold hard cash.",
				"displayname": {
					"plural": "Dollars Cash",
					"single": "Dollar Cash"
				}
			}
		]
	},
	"inventory2": {
		"items": [
			{
				"weight": 0.002,
				"metadata": "{}",
				"uid": "54",
				"amt": 1,
				"item": "cash",
				"description": "Cold hard cash.",
				"displayname": {
					"plural": "Dollars Cash",
					"single": "Dollar Cash"
				}
			},
			{
				"weight": 0.006,
				"metadata": "{}",
				"uid": "55",
				"amt": 3,
				"item": "cash",
				"description": "Cold hard cash.",
				"displayname": {
					"plural": "Dollars Cash",
					"single": "Dollar Cash"
				}
			},
			{
				"weight": 0.002,
				"metadata": "{}",
				"uid": "53",
				"amt": 1,
				"item": "cash",
				"description": "Cold hard cash.",
				"displayname": {
					"plural": "Dollars Cash",
					"single": "Dollar Cash"
				}
			},
			{
				"weight": 2.037,
				"metadata": "{}",
				"uid": "52",
				"amt": 7,
				"item": "lockpick",
				"description": "A tool used to enter locked objects and vehicles.",
				"displayname": {
					"plural": "Lockpicks",
					"single": "Lockpick"
				}
			},
			{
				"weight": 0.4120000000000001,
				"metadata": "{}",
				"uid": "59",
				"amt": 206,
				"item": "cash",
				"description": "Cold hard cash.",
				"displayname": {
					"plural": "Dollars Cash",
					"single": "Dollar Cash"
				}
			},
			{
				"weight": 0.2,
				"metadata": "{}",
				"uid": "50",
				"amt": 100,
				"item": "cash",
				"description": "Cold hard cash.",
				"displayname": {
					"plural": "Dollars Cash",
					"single": "Dollar Cash"
				}
			}
		]
	}
}

// Events listener

window.addEventListener('message', function (event) {
	//console.log(event.data.type);
	switch (event.data.type) {
		// Show the inventory to the player
		case "ShowInventory":
			$('.wrapper').fadeIn();
			ClearHand(); // Reset hand UI to default
			ToggleInput(false); // Disable all buttons as no item selected yet

			// console.log(event.data.inventory, event.data.container, event.data.title);

			SyncInventory(event.data.inventory, event.data.container, event.data.title); // Sync inventory data to UI
			TogglePanel("right", false);
			TogglePanel(event.data.container, true);
			break;
		// Update the data within the inventory
		case "UpdateInventory":
			SyncInventory(event.data.inventory, event.data.container, event.data.title); // Sync inventory data to UI
			break;
		case "ClearInventory":
			TogglePanel(event.data.container, false);
			$('#' + event.data.container).html('');
		case "CloseInventory":
			CloseUI(event.data.reopen);
			break;
		case "ShowNotif":
			SendNotification(event.data.notifType, event.data.itemID, event.data.itemAmt, event.data.itemName);
			break;
	}
});

// Utilities

function TogglePanel(container = 'right', bool = true) {
	if (bool) {
		$('.col-' + container).fadeIn();
	} else {
		$('.col-' + container).fadeOut();
	}
}

function ClearHand() {
	$('#hand').removeClass('occupied');
	$('.in-hand').appendTo('#left');
	$('.in-hand').removeClass('in-hand');
	$('.description-text').html('');
	$('#input-amount').val(1);
}

function ToggleInput(bool) {
	if (bool) {
		$('.btn').removeClass('disabled');
	} else {
		$('.btn').addClass('disabled');
	}
	$('.btn').attr('disabled', bool);
}

function GetRandomInt(max) {
	return Math.floor(Math.random() * Math.floor(max) + 1);
}

function CloseUI(reopen) {
	var dataString = {};

	if (reopen) {
		dataString = {
			reopen: true
		};
	} else {
		dataString = {};
	}

	$.post('http://soe-inventory/CloseUI', JSON.stringify(dataString));

	$('.wrapper').fadeOut();
	$('#left').empty();
	$('#right').empty();
	$('#hand').empty();

	ClearHand();
	ToggleInput(false);
}

// INVENTORY ITEM NOTIFICATION
function SendNotification(type, itemID, itemAmt, displayName) {
    if (type == 'remove') {
        var icon = "-";
    } else {
        var icon = "+";
    }
    var id = GetRandomInt(9999);
	$('.alert-container').append(
		'<div id="' + id + '" class="alert-item" style="display:none;"><img src="images/' + itemID + '.png">' + icon + ' ' + itemAmt + ' ' + displayName + '</div>'
	);

    $('#' + id).fadeIn();
    setTimeout(function() { $('#' + id).fadeOut(); }, 5000);
}

// Inventory Sync
function SyncInventory(inventory, container = 'left', title = 'Inventory') {
	console.log("Syncing inventory");
	// Set title of inventory container
	$('.inventory-title-' + container).html(title);

	// console.log("Clearing container" + container);
	$('#' + container).html('');

	// Convert inventory JSON to Object
	inventory = JSON.parse(JSON.stringify(inventory));

	// Debug output (Object inventory)
	// console.log(inventory);

	// Process inventory items for UI
	$.each(inventory.items, function (item) {
		var amount = this.amt;
		var singleWeight = this.weight / amount;
		var newWeight = (singleWeight * amount).toFixed(2);
		var name = this.item;

		if ($('.item[data-uid=' + this.uid + ']').length > 0) {
			// Item already exists
			var singleWeight = this.weight / amount;
			var newWeight = (singleWeight * amount).toFixed(2);
			// console.log(amount);
			$('.item[data-uid=' + this.uid + ']')
				.data('amount', amount)
				.data('weight', newWeight)
				.find(".amount").html('<i class="fas fa-hashtag"></i>' + amount + '');

			$('.item[data-uid=' + this.uid + ']')
				.find(".weight").html('<i class="fas fa-weight-hanging"></i>' + newWeight + '');
		} else {
			// Add item to UI
			AddItem(container, GetRandomInt(999999), name, amount, newWeight, this.item, this.description, this.displayname.single, this.displayname.plural, this.uid, JSON.stringify(this.metadata), this.canUse);
		}
	});

	UpdateWeight();
}

// Render item into inventory
function AddItem(container = 'left', id, name, amount, weight, image, description, singular, plural, uid, metadata = '{}', canUse) {
	// Debug output
	// console.log("Creating item " + name + " (" + amount + ") - " + container);

	var displayname = amount > 1 ? plural : singular;
	var metadata = JSON.parse(metadata);

	// Create item from template
	container = $('#' + container);
	var template = $("#inventory-item-template").clone();

	// Data attributes
	template.attr('data-id', id);
	template.attr('title', displayname);
	template.attr('data-name', name);
	template.attr('data-weight', weight);
	template.attr('data-description', description);
	template.attr('data-metadata', metadata);
	template.attr('data-singular', singular);
	template.attr('data-plural', plural);
	template.attr('data-uid', uid);
	template.attr('data-amount', amount);
	template.attr('data-use', canUse);

	metadata = JSON.parse(metadata);
	// Handle custom attributes for defined items
	switch (name) {
		case 'cellphone':
			// template.find('img').attr('src', "images/" + data.phoneStyle + ".png");
			// console.log(metadata);
			if (metadata.isPrimaryPhone && metadata.isPrimaryPhone == true) {
				// console.log("isPrimary: " + metadata.phoneNumber);
				template.addClass('item-primary');
			} else {
				//   console.log("else");
			}

			if (metadata.phoneStyle) {
				image = metadata.phoneStyle;
			}
			break;
		default:
			// Default item content

			// IF WEAPON IS EQUIPPED, MARK IT
			if (metadata.equipped) {
				//console.log("WEAPON: isPrimary: " + metadata.equipped);
				template.addClass('weapon-primary');
			}
			break;
	}
	template.attr('data-image', image);

	template.find('img').attr('src', "images/" + image + ".png");
	template.find('.amount').html('<i class="fas fa-hashtag" aria-hidden="true"></i> ' + amount);
	template.find('.weight').html('<i class="fas fa-weight-hanging" aria-hidden="true"></i> ' + weight);
	template.find('.name').html(displayname);

	// Append to container and show new item
	template.appendTo(container);
	template.show();
}

// Update weight of inventory
function UpdateWeight() {
	$(".inventory").each(function (index) {
		var weight = 0;
		$(this).find('.item').each(function (i) {
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

// Inventory Interactions

function MoveItem(item, container, from, amount) {
	// console.log("MoveItem")

	switch (container) {
		case 'hand':
			// console.log("Hand")
			ClearHand();
			$(item).addClass('in-hand');
			$('#hand').addClass('occupied');
			$('.description-text').html($(item).data('description'));

			$(item).appendTo('#' + container);

			ToggleInput(true); // Enable input
			break;
		default:
			// console.log("Default")
			if ($(item).hasClass('in-hand')) {
				ClearHand();
				$(item).appendTo('#' + container);
			} else {
				$(item).removeClass('in-hand');
				$(item).appendTo('#' + container);
			}
			break;
	}

	var dataString = JSON.stringify({
		uid: $(item).data('uid'),
		item: $(item).data('name'),
		fromContainer: from,
		toContainer: container,
		amount: amount
	});
	$.post('http://soe-inventory/MoveItem', dataString)
}

function SelectItem(item, from) {
	// Check if item selected is in hand
	if ($('#hand').hasClass('occupied') && $(item).hasClass('in-hand')) {
		// Default item to character inventory (left panel)
		MoveItem(item, 'left', from, $(item).data('amount'));
		$(item).removeClass('in-hand');
		$('#hand').removeClass('occupied');
		$('.description-text').html('');
		ToggleInput(false);
	} else {
		// console.log("Selected item is not in-hand")
		ClearHand();
		selectedName = $(item).data('name');
		selectedAmount = $(item).data('amount');
		selectedId = $(item).data('id');

		ToggleInput(true);
		MoveItem(item, 'hand', from, selectedAmount);

		// $('.description-text').html($(item).data('description'));

		switch ($(item).data('name')) {
			case "cellphone":
				$('.description-text').html($(item).data('description') + "<br><br>Number: " + $(item).data('metadata').phoneNumber + "<br>IMEI: " + $(item).data('metadata').phoneIMEI);
				break;
			case "bankcard":
				$('.description-text').html($(item).data('description') + "<br><br>Card Number: " + "xx-" + $(item).data('metadata').cardnumber.toString().slice(-4) + "<br><br>Name: " + $(item).data('metadata').firstnames.split(" ").map((n) => n[0]).join(" ") + " " + $(item).data('metadata').surname.toUpperCase() + "<br><br>Account: " + ($(item).data('metadata').accountnumber || `00000000`));
				break
		}

		// var metadata = $(item).data('metadata');
		if ($(item).data('use') == false) {
			$('.use-button').attr('disabled', true);
		} else {
			$('.use-button').attr('disabled', false);
		}

		$('.split-button').attr('disabled', false);
	}
	UpdateWeight();
}

function MergeItem(item) {
	// console.log("Merge item");

	var metadata = $(item).data('metadata');

	// Check if item can stack
	if (metadata.canStack == false) {
		containers.cancel(true);
		return false;
	}

	var dataString = JSON.stringify({
		itemid1: $(item).data('uid'),
		itemid2: $('.in-hand').data('uid')
	});

	$.post('http://soe-inventory/MergeItem', dataString).done(function (data) {
		if (data.status) {
			// console.log("Item merged successfully.");

			$('.in-hand').remove();

			$('.item', $('#hand')).addClass('in-hand');
			// ClearHands();

			// SelectItem($('.item[data-id="' + id + '"]'), 'left');
			// AddItem('left', inHand.data('id'), inHand.data('name'), newAmount, newWeight.toFixed(2), inHand.data('image'), inHand.data('description'), inHand.data('singular'), inHand.data('plural'), inHand.data('uid'), JSON.stringify(inHand.data('metadata')));
			UpdateWeight();

			return true;
		} else {
			console.error("An error occured when merging an item.");
			CloseUI(false);
			return false;
		}
	});
}

function SplitItem(itemId, itemAmt) {
	// console.log("itemId", itemId);
	// console.log("itemAmt", itemAmt);
	var dataString = JSON.stringify({
		// id: $('.in-hand').data('uid'),
		itemAmt: itemAmt,
		itemId: itemId,
	});

	$.post('http://soe-inventory/SplitItem', dataString).done(function (data) {
		if (data.status) {
			return true;
		} else {
			console.error("An error occured when splitting an item.");
			CloseUI(false);
			return false;
		}
	});
}

function dropItem(item, amount) {
	UpdateWeight();
	$.post('http://soe-inventory/dropItem', JSON.stringify({
		item: $(item).data('name'),
		amt: amount,
		uid: $(item).data('uid')
	}));

	UpdateWeight();

	CloseUI();
	$('.wrapper').fadeOut();
	$('.table-container').fadeOut();
	$('#left').empty();
	$('#right').empty();
	$('#hand').empty();
	$('.popup').fadeOut();
	ClearHand();
	ToggleInput(false);
}

// Dragula (Drag + Drop library for item moving)

// Variables
var selectedName = '';
var selectedAmount = 0;
var selectedId = 0;

var inHandFrom = '';

var containers = dragula([document.querySelector('#left'), document.querySelector('#right'), document.querySelector('#hand')], {
	revertOnSpill: true,
	accepts: function (el, target, source) {
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

// Handle dropped event when item moves between inventory
containers.on('drop', function (el, target, source) {
	var from = source.id;
	var to = target.id;

	if ($(target).hasClass('occupied') && $(el).data('name') != $('.in-hand').data('name')) {
		// If target is occupied, and item is not the same type as item in hand
		containers.cancel(true); // Cancel item move
		// } else if (from == "right" && to == "hand") {
		//     containers.cancel(true);
	} else if ($(target).attr('id') == 'hand') {
		// If target is the hand slot
		inHandFrom = from;
		if ($(el).data('name') == $('.in-hand').data('name')) {
			// If item in hand is the same as item being moved, then merge items
			MergeItem(el);
			UpdateWeight(); // Update inventory weight
		} else {
			// If not, item in hand to item being moved
			// console.log("to: hand");
			SelectItem(el, from);
			UpdateWeight(); // Update inventory weight
		}
	} else {
		if ($(el).hasClass('in-hand')) {
			// If item being moved is in hand slot
			ClearHand(); // Clear hand slot
			MoveItem(el, to, from, $(el).data('amount')); // Move item to desired inventory
			UpdateWeight(); // Update inventory weight

			ToggleInput(false);
		} else {
			if (target.id != source.id) {
				MoveItem(el, to, from, $(el).data('amount'));
				UpdateWeight(); // Update inventory weight
			}
		}
	}

	var inHandBool = false

	// Check if hand slot occupied
	if ($('.in-hand').length == 0) {
		inHandBool = true;
	}
	// Set button disabled state
	$('.min-button').attr('disabled', inHandBool);
	$('.half-button').attr('disabled', inHandBool);
	$('.max-button').attr('disabled', inHandBool);
	$('.drop-button').attr('disabled', inHandBool);

	UpdateWeight();
});

// Handle key interactions

$(document).on('keydown', function (event) {
	if (event.key == "Escape") {
		CloseUI();

		$('.wrapper').fadeOut();
		$('.table-container').fadeOut();
		$('#left').empty();
		$('#right').empty();
		$('#hand').empty();
		$('.popup').fadeOut();
		ClearHand();
		ToggleInput(false);
	}
	if (event.key == "F7") {
		CloseUI();

		$('.wrapper').fadeOut();
		$('.table-container').fadeOut();
		$('#left').empty();
		$('#right').empty();
		$('#hand').empty();
		$('.popup').fadeOut();
		ClearHand();
		ToggleInput(false);
	}
});

$('.split-button').on('click', function (el) {
	// SPLIT ITEM
	// console.log($('.in-hand').data());
	// console.log($('.in-hand').attr('amount'));
	if ($('#input-amount').val() >= $('.in-hand').data('amount')) {
		// NOT ENOUGH
		console.error("Not enough of item to split.");
	} else {
		SplitItem($('.in-hand').data('uid'), $('#input-amount').val());
		UpdateWeight();
	}
});

$('.min-button').on('click', function (el) {
	$('#input-amount').val(1);
});
$('.half-button').on('click', function (el) {
	// console.log( $('.in-hand').data() );
	$('#input-amount').val(Math.round($('.in-hand').data('amount') / 2));
});
$('.max-button').on('click', function (el) {
	$('#input-amount').val($('.in-hand').data('amount'));
});


$('.use-button').on('click', function (el) {
	UseItem($('.in-hand'), $('#input-amount').attr('value'));
});

$('.drop-button').on('click', function (el) {
	// DROP ITEM
	if ($('#input-amount').val() > selectedAmount) {
		//$.post('http://soe-inventory/notEnough', JSON.stringify({}));
	} else {
		dropItem($('.item[data-id="' + selectedId + '"]'), $('#input-amount').val());
	}
});

$('#left').on('dblclick', '.item', function (el) {
	if ($(el.currentTarget).parent().attr('id') == "left") {
		// console.log("use on double-click");
		UseItem(el.currentTarget, 1);
	} else {
		console.warn("Can't use items from right inventory.");
	}
});

function UseItem(el, qty) {
	// console.log(el);
	var dataString = JSON.stringify({
		amt: qty,
		uid: $(el).data('uid'),
		item: $(el).data('name'),
		parent: $(el).parent().attr('id')
	});

	$.post('http://soe-inventory/UseItem', dataString).done(function (data) {
		console.log(data.status)
		if (data.status) {
			CloseUI(false);
			return true;
		} else {
			console.error("An error occured when used an item.");
			CloseUI(false);
			return false;
		}
	});
}