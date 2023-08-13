var player1, player2, player3, player4, player5, player6, player7, player8, player9, player10, player11, player12, player13, player14, player15, player16, player17, player18, player19;
var players = {player1, player2, player3, player4, player5, player6, player7, player8, player9, player10, player11, player12, player13, player14, player15, player16, player17, player18, player19};

var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";

var ytScript = document.getElementsByTagName('script')[0];
ytScript.parentNode.insertBefore(tag, ytScript);

// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let data = event.data
    switch(data.type) {
        case 'ShowBoomboxUI':
            ShowBoomboxUI();
            break;
        case 'StartBoomboxSound':
            play(data.url, data.uid);
            break;
        case 'StopBoomboxSound':
            stop(data.uid);
            break;
        case 'PauseBoomboxSound':
            pause(data.uid);
            break;
        case 'ResumeBoomboxSound':
            resume(data.uid);
            break;
        case 'ModifyBoomboxSound':
            setVolume(data.volume, data.uid);
            break;
    }
})

// WHEN TRIGGERED, MAKE OUR PLACEHOLDER BOOMBOXES (MAXIMUM OF 10 BOOMBOXES IN THE SERVER)
function onYouTubeIframeAPIReady() {
    players[1] = new YT.Player("player1", {width: '1', height: '', playerVars: {'autoplay': 0,'controls': 0,'disablekb': 1,'enablejsapi': 1,}, events: {'onReady': onPlayerReady,'onStateChange': onPlayerStateChange,'onError': onPlayerError}});
    players[2] = new YT.Player("player2", {width: '1', height: '', playerVars: {'autoplay': 0,'controls': 0,'disablekb': 1,'enablejsapi': 1,}, events: {'onReady': onPlayerReady,'onStateChange': onPlayerStateChange,'onError': onPlayerError}});
    players[3] = new YT.Player("player3", {width: '1', height: '', playerVars: {'autoplay': 0,'controls': 0,'disablekb': 1,'enablejsapi': 1,}, events: {'onReady': onPlayerReady,'onStateChange': onPlayerStateChange,'onError': onPlayerError}});
    players[4] = new YT.Player("player4", {width: '1', height: '', playerVars: {'autoplay': 0,'controls': 0,'disablekb': 1,'enablejsapi': 1,}, events: {'onReady': onPlayerReady,'onStateChange': onPlayerStateChange,'onError': onPlayerError}});
    players[5] = new YT.Player("player5", {width: '1', height: '', playerVars: {'autoplay': 0,'controls': 0,'disablekb': 1,'enablejsapi': 1,}, events: {'onReady': onPlayerReady,'onStateChange': onPlayerStateChange,'onError': onPlayerError}});
    players[6] = new YT.Player("player6", {width: '1', height: '', playerVars: {'autoplay': 0,'controls': 0,'disablekb': 1,'enablejsapi': 1,}, events: {'onReady': onPlayerReady,'onStateChange': onPlayerStateChange,'onError': onPlayerError}});
    players[7] = new YT.Player("player7", {width: '1', height: '', playerVars: {'autoplay': 0,'controls': 0,'disablekb': 1,'enablejsapi': 1,}, events: {'onReady': onPlayerReady,'onStateChange': onPlayerStateChange,'onError': onPlayerError}});
    players[8] = new YT.Player("player8", {width: '1', height: '', playerVars: {'autoplay': 0,'controls': 0,'disablekb': 1,'enablejsapi': 1,}, events: {'onReady': onPlayerReady,'onStateChange': onPlayerStateChange,'onError': onPlayerError}});
    players[9] = new YT.Player("player9", {width: '1', height: '', playerVars: {'autoplay': 0,'controls': 0,'disablekb': 1,'enablejsapi': 1,}, events: {'onReady': onPlayerReady,'onStateChange': onPlayerStateChange,'onError': onPlayerError}});
    players[10] = new YT.Player("player10", {width: '1', height: '', playerVars: {'autoplay': 0,'controls': 0,'disablekb': 1,'enablejsapi': 1,}, events: {'onReady': onPlayerReady,'onStateChange': onPlayerStateChange,'onError': onPlayerError}});
}

function onPlayerReady(event) {
    title = event.target.getVideoData().title;
    for (src = 0; src < players.length; src++) {
        players[src].setVolume(0.0001);
    }
}

function onPlayerStateChange(event) {
    switch(event.data) {
        case YT.PlayerState.PLAYING:
            title = event.target.getVideoData().title;
            break;
        case YT.PlayerState.ENDED:
            //musicIndex++;
            $('#boombox_url_input').val('');
            play();
            break;
    }
}

function onPlayerError(event) {
    $.post("https://soe-ux/Boombox.SendErrorCode", JSON.stringify({}));
    switch(event.data) {
        case 2:
            console.log("The video id seems invalid, wrong video id?");
            break;
        case 5:
            console.log("An HTML 5 player issue occurred.");
            break;
        case 100:
            console.log("Video does not exist, wrong video id?");
            break;
        case 150:
            console.log("Embedding for video ID was not allowed.");
            console.log("Please consider removing this video from the playlist.")
            break;
        default:
            console.log("An unknown error occured when playing this video (1)");
            break;
    }
    skip();
}

function skip() {
    play();
}

function play(id, p) {
    title = "n.a.";
    players[p].loadVideoById(id, 0, "tiny");
    players[p].playVideo();
}

function resume(src) {
    players[src].playVideo();
}

function pause(src) {
    players[src].pauseVideo();
}

function stop(src) {
    players[src].stopVideo();
}

function setVolume(volume, src) {
    players[src].setVolume(volume)
}

function ShowBoomboxUI() {
    $("#boombox_container").fadeIn(300);
}

function CloseBoomboxUI() {
    $.post("https://soe-ux/Boombox.CloseUI", JSON.stringify({}));
    $("#boombox_container").fadeOut(250);
}

// WHEN TRIGGERED, PLAY MUSIC AND SEND TO LUA
function PlayButtonClicked() {
    let $url = $('#boombox_url_input').val();
    if ($url == '') {
        return;
    }

    $.post("https://soe-ux/Boombox.SoundManagement", JSON.stringify({
        type: 'Play Music',
        musicURL: $url
    }));
}

// WHEN TRIGGERED, PAUSE MUSIC AND SEND TO LUA
function PauseButtonClicked() {
    $.post("https://soe-ux/Boombox.SoundManagement", JSON.stringify({
        type: 'Pause Music'
    }));/*.done(function (data) {
        if (data.status) {
            console.log("SOURCE BOOMBOX: " + data.src);
            pause(data.src);
        } else {
            console.log("FAILED TO PAUSE THIS BOOMBOX!");
        }
    });*/
}

// GENERAL INTERACTION FUNCTION
$(() => {
    // CLOSES BOOMBOX WHEN 'ESCAPE' OR 'TAB' IS PRESSED
    $(document).on("keydown", (event) => {
        switch(event.key) {
            case "Escape":
                CloseBoomboxUI()
                break;
            case "Tab":
                CloseBoomboxUI()
                break;
        }
    });
})
