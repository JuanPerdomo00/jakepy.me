const audio = document.getElementById("bg-audio");
const playBtn = document.getElementById("play-btn");
const muteBtn = document.getElementById("mute-btn");

let isPlaying = false;
let isMuted = false;

playBtn.addEventListener("click", () => {
    if (isPlaying) {
        audio.pause();
        playBtn.textContent = "";
    } else {
        audio.play();
        playBtn.textContent = "";
    }
    isPlaying = !isPlaying;
});

muteBtn.addEventListener("click", () => {
    isMuted = !isMuted;
    audio.muted = isMuted;
    muteBtn.textContent = isMuted ? "" : "";
});
