import {Howl, Howler} from 'howler';

let soundPlayers = {};

// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let data = event.data
    switch(data.type) {
        case 'SFX.Play':
            PlaySound(data.soundFile, data.soundVolume, data.soundIdx, data.loop);
            break;
        case 'SFX.Play3D':
            Play3DSound(data.soundFile, data.soundIdx, data.soundPos, data.soundRot);
            break;
        case 'SFX.EndSound':
            EndSound(data.soundIdx);
            break;
        case 'SFX.ModifyVolume':
            Modify3DSound(data.soundIdx, data.soundPos, data.soundRot, data.mute);
            break;
    }
})

// WHEN TRIGGERED, MODIFY A SOUND'S VOLUME
function Modify3DSound(soundIdx: any, soundPos: any, soundRot: any, muteSound: boolean) {
	soundPlayers[soundIdx].mute(muteSound);
	Howler.pos(soundPos.x, soundPos.y, soundPos.z);
	Howler.orientation(soundRot.x, soundRot.y, soundRot.z, 0, 1, 0);
}

// WHEN TRIGGERED, END A SOUND
function EndSound(soundIdx: any) {
    if (soundPlayers[soundIdx] != null) {
        soundPlayers[soundIdx].stop();
        soundPlayers[soundIdx] = null;
    } else {
        console.log(soundIdx + " is not a valid sound index currently.");
    }
}

// WHEN TRIGGERED, PLAY A SOUND
function PlaySound(soundFile: string, soundVolume: number, soundIdx: any, loopSound: boolean) {
    if (soundPlayers[soundIdx] != null) {
        soundPlayers[soundIdx].stop();
        soundPlayers[soundIdx] = null;
    }

    soundPlayers[soundIdx] = new Howl({
        src: ["./sounds/" + soundFile],
        loop: loopSound,
        volume: soundVolume,
        /* onend: function() {
            console.log('Test Finished!');
        }, */
    });

    soundPlayers[soundIdx].volume(soundVolume);
    soundPlayers[soundIdx].play();
}

// WHEN TRIGGERED, PLAY 3D SOUND
function Play3DSound(soundFile: string, soundIdx: any, soundPos: any, soundRot: any) {
    soundPlayers[soundIdx] = new Howl({
        src: ["./sounds/" + soundFile],
		onstop: function() {
            soundPlayers[soundIdx] = null;
            $.post("https://soe-ui/SFX.StopSound", JSON.stringify({
                soundIdx: soundIdx
            }));
		},
		onend: function() {
            soundPlayers[soundIdx] = null;
            $.post("https://soe-ui/SFX.StopSound", JSON.stringify({
                soundIdx: soundIdx
            }));
		},
		onloaderror: function() {
            soundPlayers[soundIdx] = null;
            $.post("https://soe-ui/SFX.StopSound", JSON.stringify({
                soundIdx: soundIdx
            }));
		},
		onplayerror: function() {
            soundPlayers[soundIdx] = null;
            $.post("https://soe-ui/SFX.StopSound", JSON.stringify({
                soundIdx: soundIdx
            }));
		}
    });

	soundPlayers[soundIdx].pos(soundPos.x, soundPos.y, soundPos.z);
	soundPlayers[soundIdx].orientation(soundRot.x, soundRot.y, soundRot.z);
	soundPlayers[soundIdx].volume(0.5);
    soundPlayers[soundIdx].play();

	soundPlayers[soundIdx].pannerAttr({
        panningModel: 'equalpower',
        refDistance: 0.01,
        rolloffFactor: 40,
        distanceModel: 'linear'
    });
}
