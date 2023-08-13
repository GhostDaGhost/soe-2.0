var digits = ["Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"]

// NUI EVENT LISTENER
window.onload = function() {
    window.addEventListener("message", function (event) {
        switch(event.data.type) {
            case "showUI":
                $("#container").fadeIn();
                break;
            case "hideUI":
                $("#container").fadeOut();
                break;
            case "setSpeed":
                SetRadarSpeed(event.data.speed);
                break;
        }
    });
}

function SetRadarSpeed(speed) {
    speed = speed.toString();
    while (speed.length < 3) {
        speed = "0" + speed;
    }

    var digitOne = speed.substring(0, 1);
    var digitTwo = speed.substring(1, 2);
    var digitThree = speed.substring(2, 3);

    if (digitOne != "E" && digitOne != "R") {
        $("#digitOne").removeClass();
        $("#digitOne").addClass("digit dig" + digits[digitOne]);
    } else {
        $("#digitOne").removeClass();
        $("#digitOne").addClass("digit dig" + digitOne);
    }

    if (digitTwo != "E" && digitTwo != "R") {
        $("#digitTwo").removeClass();
        $("#digitTwo").addClass("digit dig" + digits[digitTwo]);
    } else {
        $("#digitTwo").removeClass();
        $("#digitTwo").addClass("digit dig" + digitTwo);
    }

    if (digitThree != "E" && digitThree != "R") {
        $("#digitThree").removeClass();
        $("#digitThree").addClass("digit dig" + digits[digitThree]);
    } else {
        $("#digitThree").removeClass();
        $("#digitThree").addClass("digit dig" + digitThree);
    }
}
