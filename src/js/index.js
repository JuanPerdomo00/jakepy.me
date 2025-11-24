/*
 GPLv3 2025 Jakepys
*/

document.addEventListener('DOMContentLoaded', () => {
    const nick = document.getElementById('nick');

    const text = nick.innerText;
    const glitchInterval = 5000;
    const glitchDuration = 800;
    const frameRate = 90;

    const chars = "010xFffaBaCf";

    let randomChar = () => {
        return chars.charAt(Math.floor(Math.random() * chars.length));
    }

    let isGlitching = false;

    let runGlitch = () => {
        if (isGlitching) return;
        isGlitching = true;
        const len = Math.max(1, text.length);
        let elapsed = 0;

        const tick = setInterval(() => {
            let out = '';
            for (let i = 0; i < len; i++) {
                out += Math.random() < 0.6 ? randomChar() : text[i] || randomChar();
            }
            nick.style.color = "pink";
            nick.innerText = out;

            elapsed += frameRate;
            if (elapsed >= glitchDuration) {
                clearInterval(tick);
                nick.innerText = text;
                nick.style.color = ""
                isGlitching = false;
            }
        }, frameRate);
    }

    setInterval(runGlitch, glitchInterval);
});

randomChar()