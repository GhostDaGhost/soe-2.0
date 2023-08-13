// var ENV_ROUTE = 'dev.core.soe.gg';
var PHONE_IMEI;
var PHONE_NUMBER = '';
var PHONE_TEXTS = [];
var PHONE_EMAILS = [];
var PHONE_CALLS = [];
var PHONE_CONTACTS = [];
var PHONE_NOTES = [];
var PHONE_VEHICLES = [];
var PHONE_BANKACCOUNTS = [];
var PHONE_ADVERTS = [];
// var PHONE_CHARID = '';
var PHONE_BLEETERUSERNAME = '';
var PHONE_YELLOWPAGESUSERNAME = '';
// var PHONE_LIFEINVADERUSERNAME = '';
var PHONE_EMAILUSERNAME = '';
var PHONE_BLEETERID = '';
var PHONE_YELLOWPAGESID = '';
// var PHONE_LIFEINVADERID = '';
var PHONE_EMAILID = '';
var PHONE_ONCALL = 'false';
var PHONE_PIN;
var PHONE_LOCKED = true;
var PHONE_LOCKCOUNT = 0;
var PHONE_VOLUME = 0.1;
var BLEETER_VOLUME = 0.1;
var PHONE_LATESTBLEET;
var PHONE_NUMBEROFBLEETS = 0;
var PHONE_STATEDEBT = 0;

var PHONE_FIRST_UNLOCK = true;
var PHONE_UNLOCKEDIMEI;

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

function minutes_with_leading_zeros(dt) { 
	return (dt < 10 ? '0' : '') + dt;
}

var syncPhoneDebounce = false

