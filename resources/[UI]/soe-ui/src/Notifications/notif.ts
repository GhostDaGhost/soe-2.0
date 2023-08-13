let notifs = {}

// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let data = event.data
    switch(data.action) {
        case 'Notif.Create':
            ShowNotif(data);
            break;
        case 'Notif.OpenLog':
            OpenLog();
            break;
    }
})

// ************************
//     Async Functions
// ************************
// WHEN TRIGGERED, LOG THE LATEST MYTHIC NOTIFICATION
async function LogThisNotification(notifText: string) {
    if (notifText == undefined) return

    let today = new Date();
    let id = document.getElementById('notification-logs');

    id.innerHTML = id.innerHTML + "<p id = \"logged-notification\">[" + today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds() + "] " + notifText + "</p>"
    id.scrollTop = id.scrollHeight;
}

// ************************
//     Normal Functions
// ************************
// WHEN TRIGGERED, OPENS NOTIFICATION LOG
function OpenLog() {
    $('#notification-logs').fadeIn();
}

// WHEN TRIGGERED, DISABLE NUI FOCUS ON LUA-SIDE
function CloseNotificationLog() {
    $.post("https://soe-ui/Notif.CloseLog", JSON.stringify({}));
    $('#notification-logs').fadeOut();
}

// CREATES A MYTHIC NOTIFICATION
function CreateNotification(data: any) {
    let $notification = $(document.createElement('div'));
    $notification.addClass('notification').addClass(data.type);
    $notification.html(data.text);
    $notification.fadeIn(500);

    if (data.style !== undefined) {
        Object.keys(data.style).forEach(function(css) {
            $notification.css(css, data.style[css])
        });
    }
    return $notification;
}

// UPDATES A MYTHIC NOTIFICATION
function UpdateNotification(data: any) {
    let $notification = $(notifs[data.id])
    $notification.addClass('notification').addClass(data.type);
    $notification.html(data.text);

    if (data.style !== undefined) {
        Object.keys(data.style).forEach(function(css) {
            $notification.css(css, data.style[css])
        });
    }
}

// DISPLAYS A MYTHIC NOTIFICATION
function ShowNotif(data: any) {
    LogThisNotification(data.text);

    if (data.persist != null) {
        if (data.persist.toUpperCase() == 'START') {
            if (notifs[data.id] === undefined) {
                let $notification = CreateNotification(data);
                $('.notif-container').append($notification);
                notifs[data.id] = {
                    notif: $notification  
                };
            } else {
                UpdateNotification(data);
            }
        } else if (data.persist.toUpperCase() == 'END') {
            if (notifs[data.id] != null) {
                let $notification = $(notifs[data.id].notif);
                $.when($notification.fadeOut(3650)).done(function() {
                    $notification.remove();
                    delete notifs[data.id];
                });
            }
        }
    } else {
        if (data.id != null) {
            if (notifs[data.id] === undefined) {
                let $notification = CreateNotification(data);
                $('.notif-container').append($notification);

                notifs[data.id] = {
                    notif: $notification,
                    timer: setTimeout(function() {
                        let $notification = notifs[data.id].notif;
                        $.when($notification.fadeOut(3650)).done(function() {
                            $notification.remove();
                            clearTimeout(notifs[data.id].timer);
                            delete notifs[data.id];
                        });
                    }, data.length != null ? data.length : 2500)
                };
            } else {
                clearTimeout(notifs[data.id].timer);
                UpdateNotification(data);

                notifs[data.id].timer = setTimeout(function() {
                    let $notification = notifs[data.id].notif;
                    $.when($notification.fadeOut(3650)).done(function() {
                        $notification.remove();
                        clearTimeout(notifs[data.id].timer);
                        delete notifs[data.id];
                    });
                }, data.length != null ? data.length : 2500)
            }
        } else {
            let $notification = CreateNotification(data);
            $('.notif-container').append($notification);

            setTimeout(function() {
                $.when($notification.fadeOut(3650)).done(function() {
                    $notification.remove()
                });
            }, data.length != null ? data.length : 2500);
        }
    }
}

$(() => {
    $(document).on('keydown', (event) => {
        switch(event.key) {
            case 'Escape':
                CloseNotificationLog();
                break;
            case 'Tab':
                CloseNotificationLog();
                break;
        }
    });
})
