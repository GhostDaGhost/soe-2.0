var audioPlayer = null;
var cancelledTimer = null;

// NUI EVENT LISTENER
window.onload = () => {
    window.addEventListener("message", (event) => {
        switch(event.data.action) {
            case "playSound":
                PlaySound(event.data);
                break;
            case "cancelProgressBar":
                TerminateProgressBar();
                break;
            case "startProgressBar":
                DoProgressBar(event.data);
                break;
            case "killSound":
                if (audioPlayer != null) {
                    audioPlayer.pause();
                    audioPlayer = null
                }
                break;
            case "toggleXYZ":
                ToggleXYZDisplay(event.data)
                break;
            case "copyToClipboard":
                const el = document.createElement("textarea");
                el.value = event.data.data;
                document.body.appendChild(el);
                el.select();
                document.execCommand("copy");
                document.body.removeChild(el);
                break;
		    default:
			    console.log("Invalid type passed to NUI (" + event.data.type + ")");
			    break;
        }
    });
}

// PLAYS A SOUND
function PlaySound(data) {
    // CHECK IF WE ALREADY HAVE AN AUDIO PLAYING
    if (audioPlayer != null) {
        audioPlayer = null
    }

    // PLAY SOUND WITH SPECIFIED FILE/VOLUME
    audioPlayer = new Audio("sounds/" + data.file);
    audioPlayer.volume = data.volume;
    audioPlayer.play();
}

// TOGGLES XYZ AND HEADING DISPLAY
function ToggleXYZDisplay(data) {
    if (data.bool) {
        $(".xyz_text").fadeIn(350);
        $(".xyz_text").html(
            `X: <span style='color:#22a0c7;'>${data.info.x}</span> 
            Y: <span style='color:#22a0c7;'>${data.info.y}</span> 
            Z: <span style='color:#22a0c7;'>${data.info.z}</span> 
            H: <span style='color:#22a0c7;'>${data.info.hdg}</span>`
        );
    } else {
        $(".xyz_text").fadeOut(350);
    }
};

// TERMINATES ACTIVE PROGRESS BAR
function TerminateProgressBar() {
    $("#progress-label").text("CANCELLED");
    $("#progress-bar").stop().css({"width": "100%", "background-color": "rgba(200, 0, 0, 0.8)"});
    $("#progress-bar").removeClass("cancellable");

    cancelledTimer = setTimeout(function () {
        $(".progress-container").fadeOut("fast", function() {
            $("#progress-bar").css("width", 0);
            $.post("https://soe-utils/actionCancel", JSON.stringify({}));
        });
    }, 1000);
};

// MAKES A PROGRESS BAR
function DoProgressBar(data) {
    clearTimeout(cancelledTimer);
    $("#progress-label").text(data.label);

    $(".progress-container").fadeIn("fast", function() {
        $("#progress-bar").stop().css({"width": 0, "background-color": "rgba(104, 9, 9, 0.80)"}).animate({
            width: "100%"
        }, {
            duration: parseInt(data.duration),
            complete: function() {
                $(".progress-container").fadeOut("fast", function() {
                    $("#progress-bar").removeClass("cancellable");
                    $("#progress-bar").css("width", 0);
                    $.post("https://soe-utils/actionFinish", JSON.stringify({}));
                })
            }
        });
    });
}