function syncPhone(imei) {
	if (syncPhoneDebounce == false) {
		syncPhoneDebounce = true;

		console.log("syncPhone");

		var APICallback = PerformAPICallback('SyncDevice', JSON.stringify({
			imei: imei
		}));

		APICallback.then(function(result) {
			// console.log("response received");
			result = JSON.parse(result.response);

			// console.log(result);

			// Check if data exists in API callback
			if (result == null || result.status == false || result.data == null) {
				console.error("API callback failed.");
				hidePhone();
				return;
			}

			data = result.data;
			// console.log(data);

			PHONE_IMEI = data.IMEI;
			PHONE_NUMBER = data.DevicePhoneNumber;

			// Set device style
			changeColor(data.Style);
			customBackground(data.DeviceBackground);

			// Set phone number in settings
			$('.settings-my-number').text(PHONE_NUMBER);

			// Clear containers ready for data input
			$('.texts-container').html('');
			$('.call-history-container').html('');
			$('.contacts-container').html('');
			$('.app-bleeter .bleeter-feed').html('');
			$('.app-notes .notes-container').html('');
			$('.app-valet .vehicles-container').html('');
			$('.app-fleeca .accounts-container').html('');
			$('.app-emails .email-inbound-container').html('');
			$('.app-emails .email-outbound-container').html('');
			$('.fleeca-transfer-from').html('');
			$('.state-debt-bankaccount').html('');

			PHONE_VOLUME = data.Volume;
			BLEETER_VOLUME = data.BleeterVolume;

			setVolume(PHONE_VOLUME);
			setBleeterVolume(BLEETER_VOLUME);

			// $.each(data.Texts, function(i, item) {
			// 	$('.texts-container').append(`
			// 		<div class="row message bg-white mb-2" data-number="`+item[0]['redial']+`" data-name="`+i+`">
			// 			<div class="col">
			// 				<p class="text-from text-dark">`+i+`</p>
			// 			</div>
			// 			<div class="col">
			// 				<p class="text-date float-right">`+item[0]['time']+`</p>
			// 			</div>
			// 			<div class="col-sm-12"><small class="text-snippet text-muted">`+item[0]['Content']+`</small></div>
			// 		</div>
			// 	`);
			// });

			// Phone Text Messages
			PHONE_TEXTS = data.Texts;
			$.each(data.Texts, function(i, textgroup) {
				var lastText = '';
				$.each(textgroup, function(v, item){
					lastText = item;
				});
				if (lastText != '') {
					$('.texts-container').append(`
						<div class="row message bg-white mb-2" data-number="` + lastText.redial + `" data-name="` + lastText.name + `">
							<div class="col">
								<p class="text-from text-dark">` + lastText.name + `</p>
							</div>
							<div class="col">
								<p class="text-date float-right">` + lastText.time + `</p>
							</div>
							<div class="col-sm-12"><small class="text-snippet text-muted">` + lastText.content + `</small></div>
						</div>
					`);
				}
			});
			if($('.app-texts-view').hasClass('d-block')) {
				var activeNumber = $('.app-texts-view .text-reply-number').val();
				var activeName = $('.app-texts-view .text-reply-title').text();
				textView(activeNumber, activeName);
			}

			// TODO: ADD CONTACTS FOR THE NAME IN CALL LOGS
			PHONE_CONTACTS = data.Contacts;
			var contactsCount = 0;
			$.each(data.Contacts, function(i, item) {
				$('.contacts-container').append('<div class="contact bg-white mb-2 contact-row" data-contact="'+item['Name']+'" data-number="'+item['Number']+'" data-email="'+item['Email']+'" data-notes="'+item['Notes']+'" data-id="'+item['UID']+'"><div class="contact-details"><p class="contact-name text-dark">'+item['Name']+'</p></div><div class="contact-icon"><i class="fa fa-chevron-right"></i></div>');
				contactsCount++;
			});
			$('.contacts-search-count').text(contactsCount + ' Results found');

			// Phone Calls
			PHONE_CALLS = data.Calls;
			$.each(data.Calls.reverse(), function(i, item) {
				$('.call-history-container').append(`
				<div class="row">
					<div class="col mb-2">
						<div class="row call bg-white mb-2 d-flex h-100">
							<div class="col-2 justify-content-center align-self-center">
								<i class="fas fa-arrow-down `+ item.direction +`"></i>
							</div>
							<div class="col-6 justify-content-center align-self-center">
								<p class="call-from text-dark">` + item.name + `</p>
							</div>
							<div class="col-2 justify-content-center align-self-center">
								<p class="call-date text-muted">` + item.time + `</p>
							</div>
							<div class="col-2 justify-content-center align-self-center">
							<button class="btn btn-md return-call" data-number="` + item.redial + `" data-name="` + item.name + `">
								<i class="fa fa-phone"></i>
							</button>
						</div>
					</div>
				</div>
				`);
			});

			if (data.bleets) {
				$.each(data.bleets, function(i, item) {
					var content = item['Content'];
					var content = content.replace(new RegExp(':bleet:', 'g'), '<img src="images/bleet.png" class="bleeter-emoji"/>');
					var content = content.replace(new RegExp(':bleetangry:', 'g'), '<img src="images/bleetangry.png" class="bleeter-emoji"/>');
					var content = content.replace(new RegExp(':bleeteyeroll:', 'g'), '<img src="images/bleeteyeroll.png" class="bleeter-emoji"/>');
					var content = content.replace(new RegExp(':bleetsad:', 'g'), '<img src="images/bleetsad.png" class="bleeter-emoji"/>');
					var content = content.replace(new RegExp(':bleetsleep:', 'g'), '<img src="images/bleetsleep.png" class="bleeter-emoji"/>');
					var content = content.replace(new RegExp(':bleetheart:', 'g'), '<img src="images/bleetheart.png" class="bleeter-emoji"/>');
					var content = content.replace(new RegExp(':bleetblush:', 'g'), '<img src="images/bleetblush.png" class="bleeter-emoji"/>');
					var bleetDate = moment(item['DateTime']).format('MM/DD/YYYY HH:mm:ss');
					$('.app-bleeter .bleeter-feed').append('<div class="row"><div class="col-12 mt-2"><div class="bleeter-card card"><h1 class="bleeter-username text-white">'+item['BleeterName']+'</h1><hr><p class="text-white bleet-content">'+content+'</p><small class="bleet-timestamp">'+bleetDate+'</small></div></div></div>');
				});
			} else {
				console.warn("Phone is not logged into bleeter.")
			}

			PHONE_NOTES = data.Notes;
			$.each(data.Notes, function(i, item) {
				$('.app-notes .notes-container').append('<div class="note"><p class="note-content">'+item['Content']+'</p><div class="note-buttons"><div class="row"><div class="col-6 mx-auto"><button class="btn btn-lg edit-note" data-noteid="'+item['NoteID']+'" data-arrayid="'+i+'"><i class="far fa-pencil"></i></button><button class="btn btn-lg delete-note" data-noteid="'+item['NoteID']+'"><i class="far fa-trash"></i></button></div></div></div></div>');
			});

			PHONE_ADVERTS = data.Adverts;

			// console.log(PHONE_ADVERTS);

			PHONE_BANKACCOUNTS = data.BankAccounts;
			var bankAccountCount = 0;

			$('.accounts-container').html('');

			$.each(data.BankAccounts, function(i, item) {
				var balance = commaSeparateNumber(item['Balance']);
				$('.accounts-container').append('<div class="account" data-arrayid="'+i+'"><p class="account-name">'+item['Label']+'</p><p class="account-balance">$'+balance+'</p><p class="account-details">Available balance | <span class="account-number">'+item['AccountNumber']+'</span></p><i class="fal fa-chevron-right"></i></div>');

				$('.fleeca-transfer-from').append('<option value="'+i+'">'+item['Label']+'</option>');
				$('.state-debt-bankaccount').append('<option value="'+i+'">'+item['Label']+'</option>');
				bankAccountCount++;
			});

			if (bankAccountCount == 0) {
				$('.accounts-container').append(`
				<span class="mt-1 mb-3">No accounts found.</span>
				`);
			}

			PHONE_STATEDEBT = data.StateDebt;

			$('.app-state .debt-owed').text('$'+commaSeparateNumber(PHONE_STATEDEBT));

			var vehiclesCount = 0;
			PHONE_VEHICLES = data.Valet;
			$.each(data.Valet, function(i, item) {
				$('.app-valet .vehicles-container').append('<div class="vehicle"><h4 class="vehicle-model">'+item['VehModel']+' <br><small>VIN: '+item['VehicleID']+'</small> <small>PLATE: '+item['VehRegistration']+'</small></h4><p class="vehicle-location"><i class="fas fa-location"></i> '+item['Location']+'</p></div>');
				vehiclesCount++;
			});
			$('.valet-search-count').text(vehiclesCount + ' Results found');

			PHONE_EMAILS = data.Emails;
			$.each(data.Emails, function(i, item) {
				var date = moment(item.SentDateTime).format('MMM Do');
				if (item.direction == 'inbound') {
					$('.app-emails .email-inbound-container').append('<div class="email" data-arrayid="'+i+'"><p class="email-from">'+item['name']+'</p><p class="email-snippet">'+item['Content']+'</p><p class="email-date">'+date+'</p><p class="email-time">'+item['time']+'</p></div>');
				} else {
					$('.app-emails .email-outbound-container').append('<div class="email" data-arrayid="'+i+'"><p class="email-from">'+item['name']+'</p><p class="email-snippet">'+item['Content']+'</p><p class="email-date">'+date+'</p><p class="email-time">'+item['time']+'</p></div>');
				}
			});

			if (data.email_account) {
				PHONE_EMAILUSERNAME = data.email_account['Email'];
				PHONE_EMAILID = data.email_account['AccountID'];
				$('.emails-top-section .menu-title').text(PHONE_EMAILUSERNAME);
				$('#staticEmail').val(PHONE_EMAILUSERNAME);
				$('.emails-top-section .email-sign-out').addClass('d-block');
				$('.emails-top-section .email-sign-out').removeClass('d-none');
				$('.emails-top-section .email-register').addClass('d-none');
				$('.emails-top-section .email-register').removeClass('d-block');
				$('.emails-top-section .email-sign-in').addClass('d-none');
				$('.emails-top-section .email-sign-in').removeClass('d-block');
			  } else {
				PHONE_EMAILUSERNAME = undefined;
				PHONE_EMAILID = undefined;
				$('.emails-top-section .menu-title').text('Guest');
				$('#staticEmail').val('Guest');
				$('.emails-top-section .email-sign-out').removeClass('d-block');
				$('.emails-top-section .email-sign-out').addClass('d-none');
				$('.emails-top-section .email-register').removeClass('d-none');
				$('.emails-top-section .email-register').addClass('d-block');
				$('.emails-top-section .email-sign-in').removeClass('d-none');
				$('.emails-top-section .email-sign-in').addClass('d-block');
			  }

			  if (data.bleeter_account) {
				//   console.log("found bleeter account");
				PHONE_BLEETERUSERNAME = data.bleeter_account['Username'];
				PHONE_BLEETERID = data.bleeter_account['AccountID'];
				$('.bleeter-action.new-bleet').removeClass('d-none');
				$('.bleeter-action.new-bleet').addClass('d-block');
				$('.bleeter-action.sign-in').addClass('d-none');
				$('.bleeter-action.sign-in').removeClass('d-block');
				$('.bleeter-action.sign-out').addClass('d-block');
				$('.bleeter-action.sign-out').removeClass('d-none');
				$('.app-bleeter .bleeter-name').text(PHONE_BLEETERUSERNAME);
				$('.app-bleeter-bleet .bleeter-name').text(PHONE_BLEETERUSERNAME);
			  } else {
				// console.log("not found bleeter account");
				PHONE_BLEETERUSERNAME = undefined;
				PHONE_BLEETERID = undefined;
				$('.bleeter-action.new-bleet').addClass('d-none');
				$('.bleeter-action.new-bleet').removeClass('d-block');
				$('.bleeter-action.sign-in').removeClass('d-none');
				$('.bleeter-action.sign-in').addClass('d-block');
				$('.bleeter-action.sign-out').removeClass('d-block');
				$('.bleeter-action.sign-out').addClass('d-none');
				$('.app-bleeter .bleeter-name').text('Guest');
				$('.app-bleeter-bleet .bleeter-name').text('Guest');
			  }

			  if (data.YellowPagesAccount) {
				PHONE_YELLOWPAGESUSERNAME = data.YellowPagesAccount['Username'];
				PHONE_YELLOWPAGESID = data.YellowPagesAccount['AccountID'];
				$('.yellowpages-top-section .menu-title').text(PHONE_YELLOWPAGESUSERNAME);
				$('#staticUsername').val(PHONE_YELLOWPAGESUSERNAME);
				$('.yellowpages-top-section .yellowpages-sign-out').addClass('d-block');
				$('.yellowpages-top-section .yellowpages-sign-out').removeClass('d-none');
				$('.yellowpages-top-section .yellowpages-sign-in').addClass('d-none');
				$('.yellowpages-top-section .yellowpages-sign-in').removeClass('d-block');
				$('.yellowpages-new').removeClass('d-none');
				$('.yellowpages-new').addClass('d-block');
			  } else {
				PHONE_YELLOWPAGESUSERNAME = undefined;
				PHONE_YELLOWPAGESID = undefined;
				$('.yellowpages-top-section .menu-title').text('Guest');
				$('#staticUsername').val('Guest');
				$('.yellowpages-top-section .yellowpages-sign-out').removeClass('d-block');
				$('.yellowpages-top-section .yellowpages-sign-out').addClass('d-none');
				$('.yellowpages-top-section .yellowpages-sign-in').removeClass('d-none');
				$('.yellowpages-top-section .yellowpages-sign-in').addClass('d-block');
				$('.yellowpages-new').addClass('d-none');
				$('.yellowpages-new').removeClass('d-block');
			  }

			  console.log(data);

			PHONE_PIN = data.DevicePin;

			if (PHONE_PIN == null) {
				console.log("Phone has no pin.");
				PHONE_LOCKED = false;
				$('.app-lockscreen').hide();
			} else {
				console.log("Phone has a pin.");
				$('.app-settings .settings-pin').val('');

				console.log("PHONE_IMEI: ", PHONE_IMEI)
				console.log("PHONE_UNLOCKEDIMEI: ", PHONE_UNLOCKEDIMEI)

				if (PHONE_UNLOCKEDIMEI !== PHONE_IMEI) {
					PHONE_FIRST_UNLOCK = true;
					PHONE_LOCKED = true;
					console.log("This is a new phone.")
				}

				console.log("PHONE_FIRST_UNLOCK", PHONE_FIRST_UNLOCK);
				console.log("PHONE_LOCKED", PHONE_LOCKED);

				if (PHONE_FIRST_UNLOCK === true && PHONE_LOCKED === true) {
					PHONE_FIRST_UNLOCK = false;
					phoneLock();
				}

				
			}
		})
		syncPhoneDebounce = false;
	}
}
	//   PHONE_TEXTS = data.texts;
	//   $.each(data.texts, function(i, item) {
	// 	$('.texts-container').append('<div class="row message bg-white mb-2" data-number="'+item[0]['redial']+'" data-name="'+i+'"><div class="col"><p class="text-from text-dark">'+i+'</p></div><div class="col"><p class="text-date float-right">'+item[0]['time']+'</p></div><div class="col-sm-12"><small class="text-snippet text-muted">'+item[0]['Content']+'</small></div></div>');
	//   });
	//   if($('.app-texts-view').hasClass('d-block')) {
	// 	var activeNumber = $('.app-texts-view .text-reply-number').val();
	// 	var activeName = $('.app-texts-view .text-reply-title').text();
	// 	textView(activeNumber, activeName);
	//   }

	//   PHONE_EMAILS = data.emails;
	//   $.each(data.emails, function(i, item) {
	// 	var date = moment(item.Timestamp).format('MMM Do');
	// 	if (item.direction == 'inbound') {
	// 	  $('.app-emails .email-inbound-container').append('<div class="email" data-arrayid="'+i+'"><p class="email-from">'+item['name']+'</p><p class="email-snippet">'+item['Content']+'</p><p class="email-date">'+date+'</p><p class="email-time">'+item['time']+'</p></div>');
	// 	} else {
	// 	  $('.app-emails .email-outbound-container').append('<div class="email" data-arrayid="'+i+'"><p class="email-from">'+item['name']+'</p><p class="email-snippet">'+item['Content']+'</p><p class="email-date">'+date+'</p><p class="email-time">'+item['time']+'</p></div>');
	// 	}
	//   });

	//   if (PHONE_PIN == null) {
	//     PHONE_LOCKED = false;
	//     PHONE_UNLOCKEDIMEI = PHONE_IMEI;
	//     $('.app-lockscreen').hide();
	//   }

	//   if (PHONE_UNLOCKEDIMEI != imei && PHONE_PIN != null) {
	//     PHONE_LOCKED = true;
	//     phoneLock();
	//   } 

	//   PHONE_ADVERTS = data.adverts;
	//   PHONE_TEXTS = data.texts;
	//   $.each(data.texts, function(i, item) {
	//     $('.texts-container').append('<div class="row message bg-white mb-2" data-number="'+item[0]['redial']+'" data-name="'+i+'"><div class="col"><p class="text-from text-dark">'+i+'</p></div><div class="col"><p class="text-date float-right">'+item[0]['time']+'</p></div><div class="col-sm-12"><small class="text-snippet text-muted">'+item[0]['Content']+'</small></div></div>');
	//   });
	//   if($('.app-texts-view').hasClass('d-block')) {
	//     var activeNumber = $('.app-texts-view .text-reply-number').val();
	//     var activeName = $('.app-texts-view .text-reply-title').text();
	//     textView(activeNumber, activeName);
	//   }

	//   PHONE_EMAILS = data.emails;
	//   $.each(data.emails, function(i, item) {
	//     var date = moment(item.Timestamp).format('MMM Do');
	//     if (item.direction == 'inbound') {
	//       $('.app-emails .email-inbound-container').append('<div class="email" data-arrayid="'+i+'"><p class="email-from">'+item['name']+'</p><p class="email-snippet">'+item['Content']+'</p><p class="email-date">'+date+'</p><p class="email-time">'+item['time']+'</p></div>');
	//     } else {
	//       $('.app-emails .email-outbound-container').append('<div class="email" data-arrayid="'+i+'"><p class="email-from">'+item['name']+'</p><p class="email-snippet">'+item['Content']+'</p><p class="email-date">'+date+'</p><p class="email-time">'+item['time']+'</p></div>');
	//     }
	//   });

	function noPhone(action) {
		if (action == 'show') {
			$('.device').addClass('d-none');
			$('.cardboard').removeClass('d-none');
			setTimeout(function() {
				$('.cardboard').toggleClass('hide');
			}, 220);

		} else {
			$('.device').removeClass('d-none');
			$('.cardboard').addClass('d-none');
			setTimeout(function() {
				$('.cardboard').addClass('hide');
			}, 220);
		}

	}

	function setSignal() {
		var stages = ['signal', 'signal-1', 'scalignal-2', 'signal-3', 'signal-4'];
		$('.signal').attr('class', 'far signal');
		$('.signal').addClass('fa-' + stages[Math.floor(Math.random() * stages.length)]);
	}

	function setVolume(volume) {
		$('#deviceVolumeRange').attr('data-slider-value', volume);
		$('#deviceVolumeRange').val(volume);
		PHONE_VOLUME = (volume / 10);
		$('.audio').prop("volume", PHONE_VOLUME);
	}

	function setBleeterVolume(volume) {
		$('#bleeterVolumeRange').attr('data-slider-value', volume);
		$('#bleeterVolumeRange').val(volume);
	}

	function updateTime(time) {
		var timeLc = moment(time, 'HH:mm').add(3, 'hour').format('HH:mm');
		$('.time').text(time);
		$('.time-lc').text(timeLc);
	}

	function updateWeather(temp, weather, forecast) {
		$('.app-weather .weather-temp').text(temp + '°F');
		$('.app-weather').removeClass('sunny cloudy rain');
		$('.app-weather .weather-icon').html('');
		if (weather == 'CLEAR' || weather == 'EXTRASUNNY') {
			$('.app-weather').addClass('sunny');
			$('.app-weather .weather-icon').append('<i class="fas fa-sun"></i>');
		} else if (weather == 'SNOWLIGHT' || weather == 'XMAS' || weather == 'BLIZZARD') {
			$('.app-weather').addClass('rain');
			$('.app-weather .weather-icon').append('<i class="fas fa-cloud-snow"></i>');
		} else if (weather == 'RAIN') {
			$('.app-weather').addClass('rain');
			$('.app-weather .weather-icon').append('<i class="fas fa-cloud-showers"></i>');
		} else if (weather == 'CLEARING') {
			$('.app-weather').addClass('rain');
			$('.app-weather .weather-icon').append('<i class="fas fa-sun-cloud"></i>');
		} else if (weather == 'OVERCAST') {
			$('.app-weather').addClass('cloudy');
			$('.app-weather .weather-icon').append('<i class="fas fa-cloud"></i>');
		} else if (weather == 'CLOUDS') {
			$('.app-weather').addClass('cloudy');
			$('.app-weather .weather-icon').append('<i class="fas fa-clouds"></i>');
		} else if (weather == 'THUNDER') {
			$('.app-weather').addClass('cloudy');
			$('.app-weather .weather-icon').append('<i class="fas fa-thunderstorm"></i>');
		} else if (weather == 'FOGGY' || weather == 'SMOG') {
			$('.app-weather').addClass('cloudy');
			$('.app-weather .weather-icon').append('<i class="fas fa-fog"></i>');
		} else {
			$('.app-weather').addClass('sunny');
			$('.app-weather .weather-icon').append('<i class="fas fa-sun"></i>');
		}
		$('.app-weather .weather-weather').text(weather);
		$('.app-weather .weather-forecast').text(forecast);
	}

	function notify(notification, show) {
		if (notification == 'bleeter' && !$('.notifications-tray .tray-bleeter').length) {
			$('.notifications-tray').append('<img src="images/bleeter2.png" alt="" class="tray-bleeter tray-icon mx-auto">');
		} else if (notification == 'phone' && !$('.notifications-tray .tray-phone').length) {
			$('.notifications-tray').append('<img src="images/phone.png" alt="" class="tray-phone tray-icon mx-auto">');
		} else if (notification == 'text' && !$('.notifications-tray .tray-text').length) {
			$('.notifications-tray').append('<img src="images/text2.png" alt="" class="tray-text tray-icon mx-auto">');
		} else if (notification == 'email' && !$('.notifications-tray .tray-email').length) {
			$('.notifications-tray').append('<img src="images/email10.png" alt="" class="tray-email tray-icon mx-auto">');
		} else if (notification == 'bank' && !$('.notifications-tray .tray-bank').length) {
			$('.notifications-tray').append('<img src="images/fleeca.png" alt="" class="tray-bank tray-icon mx-auto">');
		} else if (notification == 'clock' && !$('.notifications-tray .tray-clock').length) {
			$('.notifications-tray').append('<img src="images/clock.png" alt="" class="tray-clock tray-icon mx-auto">');
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "timerEnd"
			}));
		}

		if (show) {
			$('.notifications-tray .tray-' + notification).fadeIn(200);
		} else {
			$('.notifications-tray .tray-' + notification).fadeOut(200);
		}
	}

	function clearNotify() {
		$('.notifications-tray .tray-icon').fadeOut(200);
		setTimeout(function() {
			$('.notifications-tray').html('');
		}, 220);
	}

	function showPhone() {
		$('.device').removeClass('hide');
		hideContent();
		if (PHONE_LOCKED && PHONE_ONCALL == 'false') {
			$('.app-lockscreen').addClass('d-block');
		} else if (PHONE_ONCALL == 'callReceive' && !$('.call-circle').is(':visible')) {
			$('.app-phone-receive').addClass('d-block');
		} else if (PHONE_ONCALL == 'callStart' || PHONE_ONCALL == 'callAnswer' && !$('.call-circle').is(':visible')) {
			$('.app-phone-make').addClass('d-block');
		} else {
			$('.app-home').addClass('d-block');
		}
	}

	function hidePhone() {
		$('.device').addClass('hide');
		$(':focus').blur();
		noPhone('hide');
		// releaseControl();

		var APICallback = PerformAPICallback('HandleUI', JSON.stringify({
			close: true
		}));
	}

	function phoneUnlock(pin) {
		if (pin == PHONE_PIN) {
			PHONE_LOCKED = false;
			PHONE_UNLOCKEDIMEI = PHONE_IMEI;
			$('.app-lockscreen').fadeOut(500);
			setTimeout(function() {
				goHome();
			}, 250);
		} else {
			PHONE_LOCKCOUNT++;
			if (PHONE_LOCKCOUNT >= 5) {
				$('.pin-input').attr('type', 'text');
				$('.pin-input').css('font-size', '1.2rem');
				$('.pin-input').css('color', '#fc3d39');
				$('.pin-input').text('Too many incorrect attempts');
				$('.pin-input').val('Too many incorrect attempts');
				$('.pin-input').addClass('shake');
				setTimeout(function() {
					$('.pin-input').attr('type', 'password');
					$('.pin-input').removeAttr('style');
					$('.pin-input').removeClass('shake');
					$('.pin-input').text('');
					$('.pin-input').val('');
					PHONE_LOCKCOUNT = 0;
				}, 30000);
			} else {
				$('.pin-input').addClass('shake');
				setTimeout(function() {
					$('.pin-input').removeClass('shake');
					$('.pin-input').val('');
				}, 1000);
			}
		}
	}

	function phoneLock() {
		PHONE_LOCKED = true;
		hideContent();
		$('.app-lockscreen').addClass("d-block");
	}

	function changeColor(color) {
		if ($(".device").hasClass("hide")) {
			$('.device').attr('class', 'device device-google-pixel hide');
		} else {
			$('.device').attr('class', 'device device-google-pixel');
		}
		$('.device').addClass(color);
	}

	function customBackground(url) {
		if (url) {
			$('.app-home').addClass('custom-background');
			$('.app-home.custom-background').css('background-image', 'url(' + url + ')');
			$('.app-lockscreen').css('background-image', 'url(' + url + ')');
			$('.app-settings .background-url').val(url);
		} else {
			$('.app-home.custom-background').removeAttr('style');
			$('.app-home').removeClass('custom-background');
			$('.app-lockscreen').removeAttr('style');
			$('.app-settings .background-url').val('');
		}
	}

	function goHome() {
		if (PHONE_ONCALL !== 'false' && PHONE_LOCKED) {
			return false;
		}
		if (PHONE_LOCKED) {
			hideContent();
			$('.app-lockscreen').addClass('d-block');
			return false;
		}
		clearInputs();
		clearNotify();
		hideContent();

		if (PHONE_ONCALL !== 'false') {
			$('.call-circle').show();
		}
		$('.app-home').addClass('d-block');
	}

	function takeControl() {
		// TRIGGER: Allow keyboard to be used
		$.post('http://soe-gphone/keyboardControl', JSON.stringify({
			takeKeyboard: true
		}));
	}

	function releaseControl() {
		// TRIGGER: Release keyboard control
		$.post('http://soe-gphone/keyboardControl', JSON.stringify({
			takeKeyboard: false
		}));
	}

	function clearInputs() {
		$('.clear-input').val('');
		$('.text-input').attr('style', '');
		$('.text-compose').attr('style', '');
		$('.text-history-messages').scrollTop(99999999);
		$('.app-content').scrollTop(0);
		$('.bleeter-feed').scrollTop(0);
		$('.collapse').removeClass('show');
		$('.vehicles-container .vehicle').each(function() {
			$(this).show();
		});
		$('.adverts-container .advert').each(function() {
			$(this).show();
		});
		$('.email-inbound-container .email').each(function() {
			$(this).show();
		});
		$('.email-outbound-container .email').each(function() {
			$(this).show();
		});
		$('.contacts-container .contact').each(function() {
			$(this).show();
		});
	}

	function hideContent() {
		$('.device-content').removeClass('d-block');
		$('.device-content').addClass('d-none');
	}

	function callStart(number) {
		if (PHONE_ONCALL !== 'false') {
			return false;
		}
		hideContent();
		$('.call-status').text('Calling');
		$('.app-phone-make').addClass('d-block');

		// TRIGGER: Start Call
		var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
			eventType: "call",
			toNumber: number
		}));

		PHONE_ONCALL = 'callStart';
		syncPhone();
	}

	function callReceive(number) {
		if (PHONE_ONCALL !== 'false') {
			return false;
		}
		if (PHONE_LOCKED) {
			$('.app-phone-receive .message-caller').hide();
		} else {
			$('.app-phone-receive .message-caller').show();
		}
		var name = '';
		var index = PHONE_CONTACTS.findIndex(function(contacts) {
			return contacts.ContactPhone == number;
		});
		if (index >= 0) {
			name = PHONE_CONTACTS[index]['ContactName'];
		} else {
			name = number;
		}
		$('.app-phone-receive .call-status').text('Incoming Call');
		$('.app-phone-receive .caller-name').text(name);
		$('.app-phone-receive .caller-number').text(number);
		$('.app-phone-receive .call-to-number').text(PHONE_NUMBER);
		$('.app-phone-receive .accept-call').attr('data-number', number);
		$('.app-phone-receive .accept-call').attr('data-name', name);
		$('.app-phone-receive .message-caller').attr('data-number', number);
		$('.app-phone-receive .message-caller').attr('data-name', name);
		hideContent();
		$('.app-phone-receive').addClass('d-block');
		PHONE_ONCALL = 'callReceive';
		syncPhone();
	}

	function callAnswer() {
		$('.call-time').stopwatch().stopwatch('stop');
		$('.call-time').stopwatch().stopwatch('reset');
		$('.call-status').text('Call Answered');
		hideContent();
		$('.app-phone-make').addClass('d-block');
		$('.call-time').stopwatch().stopwatch('start');

		// TRIGGER: Answer Call
		var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
			eventType: "callAnswer"
		}));
		PHONE_ONCALL = 'callAnswer';
	}

	function callEnd(fromLUA, wasAnswered = true) {
		if (wasAnswered === true) {
			$('.end-call-sound').get(0).play();
		}
		$('.call-time').stopwatch().stopwatch('stop');
		$('.call-time').stopwatch().stopwatch('reset');
		$('.call-status').text('Call Ended');
		$('.call-status').fadeOut(300).fadeIn(300).fadeOut(300).fadeIn(300).fadeOut(300).fadeIn(300);

		$.post('https://soe-gphone/Phone.EndRingtone', JSON.stringify({}));

		// TRIGGER: End Call
		if (fromLUA == false || fromLUA == null) {
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "callEnd"
			}));
		}
		if ($('.app-phone-make').hasClass('d-block') || $('.app-phone-receive').hasClass('d-block')) {
			setTimeout(function() {
				goHome();
			}, 2000);
		}
		$('.call-circle').hide();
		PHONE_ONCALL = 'false';
		syncPhone();
	}

	function textView(number, name) {
		$('.text-history-messages').html('');
		$.each(PHONE_TEXTS[name], function(name, text) {
			var timeDisp = moment(text['timestamp']).format('MM/DD/YYYY HH:mm');
			$('.text-history-messages').append('<div class="message ' + text['direction'] + '">' + text['content'] + ' <small class="text-time">' + timeDisp + '</small></div>');
		});
	}

	function textSend(toNumber, content) {
		// TRIGGER: Send text 
		clearInputs();
		$('.text-history-messages').prepend('<div class="message outbound">' + content + '<small class="text-time">Sending...</small></div>');
		var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
			eventType: "text",
			toNumber: toNumber,
			content: content
		}));
	}

	function saveContact(name, number, email, notes, id) {
		// TRIGGER: Update contact in DB
		if (!number) {
			return false;
		}
		var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
			eventType: "modContact",
			contactID: id,
			contactName: name,
			contactNumber: number,
			contactEmail: email,
			contactNotes: notes,
			imei: PHONE_IMEI
		}));
		clearInputs();
		syncPhone();
	}

	function newContact(name, number, email, notes) {
		if (!number) {
			return false;
		}
		// TRIGGER: Save contact to DB
		var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
			eventType: "createContact",
			contactName: name,
			contactNumber: number,
			contactEmail: email,
			contactNotes: notes
		}));
		clearInputs();
		syncPhone();
	}

	function messageContact(name, number) {
		$('.text-history-messages').html('');
		$.each(PHONE_TEXTS[name], function(name, text) {
			$('.text-history-messages').append('<div class="message ' + text['direction'] + '">' + text['Content'] + '</div>');
		});
		hideContent();
		$('.app-texts-view').addClass('d-block');
		$('.app-texts-view .number').text(name);
		$('.app-texts-view .number').val(number);
	}

	function emailContact(email) {
		if (!PHONE_EMAILUSERNAME) {
			hideContent();
			$('.app-emails-signin').addClass('d-block');
		} else {
			$('.email-compose-to').val(email);
			hideContent();
			$('.app-emails-compose').addClass('d-block');
		}

	}

	function deleteContact(id) {
		// TRIGGER: Remove contact from DB
		var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
			eventType: "removeContact",
			contactID: id,
			imei: PHONE_IMEI
		}));
		syncPhone();
	}

	function isEmail(email) {
		var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
		return regex.test(email);
	}

	function isAlphaNumeric(str) {
		var code, i, len;

		for (i = 0, len = str.length; i < len; i++) {
			code = str.charCodeAt(i);
			if (!(code > 47 && code < 58) && // numeric (0-9)
				!(code > 64 && code < 91) && // upper alpha (A-Z)
				!(code > 96 && code < 123) && // lower alpha (a-z)
				!(code == 45 || code == 95)) { // hyphen and underscore
				return false;
			}
		}
		return true;
	};

	function commaSeparateNumber(val) {
		while (/(\d+)(\d{3})/.test(val.toString())) {
			val = val.toString().replace(/(\d+)(\d{3})/, '$1' + ',' + '$2');
		}
		return val;
	}

	function emailSend(from, to, content) {
		var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
			eventType: "email",
			emailFrom: PHONE_EMAILUSERNAME, // Or however you get the emailFrom
			emailTo: to,
			emailContent: content
		}));
	}

	function emailSignOut() {
		var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
			eventType: "logoutOfAccount",
			accountType: "email"
		}));

		APICallback.then(function(result) {
			syncPhone();
		})
	}

	function copyToClipboard(text) {
		var dummy = document.createElement("textarea");
		document.body.appendChild(dummy);
		dummy.value = text;
		dummy.select();
		document.execCommand("copy");
		document.body.removeChild(dummy);
	}

	$(function() {
		PHONE_LATESTBLEET = moment.utc().subtract(1, "days");
		var timer;
		window.addEventListener('message', function(event) {
			if (event.data.type == "showPhone") {
				showPhone();
				//syncPhone(event.data.IMEI);
				clearNotify();
				setVolume(PHONE_VOLUME);
				setBleeterVolume(BLEETER_VOLUME);
			} else if (event.data.type == "showFakePhone") {
				noPhone('show');
			} else if (event.data.type == "syncPhone") {
				syncPhone(event.data.IMEI);
			} else if (event.data.type == "incomingCall") {
				callReceive(event.data.fromNumber);
			} else if (event.data.type == "endCall") {
				callEnd(true, event.data.wasAnswered);
				setTimeout(function() {
					goHome();
				}, 2000);
			} else if (event.data.type == "callAnswered") {
				callAnswer();
			} else if (event.data.type == "updateWeather") {
				updateWeather(event.data.currentTemp, event.data.currentWeather, event.data.currentForecast);
			} else if (event.data.type == "updateTime") {
				updateTime(event.data.currentTime);
			} else if (event.data.type == "getAccount") {
				if (event.data.accountType == "email") {
					var APICallback = PerformAPICallback('returnAccount', JSON.stringify({
						accountInfo: PHONE_EMAILUSERNAME
					}));
				}
			} else if (event.data.type == "showNotification") {
				notify(event.data.notifyType, event.data.showNotify);
			} else if (event.data.type == "clearNotifications") {
				clearNotify();
			} else if (event.data.type == "Phone.HideUI") {
				console.log('[Phone] UI resetted.');
				hidePhone();
			}
		});

		$(document).on('keydown', function(event) {
			if (event.key == "Escape" || event.key == "PageDown") {
				//   releaseControl();
				//   $(':focus').blur();
				//   $.post('http://soe-phone-new/handleUI', JSON.stringify({
				// 	close: true
				//   }));
				//   noPhone('hide');
				hidePhone();
			}
		});

		$('.phonenumber').mask('000-000-0000');

		$('input, textarea').focusout(function() {
			releaseControl();
		});

		$('input, textarea').focus(function() {
			takeControl();
		});

		$('input[name="deviceColor"]').change(function() {
			var color = $('input[name="deviceColor"]:checked').val();
			changeColor(color);
		});

		$('.home-button').click(function() {
			goHome();
		});

		$('.app-icon').click(function() {
			var app = $(this).attr('data-app');
			hideContent();
			if (!PHONE_EMAILUSERNAME && app == 'emails') {
				$('.app-emails-signin').addClass('d-block');
			} else {
				$('.app-' + app).addClass('d-block');
			}
		});

		$('.back-button').click(function() {
			clearInputs();
			var app = $(this).attr('data-location');
			hideContent();
			$('.app-' + app).addClass('d-block');
		});

		$('body').on('click', '.app-texts .message', function() {
			var number = $(this).attr('data-number');
			var name = $(this).attr('data-name');
			textView(number, name);
			hideContent();
			$('.app-texts-view').addClass('d-block');
			$('.app-texts-view .number').text(name);
			$('.app-texts-view .number').val(number);
			$('.app-texts-view .return-call').attr('data-number', number);
			$('.app-texts-view .return-call').attr('data-name', name);
		});

		$('.new-text').click(function() {
			hideContent();
			$('.app-texts-new').addClass('d-block');
		});

		$('.new-contact').click(function() {
			hideContent();
			$('.app-contacts-new').addClass('d-block');
		});

		$('.message-caller').click(function() {
			callEnd();
			var number = $(this).attr('data-number');
			var name = $(this).attr('data-name');
			hideContent();
			messageContact(name, number);
		});

		$('body').on('click', '.return-call', function() {
			if (PHONE_ONCALL !== 'false') {
				return false;
			}
			var number = $(this).attr('data-number');
			var name = $(this).attr('data-name');
			if (!name) {
				name = number;
			}
			$('.app-phone-make .name').text(name);
			$('.app-phone-make .number').text(number);
			callStart(number);
		});

		$('.accept-call').click(function() {
			var number = $(this).attr('data-number');
			var name = $(this).attr('data-name');
			if (!name) {
				name = number;
			}
			$('.app-phone-make .name').text(name);
			$('.app-phone-make .number').text(number);
			callAnswer();
		});

		$('.reject-call').click(function() {
			callEnd();
			setTimeout(function() {
				goHome();
			}, 2000);
		});

		$('.new-call').click(function() {
			hideContent();
			$('.app-phone-new').addClass('d-block');
		});

		$('.call-circle').click(function() {
			hideContent();
			if (PHONE_ONCALL == 'callReceive') {
				$('.app-phone-receive').addClass('d-block');
			} else {
				$('.app-phone-make').addClass('d-block');
			}
			$('.call-circle').hide();
		});

		$('.app-notes .new-note').click(function() {
			hideContent();
			$('.app-notes-new').addClass('d-block');
		});

		$('.app-texts-new .text-submit').click(function() {
			var toNumber = $('.text-compose-number').val();
			var content = $('.text-compose').val();
			if (!content) {
				return false;
			}
			textSend(toNumber, content);
			hideContent();
			$('.app-texts').addClass('d-block');
		});

		$('.text-compose').keypress(function(event) {
			var keycode = (event.keyCode ? event.keyCode : event.which);
			if (keycode == '13') {
				event.preventDefault();
				var toNumber = $('.text-compose-number').val();
				var content = $('.text-compose').val();
				if (!content) {
					return false;
				}
				textSend(toNumber, content);
				hideContent();
				$('.app-texts').addClass('d-block');
			}
		});

		$('.app-texts-view .text-submit').click(function() {
			var toNumber = $('.text-reply-number').val();
			var content = $('.text-reply-content').val();
			if (!content) {
				return false;
			}
			textSend(toNumber, content);
		});

		$('.text-reply-content').keypress(function(event) {
			var keycode = (event.keyCode ? event.keyCode : event.which);
			if (keycode == '13') {
				event.preventDefault();
				var toNumber = $('.text-reply-number').val();
				var content = $('.text-reply-content').val();

				textSend(toNumber, content);
			}
		});

		$('.dial-number-key').click(function() {
			var data = $(this).attr('data-input');
			var currentInput = $('.call-number').val();
			if (data == 'clear') {
				$(".call-number").val('');
			} else if (data == 'call') {
				if (PHONE_ONCALL !== 'false') {
					return false;
				}
				var name = '';
				var index = PHONE_CONTACTS.findIndex(function(contacts) {
					return contacts.ContactPhone == currentInput;
				});
				if (index >= 0) {
					name = PHONE_CONTACTS[index]['ContactName'];
				} else {
					name = currentInput;
				}
				$('.app-phone-make .name').text(name);
				$('.app-phone-make .number').text(currentInput);
				callStart(currentInput);
				clearInputs();
			} else {
				$(".call-number").val(currentInput + data);
				$('.call-number').trigger('input');
			}
		});

		$('.pin-number-key').click(function() {
			var data = $(this).attr('data-input');
			var currentInput = $('.pin-input').val();
			if (data == 'clear') {
				$(".pin-input").val('');
			} else if (data == 'submit') {
				phoneUnlock(currentInput);
			} else {
				if (currentInput.length >= 10) {
					return false;
				} else {
					$(".pin-input").val(currentInput + data);
				}
			}
		});

		$('.app-settings .copy-button').click(function() {
			copyToClipboard(PHONE_NUMBER);
		});

		$('.background-save').click(function() {
			var phoneBackground = $('.app-settings .background-url').val();
			customBackground(phoneBackground);
			// TRIGGER: Save background to database
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "modBackground",
				phoneBackground: phoneBackground
			}));
		});

		$('.pin-save').click(function() {
			var phonePin = $('.app-settings .settings-pin').val();
			// TRIGGER: Save PIN to database
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "modPIN",
				phonePIN: phonePin
			}));
		});

		$('.volume-save').click(function() {
			var phoneVolume = $('.app-settings .settings-volume').val();
			// TRIGGER: Save phone volume
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "modVolume",
				phoneVolume: phoneVolume
			}));
		});

		$('.bleeter-volume-save').click(function() {
			var bleeterVolume = $('.app-settings .settings-bleeter-volume').val();
			// TRIGGER: Save phone volume
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "modBleeterVolume",
				bleeterVolume: bleeterVolume
			}));
		});

		$('.text-input').on('input', function() {
			if (this.scrollHeight > 32) {
				$('.text-input').css('height', '3.3rem');
			}
		});

		$('body').on('click', '.contact-row', function() {
			var contact = $(this).attr('data-contact');
			var number = $(this).attr('data-number');
			var email = $(this).attr('data-email');
			var notes = $(this).attr('data-notes');
			var id = $(this).attr('data-id');
			hideContent();
			$('.app-contacts-view').addClass('d-block');
			$('.app-contacts-view .contact-name').text(contact);
			$('.app-contacts-view .contact-number').text(number);
			$('.app-contacts-view .contact-email').text(email);
			$('.app-contacts-view .contact-notes').text(notes);
			$('.app-contacts-view .message-contact').attr('data-number', number);
			$('.app-contacts-view .message-contact').attr('data-name', contact);
			$('.app-contacts-view .email-contact').attr('data-number', number);
			$('.app-contacts-view .email-contact').attr('data-name', contact);
			$('.app-contacts-view .email-contact').attr('data-email', email);
			$('.app-contacts-view .call-contact').attr('data-number', number);
			$('.app-contacts-view .call-contact').attr('data-name', contact);
			$('.app-contacts-view .edit-contact').attr('data-number', number);
			$('.app-contacts-view .edit-contact').attr('data-name', contact);
			$('.app-contacts-view .edit-contact').attr('data-email', email);
			$('.app-contacts-view .edit-contact').attr('data-notes', notes);
			$('.app-contacts-view .edit-contact').attr('data-id', id);
		});

		$('.edit-contact').click(function() {
			var contact = $(this).attr('data-name');
			var number = $(this).attr('data-number');
			var email = $(this).attr('data-email');
			var notes = $(this).attr('data-notes');
			var id = $(this).attr('data-id');
			hideContent();
			$('.app-contacts-edit').addClass('d-block');
			$('.app-contacts-edit .contact-name').text(contact);
			$('.app-contacts-edit .contact-id-input').val(id);
			$('.app-contacts-edit .contact-name-input').val(contact);
			$('.app-contacts-edit .contact-number-input').val(number);
			$('.app-contacts-edit .contact-notes-input').val(notes);
			$('.app-contacts-edit .contact-email-input').val(email);
		});

		$('.contact-save').click(function() {
			var name = $('.app-contacts-edit .contact-name-input').val();
			var number = $('.app-contacts-edit .contact-number-input').val();
			var email = $('.app-contacts-edit .contact-email-input').val();
			var notes = $('.app-contacts-edit .contact-notes-input').val();
			var id = $('.app-contacts-edit .contact-id-input').val();
			if (!number || !name) {
				return false;
			}

			saveContact(name, number, email, notes, id);
			hideContent();
			$('.app-contacts').addClass('d-block');
		});

		$('.contact-delete').click(function() {
			var id = $('.app-contacts-edit .contact-id-input').val();

			deleteContact(id);
			hideContent();
			$('.app-contacts').addClass('d-block');
		});

		$('.new-contact-save').click(function() {
			var name = $('.app-contacts-new .new-contact-name-input').val();
			var number = $('.app-contacts-new .new-contact-number-input').val();
			var email = $('.app-contacts-new .new-contact-email-input').val();
			var notes = $('.app-contacts-new .new-contact-notes-input').val();
			if (!number || !name) {
				return false;
			}

			newContact(name, number, email, notes);
			hideContent();
			$('.app-contacts').addClass('d-block');
		});

		$('.message-contact').click(function() {
			var number = $(this).attr('data-number');
			var name = $(this).attr('data-name');
			messageContact(name, number);
		});

		$('body').on('click', '.email-contact', function() {
			var email = $(this).attr('data-email');
			clearInputs();
			emailContact(email);
		});

		$('.call-contact').click(function() {
			if (PHONE_ONCALL !== 'false') {
				return false;
			}
			var number = $(this).attr('data-number');
			var name = $(this).attr('data-name');
			if (!name) {
				name = number;
			}
			$('.app-phone-make .name').text(name);
			$('.app-phone-make .number').text(number);
			callStart(number);
		});

		$('.bleeter-action.sign-out').click(function() {
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "logoutOfAccount",
				accountType: "bleeter"
			}));

			$('.bleeter-action.sign-out').removeClass('d-block');
			$('.bleeter-action.sign-out').addClass('d-none');
			$('.bleeter-action.sign-in').removeClass('d-none');
			$('.bleeter-action.sign-in').addClass('d-block');
			$('.bleeter-action.new-bleet').addClass('d-none');
			$('.bleeter-action.new-bleet').removeClass('d-block');
			$('.app-bleeter .bleeter-name').text('Guest');
			//syncPhone();
		});

		$('.bleeter-action.sign-in').click(function() {
			hideContent();
			$('.app-bleeter-signin').addClass('d-block');
		});

		$('.bleeter-action.new-bleet').click(function() {
			hideContent();
			$('.app-bleeter-bleet').addClass('d-block');
		});

		$('.bleeter-emoji-button').click(function() {
			$('.bleeter-emoji-popup').fadeIn();
		});

		$('.bleeter-emoji-close').click(function() {
			$('.bleeter-emoji-popup').fadeOut();
		});

		$('.bleeter-home').click(function() {
			hideContent();
			$('.app-bleeter').addClass('d-block');
		});

		$('.bleeter-signin-form .bleeter-form-submit').click(function() {
			var username = $('.bleeter-signin-username').val();
			var password = $('.bleeter-signin-password').val();
			if (!username || !password) {
				$('.bleeter-notification').show();
				$('.bleeter-notification').text('Please fill in all fields!');
				$('.bleeter-notification').removeClass('bleeter-success');
				$('.bleeter-notification').addClass('bleeter-error');
				window.setTimeout(function() {
					$('.bleeter-notification').hide();
					$('.bleeter-notification').text('');
					$('.bleeter-notification').removeClass('bleeter-success');
					$('.bleeter-notification').removeClass('bleeter-error');
				}, 1000);
				return false;
			}

			// console.log("login to account");
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "loginToAccount",
				accountType: "bleeter",
				accountUsername: username,
				accountPassword: password
			}));

			APICallback.then(function(data) {
				if (data.status) {
					$('.bleeter-notification').show();
					$('.bleeter-notification').text(data.message);
					$('.bleeter-notification').addClass('bleeter-success');
					$('.bleeter-notification').removeClass('bleeter-error');
					window.setTimeout(function() {
						hideContent();
						$('.bleeter-notification').hide();
						$('.app-bleeter').addClass('d-block');
					}, 1000);
				} else {
					$('.bleeter-notification').show();
					$('.bleeter-notification').text(data.message);
					$('.bleeter-notification').removeClass('bleeter-success');
					$('.bleeter-notification').addClass('bleeter-error');
					window.setTimeout(function() {
						$('.bleeter-notification').hide();
					}, 2000);
				}
			})

			clearInputs();
			//syncPhone();
		});

		$('.bleeter-register-form .bleeter-form-submit').click(function() {
			var username = $('.bleeter-register-username').val();
			var password = $('.bleeter-register-password').val();
			if (!username || !password) {
				$('.bleeter-notification').show();
				$('.bleeter-notification').text('Please fill in all fields!');
				$('.bleeter-notification').removeClass('bleeter-success');
				$('.bleeter-notification').addClass('bleeter-error');
				window.setTimeout(function() {
					$('.bleeter-notification').hide();
					$('.bleeter-notification').text('');
					$('.bleeter-notification').removeClass('bleeter-success');
					$('.bleeter-notification').removeClass('bleeter-error');
				}, 1000);
				return false;
			}
			if (!isAlphaNumeric(username) || username.length > 30) {
				$('.bleeter-notification').show();
				$('.bleeter-notification').text('Invalid username!');
				$('.bleeter-notification').removeClass('bleeter-success');
				$('.bleeter-notification').addClass('bleeter-error');
				window.setTimeout(function() {
					$('.bleeter-notification').hide();
					$('.bleeter-notification').text('');
					$('.bleeter-notification').removeClass('bleeter-success');
					$('.bleeter-notification').removeClass('bleeter-error');
				}, 1000);
				return false;
			}

			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "createAccount",
				accountType: "bleeter",
				accountUsername: username,
				accountPassword: password,
				accountDisplayname: username
			}));

			APICallback.then(function(data) {
				//syncPhone();
				if (data.status) {
					$('.bleeter-notification').show();
					$('.bleeter-notification').text(data.message);
					$('.bleeter-notification').addClass('bleeter-success');
					$('.bleeter-notification').removeClass('bleeter-error');
					window.setTimeout(function() {
						hideContent();
						$('.bleeter-notification').hide();
						$('.bleeter-notification').text('');
						$('.app-bleeter').addClass('d-block');
						$('.bleeter-notification').removeClass('bleeter-success');
						$('.bleeter-notification').removeClass('bleeter-error');
					}, 1000);
				} else {
					$('.bleeter-notification').show();
					$('.bleeter-notification').text(data.message);
					$('.bleeter-notification').removeClass('bleeter-success');
					$('.bleeter-notification').addClass('bleeter-error');
					window.setTimeout(function() {
						$('.bleeter-notification').hide();
						$('.bleeter-notification').text('');
						$('.bleeter-notification').removeClass('bleeter-success');
						$('.bleeter-notification').removeClass('bleeter-error');
					}, 1000);
				}
			})

			clearInputs();
			syncPhone();
		});

		$('.bleeter-bleet-form .bleeter-form-submit').click(function() {
			var content = $('textarea.bleeter-new-bleet').val();
			if (!content) {
				return false;
			}
			var now = moment.utc();
			var seconds = now.diff(PHONE_LATESTBLEET, 'seconds');
			if (seconds < 10 && PHONE_NUMBEROFBLEETS >= 2) {
				$('.bleeter-form-submit').attr('readonly');
				$('.bleeter-form-submit').addClass('readonly');
				window.setTimeout(function() {
					$('.bleeter-form-submit').removeAttr('readonly');
					$('.bleeter-form-submit').removeClass('readonly');
					PHONE_LATESTBLEET = moment.utc().subtract(1, 'days');
					PHONE_NUMBEROFBLEETS = 0;
				}, 10000);
				return false;
			} else {
				PHONE_LATESTBLEET = moment.utc();
				PHONE_NUMBEROFBLEETS++;
			}

			// TRIGGER: Post new bleet
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "bleet",
				bleetUsername: PHONE_BLEETERID,
				bleetContent: content
			}));

			hideContent();
			clearInputs();
			//syncPhone();
			$('.app-bleeter').addClass('d-block');
		});

		$('.calculator-number-key').click(function() {
			var data = $(this).attr('data-input');
			var currentInput = $('.calculator-input').val();
			if (data == 'clear') {
				$(".calculator-input").val('');
			} else if (data == '=') {
				try {
					var calculated = math.evaluate(currentInput);
					$(".calculator-input").val(calculated);
				} catch (error) {
					$(".calculator-input").val('ERROR');
					window.setTimeout(function() {
						$(".calculator-input").val('');
					}, 1000);
				}
			} else {
				$(".calculator-input").val(currentInput + $(this).text());
			}
		});

		$('body').on('click', '.app-notes .delete-note', function() {
			var noteID = $(this).attr('data-noteid');

			// TRIGGER: DELETE NOTE
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "removeNote",
				noteID: noteID,
				imei: PHONE_IMEI
			}));
			clearInputs();
			syncPhone();
		});

		$('body').on('click', '.app-notes .edit-note', function() {
			var noteID = $(this).attr('data-noteid');
			var arrayID = $(this).attr('data-arrayid');
			hideContent();
			$('.app-notes-edit .edit-note-content').val(PHONE_NOTES[arrayID]['Content']);
			$('.app-notes-edit .edit-note-id').val(noteID);
			$('.app-notes-edit').addClass('d-block');
		});

		$('.app-notes-new .new-note').click(function() {
			var content = $('textarea.new-note-content').val();
			if (!content) {
				return false;
			}

			// TRIGGER: Post new note
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "createNote",
				noteContent: content,
				imei: PHONE_IMEI
			}));

			hideContent();
			clearInputs();
			syncPhone();
			$('.app-notes').addClass('d-block');
		});

		$('.app-notes-edit .save-note').click(function() {
			var content = $('.app-notes-edit .edit-note-content').val();
			var noteID = $('.app-notes-edit .edit-note-id').val();

			// TRIGGER: SAVE NOTE
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "modNote",
				noteID: noteID,
				noteContent: content,
				imei: PHONE_IMEI
			}));

			hideContent();
			clearInputs();
			syncPhone();
			$('.app-notes').addClass('d-block');
		});

		$('.stopwatch-buttons .btn-start').click(function() {
			$('.stopwatch-time').stopwatch({
				format: '{HH}:{MM}:{ss}'
			}).stopwatch('start');
		});

		$('.stopwatch-buttons .btn-stop').click(function() {
			$('.stopwatch-time').stopwatch('stop');
		});

		$('.stopwatch-buttons .btn-reset').click(function() {
			$('.stopwatch-time').stopwatch('reset');
			$('.stopwatch-time').text('00:00:00');
			$('.stopwatch-laps').html('');
		});

		$('.stopwatch-buttons .btn-lap').click(function() {
			var time = $('.stopwatch-time').text();
			$('.stopwatch-laps').append('<p class="lap">' + time + '</p>');
		});

		$('#clock-timer .btn-timer-start').click(function() {
			if (timer) {
				return false;
			}
			var duration = moment.duration({
				'seconds': $('.timer-seconds').val(),
				'minutes': $('.timer-minutes').val()
			});
			timer = setInterval(function() {
				var newTime = duration.subtract(1, 's');
				$('#clock-timer .timer-time').text(moment.utc(duration.asMilliseconds()).format('mm:ss'));
				if (duration.asMilliseconds() == 0) {
					notify('clock');
					$('#clock-timer .timer-time').text('00:00');
					clearInterval(timer);
					timer = undefined;
				}
			}, 1000);
		});

		$('#clock-timer .btn-timer-stop').click(function() {
			$('#clock-timer .timer-time').text('00:00');
			clearInterval(timer);
			timer = undefined;
		});

		$('.emails-top-section .emails-logo, .emails-home').click(function() {
			clearInputs();
			hideContent();
			if (!PHONE_EMAILUSERNAME) {
				$('.app-emails-signin').addClass('d-block');
			} else {
				$('.app-emails').addClass('d-block');
			}
		});

		$('body').on('click', '.app-emails .email', function() {
			var arrayID = $(this).attr('data-arrayid');
			var date = moment(PHONE_EMAILS[arrayID].Timestamp).format('MM/DD/YYYY HH:mm:ss');
			hideContent();
			clearInputs();
			if (PHONE_EMAILS[arrayID].direction == 'inbound') {
				$('.emails-reply').removeClass('d-none');
				$('.emails-reply').addClass('d-block');
			} else {
				$('.emails-reply').removeClass('d-block');
				$('.emails-reply').addClass('d-none');
			}
			$('.emails-reply').attr('data-arrayid', arrayID);
			$('.email-view-address').html(PHONE_EMAILS[arrayID].name);
			$('.email-view-date').html(date);
			$('.email-view-content').html('<pre>' + PHONE_EMAILS[arrayID].Content + '</pre>');
			$('.app-emails-view').addClass('d-block');
		});

		$('.emails-top-section .emails-new').click(function() {
			hideContent();
			clearInputs();
			$('.app-emails-compose').addClass('d-block');
		});

		$('.emails-top-section .email-sign-out').click(function() {
			emailSignOut();
			hideContent();
			clearInputs();
			$('.app-emails-signin').addClass('d-block');
		});

		$('.emails-compose-send').click(function() {
			var from = PHONE_EMAILUSERNAME;
			var to = $('.email-compose-to').val();
			var content = $('.email-compose-content').val();

			if (!from || !to || !content || !isEmail(to)) {
				return false;
			} else {
				emailSend(from, to, content);
			}
			clearInputs();
			hideContent();
			syncPhone();
			$('.app-emails').addClass('d-block');
		});

		$('.emails-reply').click(function() {
			clearInputs();
			var arrayID = $(this).attr('data-arrayid');
			var to = PHONE_EMAILS[arrayID].EmailFrom;
			var content = PHONE_EMAILS[arrayID].Content;
			var date = moment(PHONE_EMAILS[arrayID].Timestamp).format('MM/DD/YYYY HH:mm:ss');
			$('.email-compose-to').val(to);
			hideContent();
			$('.app-emails-compose').addClass('d-block');
		});

		$('.emails-signin-form .emails-signin-submit').click(function() {
			var username = $('.emails-signin-username').val();
			var password = $('.emails-signin-password').val();
			if (!username || !password) {
				$('.emails-notification').show();
				$('.emails-notification').text('Please fill in all fields!');
				$('.emails-notification').removeClass('success');
				$('.emails-notification').addClass('error');
				window.setTimeout(function() {
					$('.emails-notification').hide();
					$('.emails-notification').text('');
					$('.emails-notification').removeClass('error');
					$('.emails-notification').removeClass('success');
				}, 2000);
				return false;
			}
			$('.emails-notification').show();
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "loginToAccount",
				accountType: "email",
				accountUsername: username,
				accountPassword: password
			}));

			APICallback.then(function(data) {
				console.log(data);
				if (data.status) {
					$('.emails-notification').show();
					$('.emails-notification').text(data.message);
					$('.emails-notification').addClass('success');
					$('.emails-notification').removeClass('error');
					window.setTimeout(function() {
						hideContent();
						$('.emails-notification').hide();
						$('.app-emails').addClass('d-block');
						$('.emails-notification').removeClass('error');
						$('.emails-notification').removeClass('success');
						$('.emails-notification').text('');
						syncPhone();
					}, 1000);
				} else {
					$('.emails-notification').show();
					$('.emails-notification').text(data.message);
					$('.emails-notification').removeClass('success');
					$('.emails-notification').addClass('error');
					window.setTimeout(function() {
						$('.emails-notification').hide();
						$('.emails-notification').removeClass('error');
						$('.emails-notification').removeClass('success');
						$('.emails-notification').text('');
						syncPhone();
					}, 2000);
				}
			})
			
			clearInputs();
		});

		$('.emails-register-form .emails-register-submit').click(function() {
			var username = $('.emails-register-username').val();
			var password = $('.emails-register-password').val();
			if (!username || !password) {
				$('.emails-notification').show();
				$('.emails-notification').text('Please fill in all fields!');
				$('.emails-notification').removeClass('success');
				$('.emails-notification').addClass('error');
				window.setTimeout(function() {
					$('.emails-notification').hide();
					$('.emails-notification').text('');
					$('.emails-notification').removeClass('error');
					$('.emails-notification').removeClass('success');
				}, 2000);
				return false;
			}
			if (!isAlphaNumeric(username) || username.length > 30) {
				$('.emails-notification').show();
				$('.emails-notification').text('Invalid username!');
				$('.emails-notification').removeClass('success');
				$('.emails-notification').addClass('error');
				window.setTimeout(function() {
					$('.emails-notification').hide();
					$('.emails-notification').text('');
					$('.emails-notification').removeClass('error');
					$('.emails-notification').removeClass('success');
				}, 2000);
				return false;
			}
			var emailAddress = username + '@eyefind.info';
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "createAccount",
				accountType: "email",
				accountUsername: emailAddress,
				accountPassword: password,
				accountDisplayname: username
			}));

			APICallback.then(function(data) {
				if (data.status) {
					$('.emails-notification').show();
					$('.emails-notification').text(data.message);
					$('.emails-notification').addClass('success');
					$('.emails-notification').removeClass('error');
					window.setTimeout(function() {
						hideContent();
						$('.emails-notification').hide();
						$('.emails-notification').text('');
						$('.app-emails').addClass('d-block');
						$('.emails-notification').removeClass('error');
						$('.emails-notification').removeClass('success');
					}, 1000);
				} else {
					$('.emails-notification').show();
					$('.emails-notification').text(data.message);
					$('.emails-notification').removeClass('success');
					$('.emails-notification').addClass('error');
					window.setTimeout(function() {
						$('.emails-notification').hide();
						$('.emails-notification').text('');
						$('.emails-notification').removeClass('error');
						$('.emails-notification').removeClass('success');
					}, 1000);
				}
			})
			
			clearInputs();
			syncPhone();
		});

		$('.fleeca-home-button, .top-section .fleeca-logo').click(function() {
			clearInputs();
			hideContent();
			$('.app-fleeca').addClass('d-block');
		});

		$('.fleeca-newaccount-button').click(function() {
			clearInputs();
			hideContent();
			$('.app-fleeca-newaccount').addClass('d-block');
		});

		$('.fleeca-transfer-button').click(function() {
			clearInputs();
			hideContent();
			$('.app-fleeca-transfer').addClass('d-block');
		});

		$('.fleeca-newaccount-submit').click(function() {
			var name = $('.fleeca-newaccount-name').val();
		 	if (!name) {
		 		return false;
			}

			var pin = $('.fleeca-newaccount-pin').val();
		 	if (!pin) {
		 		return false;
			}

			console.log(name);
			console.log(pin);
		 	$.post('http://soe-gphone/pushEvent', JSON.stringify({
		 		eventType: "bankopenaccount",
				accountName: name,
				accountPIN: pin,
				accountType: "Personal",
				accountStartAmount: 0,
			}));
	
			clearInputs();
		 	hideContent();
		 	$('.app-fleeca').addClass('d-block');
		});

		$('.fleeca-transfer-submit').click(function() {
			var transferTo = $('.fleeca-transfer-to').val();
			var transferAmount = $('.fleeca-transfer-amount').val();
			var transferFrom = $('.fleeca-transfer-from option:selected').val();
			var bankAccountNumber = PHONE_BANKACCOUNTS[transferFrom].AccountNumber;
			if (!transferTo || !transferAmount || !transferAmount.match(/^\d+$/) || !transferFrom || !transferTo.match(/^\d+$/) || !bankAccountNumber) {
				$('.transfer-notification').show();
				$('.transfer-notification').text('Invalid information entered');
				$('.transfer-notification').addClass('text-error');
				window.setTimeout(function() {
					$('.transfer-notification').hide();
					$('.transfer-notification').text('');
					$('.transfer-notification').removeClass('text-error');
				}, 2000);
				return false;
			}
			if (transferAmount > PHONE_BANKACCOUNTS[transferFrom].Balance) {
				$('.transfer-notification').show();
				$('.transfer-notification').text('Not Enough Funds!');
				$('.transfer-notification').addClass('text-error');
				window.setTimeout(function() {
					$('.transfer-notification').hide();
					$('.transfer-notification').text('');
					$('.transfer-notification').removeClass('text-error');
				}, 2000);
				return false;
			}

			// console.log("API callback");

			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "banktransfer",
				fromAccount: bankAccountNumber,
				toAccount: transferTo,
				amount: transferAmount
			}));

			clearInputs();
			APICallback.then(function(data) {
				//syncPhone();
				clearInputs();
				hideContent();
				$('.app-fleeca').addClass('d-block');
			})	
		});

		$('.app-yellowpages .category').click(function() {
			$('.adverts-container').html('');
			var category = $(this).attr('data-category');
			var adverts = [];
			if (category == 'all') {
				adverts = PHONE_ADVERTS;
			} else {
				$.each(PHONE_ADVERTS, function(i, item) {
					if (item['AdvertType'] == category) {
						adverts.push(item);
					}
				});
			}
			$.each(adverts, function(i, item) {
				var date = moment(item['Timestamp']).format('MM/DD/YYYY HH:mm:ss');
				$('.adverts-container').append('<div class="advert" data-arrayid="' + i + '"> <div class="advert-body"><p class="advert-type">' + item['Category'] + '</p><p class="advert-timestamp">' + date + '</p><hr><p class="advert-content">' + item['Content'] + '</p></div><div class="advert-footer"><button class="btn btn-sm advert-email" data-email="' + item['Email'] + '"><i class="fas fa-envelope email-icon"></i>Email</button><button class="btn btn-sm advert-phone" data-phone="' + item['Phone'] + '"><i class="fas fa-phone phone-icon"></i>Call</button><button class="btn btn-sm advert-text" data-text="' + item['Phone'] + '"><i class="fas fa-comment-alt-dots text-icon"></i>Text</button></div></div>');
			});
			hideContent();
			clearInputs();
			$('.app-yellowpages-view').addClass('d-block');
		});

		$('.yellowpages-home, .yellowpages-top-section .yellowpages-logo').click(function() {
			clearInputs();
			hideContent();
			$('.app-yellowpages').addClass('d-block');
		});

		$('.yellowpages-sign-in').click(function() {
			clearInputs();
			hideContent();
			$('.app-yellowpages-signin').addClass('d-block');
		});

		$('.yellowpages-new').click(function() {
			clearInputs();
			hideContent();
			$('.app-yellowpages-new').addClass('d-block');
		});

		$('body').on('click', '.app-yellowpages-view .advert-phone', function() {
			var phone = $(this).attr('data-phone');
			var name = '';
			var index = PHONE_CONTACTS.findIndex(function(contacts) {
				return contacts.ContactPhone == phone;
			});
			if (index >= 0) {
				name = PHONE_CONTACTS[index]['ContactName'];
			} else {
				name = phone;
			}
			$('.app-phone-make .name').text(name);
			$('.app-phone-make .number').text(phone);
			callStart(phone);
			clearInputs();
		});

		$('body').on('click', '.app-yellowpages-view .advert-text', function() {
			var number = $(this).attr('data-text');
			var name = '';
			var index = PHONE_CONTACTS.findIndex(function(contacts) {
				return contacts.ContactPhone == number;
			});
			if (index >= 0) {
				name = PHONE_CONTACTS[index]['ContactName'];
			} else {
				name = number;
			}
			messageContact(name, number);
			clearInputs();
		});


		$('body').on('click', '.app-yellowpages-view .advert-email', function() {
			var email = $(this).attr('data-email');
			clearInputs();
			emailContact(email);
		});

		$('.yellowpages-menu .yellowpages-sign-out').click(function() {
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "logoutOfAccount",
				accountType: "yellowpages"
			}));

			APICallback.then(function(data) {
				if (data.status) {
					// DO SUCCESS LOGOUT WITH data.message
				} else {
					// DO FAILURE LOGOUT WITH data.message
				}
			})

			$('.yellowpages-menu .yellowpages-sign-out').removeClass('d-block');
			$('.yellowpages-menu .yellowpages-sign-out').addClass('d-none');
			$('.yellowpages-menu .yellowpages-sign-in').removeClass('d-none');
			$('.yellowpages-menu .yellowpages-sign-in').addClass('d-block');
			$('.yellowpages-new').addClass('d-none');
			$('.yellowpages-new').removeClass('d-block');
			$('.yellowpages-menu .menu-title').text('Guest');
		});

		$('.yellowpages-register-form .yellowpages-register-submit').click(function() {
			var username = $('.yellowpages-register-username').val();
			var password = $('.yellowpages-register-password').val();
			if (!username || !password) {
				$('.yellowpages-notification').show();
				$('.yellowpages-notification').text('Please fill in all fields!');
				$('.yellowpages-notification').removeClass('success');
				$('.yellowpages-notification').addClass('error');
				window.setTimeout(function() {
					$('.yellowpages-notification').hide();
					$('.yellowpages-notification').text('');
					$('.yellowpages-notification').removeClass('error');
					$('.yellowpages-notification').removeClass('success');
				}, 2000);
				return false;
			}
			if (!isAlphaNumeric(username) || username.length > 30) {
				$('.yellowpages-notification').show();
				$('.yellowpages-notification').text('Invalid username!');
				$('.yellowpages-notification').removeClass('success');
				$('.yellowpages-notification').addClass('error');
				window.setTimeout(function() {
					$('.yellowpages-notification').hide();
					$('.yellowpages-notification').text('');
					$('.yellowpages-notification').removeClass('error');
					$('.yellowpages-notification').removeClass('success');
				}, 2000);
				return false;
			}
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "createAccount",
				accountType: "yellowpages",
				accountUsername: username,
				accountPassword: password,
				accountDisplayname: username
			}));

			APICallback.then(function(data) {
				if (data.status) {
					$('.yellowpages-notification').show();
					$('.yellowpages-notification').text(data.message);
					$('.yellowpages-notification').addClass('success');
					$('.yellowpages-notification').removeClass('error');
					window.setTimeout(function() {
						hideContent();
						$('.yellowpages-notification').hide();
						$('.yellowpages-notification').text('');
						$('.app-yellowpages').addClass('d-block');
						$('.yellowpages-notification').removeClass('error');
						$('.yellowpages-notification').removeClass('success');
					}, 1000);
				} else {
					$('.yellowpages-notification').show();
					$('.yellowpages-notification').text(data.message);
					$('.yellowpages-notification').removeClass('success');
					$('.yellowpages-notification').addClass('error');
					window.setTimeout(function() {
						$('.yellowpages-notification').hide();
						$('.yellowpages-notification').text('');
						$('.yellowpages-notification').removeClass('error');
						$('.yellowpages-notification').removeClass('success');
					}, 1000);
				}
			})
			clearInputs();
			syncPhone();
		});

		$('.yellowpages-signin-form .yellowpages-signin-submit').click(function() {
			var username = $('.yellowpages-signin-username').val();
			var password = $('.yellowpages-signin-password').val();
			if (!username || !password) {
				$('.yellowpages-notification').show();
				$('.yellowpages-notification').text('Please fill in all fields!');
				$('.yellowpages-notification').removeClass('success');
				$('.yellowpages-notification').addClass('error');
				window.setTimeout(function() {
					$('.yellowpages-notification').hide();
					$('.yellowpages-notification').text('');
					$('.yellowpages-notification').removeClass('error');
					$('.yellowpages-notification').removeClass('success');
				}, 2000);
				return false;
			}
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "loginToAccount",
				accountType: "yellowpages",
				accountUsername: username,
				accountPassword: password
			}));

			APICallback.then(function(data) {
				if (data.status) {
					$('.yellowpages-notification').show();
					$('.yellowpages-notification').text(data.message);
					$('.yellowpages-notification').addClass('success');
					$('.yellowpages-notification').removeClass('error');
					window.setTimeout(function() {
						hideContent();
						$('.yellowpages-notification').hide();
						$('.app-yellowpages').addClass('d-block');
						$('.yellowpages-notification').text('');
						$('.yellowpages-notification').removeClass('error');
						$('.yellowpages-notification').removeClass('success');
					}, 1000);
				} else {
					$('.yellowpages-notification').show();
					$('.yellowpages-notification').text(data.message);
					$('.yellowpages-notification').removeClass('success');
					$('.yellowpages-notification').addClass('error');
					window.setTimeout(function() {
						$('.yellowpages-notification').hide();
						$('.yellowpages-notification').text('');
						$('.yellowpages-notification').removeClass('error');
						$('.yellowpages-notification').removeClass('success');
					}, 2000);
				}
			})
			clearInputs();
			syncPhone();
		});

		$('.yellowpages-new-form .yellowpages-new-submit').click(function() {
			var advertEmail = $('.yellowpages-new-email').val();
			var advertPhone = $('.yellowpages-new-phone').val();
			var advertContent = $('.yellowpages-new-content').val();
			var advertType = $('.yellowpages-new-advertype option:selected').val();
			var lastPost;
			var utc = moment.utc().format('MM/DD/YYYY HH:mm:ss');
			var now = moment(utc, 'MM/DD/YYYY HH:mm:ss');
			var index = PHONE_ADVERTS.findIndex(function(adverts) {
				return adverts.AdvertAccount == PHONE_YELLOWPAGESID;
			});
			if (index >= 0) {
				lastPost = moment(PHONE_ADVERTS[index]['Timestamp']).format('MM/DD/YYYY HH:mm:ss');
				lastPost = moment(lastPost, 'MM/DD/YYYY HH:mm:ss');
			} else {
				lastPost = moment('01/01/2000 01:01:02', 'MM/DD/YYYY HH:mm:ss');
			}
			var minutes = now.diff(lastPost, 'minutes');
			if (minutes < 15) {

				$('.yellowpages-popup').text('You can only post one (1) advertisement every 15 minutes!');
				$('.yellowpages-popup').fadeIn();
				window.setTimeout(function() {
					$('.yellowpages-popup').fadeOut();
					$('.yellowpages-popup').text('');
				}, 3000);
				return false;
			}
			if (!advertEmail || !advertPhone || !advertType) {
				$('.yellowpages-popup').text('Please fill in every field!');
				$('.yellowpages-popup').fadeIn();
				window.setTimeout(function() {
					$('.yellowpages-popup').fadeOut();
					$('.yellowpages-popup').text('');
				}, 2000);
				return false;
			}
			if (!isEmail(advertEmail)) {
				$('.yellowpages-popup').text('Please enter a valid email addres!');
				$('.yellowpages-popup').fadeIn();
				window.setTimeout(function() {
					$('.yellowpages-popup').fadeOut();
					$('.yellowpages-popup').text('');
				}, 2000);
				return false;
			}
			$('.yellowpages-notification').show();
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "advert",
				advertAccount: PHONE_YELLOWPAGESUSERNAME,
				advertPhone: advertPhone,
				advertEmail: advertEmail,
				advertContent: advertContent,
				advertType: advertType
			}));
			clearInputs();
			hideContent();
			syncPhone();
			$('.app-yellowpages').addClass('d-block');
		});

		$('.state-debt-submit').click(function() {
			var payAmount = $('.state-debt-amount').val();
			var transferFrom = $('.state-debt-bankaccount option:selected').val();
			var bankAccountNumber = PHONE_BANKACCOUNTS[transferFrom].AccountNumber;
			if (!payAmount || !payAmount.match(/^\d+$/) || !transferFrom || !bankAccountNumber) {
				$('.state-debt-notification').show();
				$('.state-debt-notification').text('Invalid information entered');
				$('.state-debt-notification').addClass('error');
				window.setTimeout(function() {
					$('.state-debt-notification').hide();
					$('.state-debt-notification').text('');
					$('.state-debt-notification').removeClass('error');
				}, 2000);
				return false;
			}
			if (PHONE_STATEDEBT <= 0) {
				$('.state-debt-notification').show();
				$('.state-debt-notification').text('You do not have a balance to pay.');
				$('.state-debt-notification').addClass('error');
				window.setTimeout(function() {
					$('.state-debt-notification').hide();
					$('.state-debt-notification').text('');
					$('.state-debt-notification').removeClass('error');
				}, 2000);
				return false;
			}
			if (payAmount > PHONE_STATEDEBT) {
				payAmount = PHONE_STATEDEBT;
			}
			if (payAmount > PHONE_BANKACCOUNTS[transferFrom].Balance) {
				$('.state-debt-notification').show();
				$('.state-debt-notification').text('Payment denied - Not enough funds!');
				$('.state-debt-notification').addClass('error');
				window.setTimeout(function() {
					$('.state-debt-notification').hide();
					$('.state-debt-notification').text('');
					$('.state-debt-notification').removeClass('error');
				}, 2000);
				return false;
			}
			
			var APICallback = PerformAPICallback('pushEvent', JSON.stringify({
				eventType: "paystatedebt",
				fromAccount: bankAccountNumber,
				amount: payAmount
			}));

			$('.state-debt-notification').show();
			$('.state-debt-notification').text('You successfully paid $' + commaSeparateNumber(payAmount) + '!');
			$('.state-debt-notification').addClass('success');
			window.setTimeout(function() {
				$('.state-debt-notification').hide();
				$('.state-debt-notification').text('');
				$('.state-debt-notification').removeClass('success');
			}, 4000);
			syncPhone();
			$('.state-debt-amount').val('');
		});

		$(".valet-search").bind("change keyup input", function() {
			var filter = $(this).val(),
				count = 0;
			$('.vehicles-container .vehicle').each(function() {
				if ($(this).text().search(new RegExp(filter, "i")) < 0) {
					$(this).hide();
				} else {
					$(this).show();
					count++;
				}
			});
			$('.valet-search-count').text(count + ' Results found');
		});

		$(".contacts-search").bind("change keyup input", function() {
			var filter = $(this).val(),
				count = 0;
			$('.contacts-container .contact-row').each(function() {
				if ($(this).text().search(new RegExp(filter, "i")) < 0) {
					$(this).hide();
				} else {
					$(this).show();
					count++;
				}
			});
			$('.contacts-search-count').text(count + ' Results found');
		});

		$(".adverts-search").bind("change keyup input", function() {
			var filter = $(this).val(),
				count = 0;
			$('.adverts-container .advert').each(function() {
				if ($(this).text().search(new RegExp(filter, "i")) < 0) {
					$(this).hide();
				} else {
					$(this).show();
				}
			});
		});

		$(".emails-outbox-search").bind("change keyup input", function() {
			var filter = $(this).val(),
				count = 0;
			$('.email-outbound-container .email').each(function() {
				if ($(this).text().search(new RegExp(filter, "i")) < 0) {
					$(this).hide();
				} else {
					$(this).show();
				}
			});
		});

		$(".emails-inbox-search").bind("change keyup input", function() {
			var filter = $(this).val(),
				count = 0;
			$('.email-inbound-container .email').each(function() {
				if ($(this).text().search(new RegExp(filter, "i")) < 0) {
					$(this).hide();
				} else {
					$(this).show();
				}
			});
		});

		// var bounds = [[-26.5,-25], [1021.5,1023]];
		// var map = L.map('mapContainer', {
		//     crs: L.CRS.Simple,
		//     minZoom: 1,
		//     maxBounds: bounds,
		//     maxBoundsViscosity: 1.0
		// });

		// var image = L.imageOverlay('images/map.png', bounds).addTo(map);
		// map.fitBounds(bounds);
	});
