var minRot = -90,
    maxRot = 90,
    solveDeg = (Math.random() * 180) - 90,
    solvePadding = 4,
    maxDistFromSolve = 45,
    pinRot = 0,
    cylRot = 0,
    lastMousePos = 0,
    mouseSmoothing = 2,
    keyRepeatRate = 25,
    cylRotSpeed = 3,
    pinDamage = 20,
    pinHealth = 220,
    pinDamageInterval = 150,
    numPins = 1,
    userPushingCyl = false,
    gameOver = false,
    gamePaused = false,
    pin, cyl, driver, cylRotationInterval, pinLastDamaged;

// NUI EVENT LISTENER
window.addEventListener("message", function(event) {
    switch(event.data.action) {
        case "toggleLockpicking":
            ToggleLockpickingMinigame(event.data);
            break;
    }
})

// CLOSES LOCKPICK MINIGAME WHEN 'ESCAPE' IS PRESSED
$(function() {
    pin = $("#pin");
    cyl = $("#cylinder");
    driver = $("#driver");
    $(document).on("keydown", function(event) {
        if (event.key == "Escape") {
            $.post("https://soe-challenge/Lockpicking.Exit");
        }
    });
});

// MAIN TOGGLE FUNCTION
function ToggleLockpickingMinigame(data) {
    if (data.toggle) {
        $("#lockpicking-container").hide();
        gameOver = false
        gamePaused = false

        $("#lockpicking-container").fadeIn(250);
        $("body").on("mousemove", function (e) {
            if (lastMousePos && !gameOver && !gamePaused) {
                var pinRotChange = (e.clientX - lastMousePos) / mouseSmoothing;
                pinRot += pinRotChange;
                pinRot = Util.clamp(pinRot, maxRot, minRot);
                $("#pin").css({
                    transform: "rotateZ(" + pinRot + "deg)"
                })
            }
            lastMousePos = e.clientX;
        });
    
        $("body").on("mouseleave", function (e) {
            lastMousePos = 0;
        });
    
        $("body").on("keydown", function (e) {
            if ((e.keyCode == 87 || e.keyCode == 65 || e.keyCode == 83 || e.keyCode == 68 || e.keyCode == 37 || e.keyCode == 39) && !userPushingCyl && !gameOver && !gamePaused) {
                pushCyl();
            }
        });

        $("body").on("keyup", function (e) {
            if ((e.keyCode == 87 || e.keyCode == 65 || e.keyCode == 83 || e.keyCode == 68 || e.keyCode == 37 || e.keyCode == 39) && !gameOver) {
                unpushCyl();
            }
        });

        // TOUCH HANDLERS
        $("body").on("touchstart", function (e) {
            if (!e.touchList) {
            } else if (e.touchList) {
            }
        });
    } else {
        $("#lockpicking-container").fadeOut(450);
        gameOver = false
        gamePaused = false
    }
}

//CYL INTERACTIVITY EVENTS
function pushCyl() {
    var distFromSolve, cylRotationAllowance;
    clearInterval(cylRotationInterval);
    userPushingCyl = true;

    distFromSolve = Math.abs(pinRot - solveDeg) - solvePadding;
    distFromSolve = Util.clamp(distFromSolve, maxDistFromSolve, 0);

    cylRotationAllowance = Util.convertRanges(distFromSolve, 0, maxDistFromSolve, 1, 0.02);
    cylRotationAllowance = cylRotationAllowance * maxRot;

    cylRotationInterval = setInterval(function () {
        cylRot += cylRotSpeed;
        if (cylRot >= maxRot) {
            cylRot = maxRot;
            clearInterval(cylRotationInterval);
            unlock();
        }
        else if (cylRot >= cylRotationAllowance) {
            cylRot = cylRotationAllowance;
            damagePin();
        }

        cyl.css({
            transform: "rotateZ(" + cylRot + "deg)"
        });
        driver.css({
            transform: "rotateZ(" + cylRot + "deg)"
        });
    }, keyRepeatRate);
}

function unpushCyl() {
    userPushingCyl = false;
    clearInterval(cylRotationInterval);
    cylRotationInterval = setInterval(function () {
        cylRot -= cylRotSpeed;
        cylRot = Math.max(cylRot, 0);
        cyl.css({
            transform: "rotateZ(" + cylRot + "deg)"
        })

        driver.css({
            transform: "rotateZ(" + cylRot + "deg)"
        })

        if (cylRot <= 0) {
            cylRot = 0;
            clearInterval(cylRotationInterval);
        }
    }, keyRepeatRate);
}

//PIN AND SOLVE EVENTS
function damagePin() {
    if (!pinLastDamaged || Date.now() - pinLastDamaged > pinDamageInterval) {
        var tl = new TimelineLite();
        pinHealth -= pinDamage;
        pinLastDamaged = Date.now()
        
        tl.to(pin, (pinDamageInterval / 4) / 1000, {
            rotationZ: pinRot - 2
        });
        tl.to(pin, (pinDamageInterval / 4) / 1000, {
            rotationZ: pinRot
        });

        if (pinHealth <= 0) {
            breakPin();
        }
    }
}

function breakPin() {
    var tl, pinTop, pinBott;
    gamePaused = true;
    clearInterval(cylRotationInterval);
    numPins--;
    $("span").text(numPins)
    pinTop = pin.find(".top");
    pinBott = pin.find(".bott");
    tl = new TimelineLite();
    tl.to(pinTop, 0.7, {
        rotationZ: -400,
        x: -200,
        y: -100,
        opacity: 0
    });
    tl.to(pinBott, 0.7, {
        rotationZ: 400,
        x: 200,
        y: 100,
        opacity: 0,
        onComplete: function () {
            if (numPins > 0) {
                gamePaused = false;
                reset();
            } else {
                outOfPins();
            }
        }
    }, 0)
    $.post("https://soe-challenge/Lockpicking.Failure", JSON.stringify({
        broken: true,
        success: false
    }));
    tl.play();
}

function reset() {
    cylRot = 0;
    pinHealth = 220;
    pinRot = 0;
    pin.css({
        transform: "rotateZ(" + pinRot + "deg)"
    })
    cyl.css({
        transform: "rotateZ(" + cylRot + "deg)"
    })
    driver.css({
        transform: "rotateZ(" + cylRot + "deg)"
    })
    TweenLite.to(pin.find(".top"), 0, {
        rotationZ: 0,
        x: 0,
        y: 0,
        opacity: 1
    });
    TweenLite.to(pin.find(".bott"), 0, {
        rotationZ: 0,
        x: 0,
        y: 0,
        opacity: 1
    });
}

function outOfPins() {
    gameOver = true;
    $.post("https://soe-challenge/Lockpicking.Failure", JSON.stringify({
        broken: false,
        success: false
    }));
    setTimeout(function(){
        reset()
    }, 250)
}

function unlock() {
    gameOver = true;
    $.post("https://soe-challenge/Lockpicking.Success", JSON.stringify({
        success: true
    }));
    solveDeg = (Math.random() * 180) - 90
    solvePadding = 4
    maxDistFromSolve = 45
    pinRot = 1
    cylRot = 1
    lastMousePos = 0
    pinHealth = 220;
}

// UTIL FUNCTIONS
Util = {};

Util.clamp = function (val, max, min) {
    return Math.min(Math.max(val, min), max);
}
Util.convertRanges = function (OldValue, OldMin, OldMax, NewMin, NewMax) {
    return (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
}
