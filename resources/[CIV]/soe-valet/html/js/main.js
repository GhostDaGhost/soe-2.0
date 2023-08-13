window.addEventListener('message', (event) => {
	let data = event.data
	switch(data.type) {
		case 'Valet.ShowUI':
			InitiateValetUI(data.garageName, data.garageData, data.charid);
			$("body").fadeIn();
			break;
		case 'Valet.ResetUI':
			CloseValetUI();
			console.log('[Valet] UI resetted.');
			break;
	}
});

function CloseValetUI() {
	$.post('https://soe-valet/Valet.CloseUI', JSON.stringify({}));
	$("body").fadeOut();
}

function InitiateValetUI(garageName, garageData, charid) {
	// CLEAR DATA TABLE || CHANGE GARAGE NAME
	$("#data-table").DataTable().clear().destroy();
	$(".valet-title-left").text(garageName.replace('Unknown Garage', ''));

	$.each(JSON.parse(JSON.stringify(garageData)), (id, vehicle) => {
		var engine = "";
		var engineClass = "";
		var body = "";
		var bodyClass = "";
		var status = "";
		var statusClass = "";
		var owned = '<i class="fas fa-check text-success"></i>'
		if (vehicle.EngineCondition > 10 && vehicle.EngineCondition <= 400) {
			engine = 'Unhealthy';
			engineClass = 'medium-damage';
		} else if (vehicle.EngineCondition <= 10) {
			engine = 'Immobile';
			engineClass = 'high-damage';
		} else {
			engine = 'Healthy';
			engineClass = 'no-damage';
		}

		if (vehicle.BodyCondition > 400 && vehicle.BodyCondition <= 800) {
			body = 'Damaged';
			bodyClass = 'low-damage';
		} else if (vehicle.BodyCondition > 10 && vehicle.BodyCondition <= 400) {
			body = 'Very Damaged';
			bodyClass = 'medium-damage';
		} else if (vehicle.BodyCondition <= 10) {
			body = "Wrecked";
			bodyClass = 'high-damage';
		} else {
			body = "Healthy";
			bodyClass = 'no-damage';
		}

		if (vehicle.IsOut) {
			status = "Checked Out";
			statusClass = "row-disabled";
		} else {
			status = "Parked";
		}

		if (vehicle.OwnerID != charid) {
			owned = '<i class="fas fa-times text-warning"></i>'
		}
		$("#data-table tbody").append('<tr class="' + statusClass + '" data-vehid="' + vehicle.VehicleID + '"><td>' + vehicle.VehicleID + '</td><td>' + vehicle.VehModel + '</td><td>' + vehicle.VehRegistration + '</td><td class="' + engineClass + '">' + engine + '</td><td class="' + bodyClass + '">' + body + '</td><td>' + Math.round(vehicle.Fuel) + ' gal</td><td>' + status + '</td><td>' + owned + '</td></tr>');
	});

	// Build the data table
	BuildTable();
}

$(document).on('keydown', (event) => {
	if (event.key == "Escape") {
		CloseValetUI();
	}
});

$("body").on("click", 'tbody tr', function () {
	if ($(this).hasClass('row-disabled')) {
		return false;
	}

	CloseValetUI();
	$.post('https://soe-valet/Valet.SelectVeh', JSON.stringify({
		vin: $(this).attr('data-vehid')
	}));
});

function BuildTable() {
	if ($("#data-table")[0]) {
		$("#data-table").DataTable({
			autoWidth: !1,
			responsive: !0,
			stateSave: false,
			order: [
				[0, "asc"]
			],

			language: {
				searchPlaceholder: "Search..."
			},
			sDom: '<"dataTables__top"flB>rt<"dataTables__bottom"ip><"clear">',
			initComplete: () => { }
		})
	}
	$("div.dataTables_length select").addClass("bg-dark-blue");
}
