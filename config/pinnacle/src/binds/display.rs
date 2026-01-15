use pinnacle_api::input;
use pinnacle_api::input::Bind;
use pinnacle_api::input::Keysym;
use pinnacle_api::input::Mod;
use pinnacle_api::process::Command;

pub fn binds(_mod_key: Mod) {
    input::keybind(Mod::empty(), Keysym::XF86_MonBrightnessUp)
        .on_press(|| {
            Command::new("brightnessctl")
                .args(["--class=backlight", "set", "+10%"])
                .spawn();
        })
        .allow_when_locked()
        .group("Display")
        .description("Increase display brightness by 10%");

    input::keybind(Mod::empty(), Keysym::XF86_MonBrightnessDown)
        .on_press(|| {
            Command::new("brightnessctl")
                .args(["--class=backlight", "set", "10%-"])
                .spawn();
        })
        .allow_when_locked()
        .group("Display")
        .description("Decrease display brightness by 10%");
}
