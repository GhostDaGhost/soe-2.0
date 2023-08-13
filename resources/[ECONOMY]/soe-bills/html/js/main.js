window.addEventListener("message", (event) => {
	switch(event.data.type) {
		case 'openBillsUI':
			billInit(event.data.billData);
			$("#bills-container").fadeIn();
			$("body").fadeIn();
			break;
		case 'openLoansUI':
			loanInit(event.data.loanData);
			$("#loans-container").fadeIn();
			$("body").fadeIn();
			break;
		case 'closeUI':
			CloseUI();
	}
});

function CloseUI() {
	$.post('https://soe-bills/closeUI', JSON.stringify({}));
	$("#bills-container").fadeOut();
	$("#loans-container").fadeOut();
	$("body").fadeOut();
}

function billInit(billData) {
	// CLEAR DATA TABLE || CHANGE GARAGE NAME
	$("#bills-table").DataTable().clear().destroy();
	$(".bills-title-left").text('My Bills');

	$.each(JSON.parse(JSON.stringify(billData)), function (billID, bill) {
		var dateDue = getDate(bill.BillDue);
		var dateNow = new Date().setHours(0, 0, 0, 0);
		var dueIn = Math.ceil((dateDue - dateNow) / (1000*60*60*24));

		var status = "Awaiting Payment";
		var statusClass = "awaiting"
		if (dueIn < -28) {
			status = "In Collections"
			var statusClass = "collections"
		} else if (dueIn < -14) {
			status = "Long Overdue"
			var statusClass = "overdue"
		} else if (dueIn < 0) {
			status = "Overdue"
			var statusClass = "overdue"
		} else if (dueIn == 0) {
			status = "Due Today"
			var statusClass = "soon"
		} else if (dueIn < 7) {
			status = "Due Soon"
			var statusClass = "soon"
		}

		$("#bills-table tbody").append('<tr><td>' + bill.BillID + '</td><td>$' + bill.BillAmt + '</td><td>' + buildDateString(dateDue) + '</td><td>' + dueIn + ' Day(s)</td><td>' + bill.BillNote + '</td><td class="' + statusClass + '">' + status + '</td><td><button type="button" class="btn btn-success" onclick="payBill(' + bill.BillID + ')">Pay Bill</button></td></tr>');
	});

	// Build the data table
	buildBillsTable();
}

function loanInit(loanData) {
	// CLEAR DATA TABLE || CHANGE GARAGE NAME
	$("#loans-table").DataTable().clear().destroy();
	$(".loans-title-left").text('My Loans');

	$.each(JSON.parse(JSON.stringify(loanData)), function (loanID, loan) {
		var startDate = getDate(loan.StartDate);
		var lastDate = getDate(loan.LastBill);
		$("#loans-table tbody").append('<tr><td>' + loan.LoanID + '</td><td>$' + loan.TotalBalance + '</td><td>$' + (loan.TotalBalance - loan.AmountPaid) + '</td><td>' + loan.Interval + ' </td><td>$' + loan.MinimumIntervalPayment + '</td><td>' + loan.Label + '</td><td>' + Math.round(loan.LoanAPR * 100) + '%</td><td>' + buildDateString(startDate) + '</td><td>' + buildDateString(lastDate) + '</td><td><button type="button" class="btn btn-success" onclick="payLoan(' + loan.LoanID + ')">Make A Payment</button></td></tr>');
	});

	// Build the data table
	buildLoansTable();
}

function payBill(billID) {
	console.log(billID);
	$.post('https://soe-bills/payBill', JSON.stringify({
		bill: billID
	}));
	$("#bills-container").fadeOut();
	$("body").fadeOut();
}

function payLoan(loanID) {
	console.log(loanID);
	$.post('https://soe-bills/payLoan', JSON.stringify({
		loan: loanID
	}));
	$("#loans-container").fadeOut();
	$("body").fadeOut();
}

function buildBillsTable() {
	if ($("#bills-table")[0]) {
		$("#bills-table").DataTable({
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
			initComplete: function () { }
		})
	}
	$("div.dataTables_length select").addClass("bg-dark-blue");
}

function buildLoansTable() {
	if ($("#loans-table")[0]) {
		$("#loans-table").DataTable({
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
			initComplete: function () { }
		})
	}
	$("div.dataTables_length select").addClass("bg-dark-blue");
}

$(document).on('keydown', function (event) {
	if (event.key == "Escape") {
		CloseUI();
	}
});

function getDate(sqlDate){
    var sqlDateArr = sqlDate.split("-");
    var year = sqlDateArr[0];
    var month = (Number(sqlDateArr[1]) - 1).toString();

	var sqlDateArr2 = sqlDateArr[2].split(" ");
    var day = sqlDateArr2[0];
     
    return new Date(year, month, day);
}

function buildDateString(date) {
	var strDate = (date.getMonth() + 1) + "/" + date.getDate() + "/" + date.getFullYear();
	return strDate;
}