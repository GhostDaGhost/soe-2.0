var isAtTheEnd
var checkIfAtGoal
var hasWon = false;
var usingSkillbar = false;

// NUI EVENT LISTENER
window.addEventListener("message", function(event) {
    switch(event.data.game) {
        case "skillbar":
            Skillbar(event.data);
            break;
    }
})

// END THE GAME WHEN 'E' IS PRESSED
document.onkeydown = function (data) {
    if (data.which == 69) {
        if (usingSkillbar) {
            EndSkillbar()
        }
    }
}

// ENDS SKILLBAR GAME
function EndSkillbar() {
    // IF NOT USING A SKILLBAR, RETURN
    if (!usingSkillbar) return;

    // RESET THE SKILLBAR
    clearInterval(isAtTheEnd)
    clearInterval(checkIfAtGoal)
    $("#skillbar-container").animate({top: "110%"}, 350, () => {
        $("#skillbar-container").css("display", "none");
        $("#skillbar-container").remove();
    })

    // CALLBACK TO LUA
    usingSkillbar = false;
    $.post("https://soe-challenge/endSkillbar", JSON.stringify({
        hasWon: hasWon
    }));
}

// SKILLBAR FUNCTION
function Skillbar(data) {
    $('body').append(`
        <div id="skillbar-container">
            <div id="skillbar"></div>
            <div id="skillbar-goal"></div>
            <div id="skillbar-text">PRESS [E] ON WHITE LINE</div>
        </div>
    `)

    hasWon = false;
    usingSkillbar = true;
    let timeAmount = data.speed || 5000;
    let num =  (100 - data.challenge - (Math.random() * 100))
    num = num < 30 ? 30 : num;

    // SHOW THE SKILLBAR VIA SLIDE
    $("#skillbar-goal").css("left", num + "%")
    $("#skillbar-container").css("display", "block");
    $("#skillbar-goal").css("width", data.challenge + "%");
    $("#skillbar-container").animate({top: "75%"}, 355, () => {
        $("#skillbar").css("transition", `all ${timeAmount / 1000}s linear`).css("width", "100%");
    })

    let last = 0;
    let match = 0;
    let elem =  $("#skillbar")
    let range = [$("#skillbar-goal").css("left"), $("#skillbar-goal").css("width")]

    checkIfAtGoal = setInterval(() => {
        let num1 = Number(elem.css('width').split("px")[0])
        let num2 = Number(range[0].split("px")[0])
        let num3 = Number(range[1].split("px")[0])
        if (num1 > num2 && num1 < (num2 + num3)) {
            $("#skillbar-goal").css("background-color", "green");
            hasWon = true;
        } else {
            hasWon = false;
            $("#skillbar-goal").css("background-color", "rgba(255, 250, 250, 0.4)")
        }
    }, 0);

    isAtTheEnd = setInterval(() => {
        let num1 = Number(elem.css("width").split("px")[0])
        if (last == num1) {
            match++
            if (match == 5) {
                EndSkillbar();
            }
        } else {
            match = 0;
        }
        last = num1
    }, 100);
}
