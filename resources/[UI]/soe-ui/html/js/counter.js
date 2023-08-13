// NUI EVENT LISTENER
window.addEventListener("message", (event) => {
    let data = event.data
    switch(data.type) {
        case "Counter.Toggle":
            TogglePlayerCounter(data.show, data.maxPlayers, data.players);
            break;
    }
})

// DISPLAYS TABLET UI
function TogglePlayerCounter(show, maxPlayers, players) {
    if (show) {
        // CALCULATE TIME UNTIL RAPTURE
        var targetTimezone = "UTC";
        var now = moment().tz(targetTimezone);

        var target;
        var target8am = moment(now.hour(8).minute(0).second(0));
        now = moment().tz(targetTimezone);
    
        // RAPTURE WILL BE AT 4AM EST | 1AM PST | 8AM GMT/UTC
        target = target8am;
        if (now.isAfter(target8am)) {
            target = moment(target8am.add(1, "day"));
        }

        // MAKE COUNTER APPEAR AND FILL DATA
        $("#counter_container").fadeIn(150);
        $("#counter_text").html(`
            Players: <span id="counter_content">${players} / ${maxPlayers}</span>
            &nbsp;&nbsp;Restart: <span id="counter_content">${moment.preciseDiff(now, target)}</span>
        `);
    } else {
        $("#counter_container").fadeOut(150);
    }
}
