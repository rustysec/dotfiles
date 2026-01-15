use pinnacle_api::input;
use pinnacle_api::input::Bind;
use pinnacle_api::input::Keysym;
use pinnacle_api::input::Mod;
use pinnacle_api::process::Command;

pub fn binds(_mod_key: Mod) {
    input::keybind(Mod::empty(), Keysym::XF86_AudioRaiseVolume)
        .on_press(|| {
            Command::new("wpctl")
                .args(["set-volume", "@DEFAULT_AUDIO_SINK@", "0.02+", "-l", "1.0"])
                .spawn();
        })
        .allow_when_locked()
        .group("Media")
        .description("Increase volume by 2%");

    input::keybind(Mod::empty(), Keysym::XF86_AudioLowerVolume)
        .on_press(|| {
            Command::new("wpctl")
                .args(["set-volume", "@DEFAULT_AUDIO_SINK@", "0.02-", "-l", "1.0"])
                .spawn();
        })
        .allow_when_locked()
        .group("Media")
        .description("Decrease volume by 2%");

    input::keybind(Mod::empty(), Keysym::XF86_AudioMute)
        .on_press(|| {
            Command::new("wpctl")
                .args(["set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
                .spawn();
        })
        .allow_when_locked()
        .group("Media")
        .description("Toggle mute");

    input::keybind(Mod::empty(), Keysym::XF86_AudioMicMute)
        .on_press(|| {
            Command::new("wpctl")
                .args(["set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"])
                .spawn();
        })
        .allow_when_locked()
        .group("Media")
        .description("Toggle mic mute");

    input::keybind(Mod::empty(), Keysym::XF86_AudioPlay)
        .on_press(|| {
            Command::new("playerctl").arg("play-pause").spawn();
        })
        .allow_when_locked()
        .group("Media")
        .description("Play/pause media");

    input::keybind(Mod::empty(), Keysym::XF86_AudioStop)
        .on_press(|| {
            Command::new("playerctl").arg("stop").spawn();
        })
        .allow_when_locked()
        .group("Media")
        .description("Stop media");

    input::keybind(Mod::empty(), Keysym::XF86_AudioNext)
        .on_press(|| {
            Command::new("playerctl").arg("next").spawn();
        })
        .allow_when_locked()
        .group("Media")
        .description("Go to next media");

    input::keybind(Mod::empty(), Keysym::XF86_AudioPrev)
        .on_press(|| {
            Command::new("playerctl").arg("previous").spawn();
        })
        .allow_when_locked()
        .group("Media")
        .description("Go to previous media");
}
