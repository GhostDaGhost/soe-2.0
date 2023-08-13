// NUI EVENT LISTENER
window.onload = () => {
    window.addEventListener("message", (event) => {
        let data = event.data
        switch(data.type) {
            case "openLogs":
                InitiateLogMenu(data.logData);
                break;
            default:
                console.log("Invalid type passed to NUI (" + data.type + ")");
                break;
        }
    });
}

// CREATES MENU AND STARTS FILLING THE LOG MENU
function InitiateLogMenu(logData) {
    $("body").fadeIn();

	// CLEAR DATA TABLE
	$("#data-table").DataTable().clear().destroy();

    // FOR EACH LOG, ADD A COLUMN AND FILL IT WITH DATA
	$.each(JSON.parse(JSON.stringify(logData)), (logID, log) => {
		$("#data-table tbody").append('<tr><td>' + logID + '</td><td>' + log.ssn + '</td><td>' + log.name + '</td><td>' + log.dob + '</td><td>' + log.hospital + '</td><td>' + log.timestamp + '</td></tr>');
	});

    // BUILD DATA TABLE
	BuildTable();
}

// BUILDS DATA TABLE
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

// GENERAL INTERACTION FUNCTION
$(() => {
    // CLOSES UI WHEN 'ESCAPE' IS PRESSED
    $(document).on("keydown", (event) => {
        switch(event.key) {
            case "Escape":
                $("body").fadeOut();
                $.post("https://soe-healthcare/Logs.CloseUI", JSON.stringify({}));
                break;
        }
    });
})
