use pinnacle_api::input;
use pinnacle_api::input::Bind;
use pinnacle_api::input::Keysym;
use pinnacle_api::input::Mod;
use pinnacle_api::process::Command;

use crate::expand;

pub fn binds(mod_key: Mod) {
    input::keybind(Mod::empty(), Keysym::XF86_MonBrightnessUp)
        .on_press(|| {
            Command::new(expand("~/dotfiles/tools/brightness.sh"))
                .args(["up"])
                .spawn();
        })
        .allow_when_locked()
        .group("Display")
        .description("Increase display brightness by 5%");

    input::keybind(Mod::empty(), Keysym::XF86_MonBrightnessDown)
        .on_press(|| {
            Command::new(expand("~/dotfiles/tools/brightness.sh"))
                .args(["down"])
                .spawn();
        })
        .allow_when_locked()
        .group("Display")
        .description("Decrease display brightness by 5%");

    input::keybind(mod_key | Mod::SHIFT, Keysym::slash)
        .on_press(|| {
            Command::new(expand("pinnacle-ctl"))
                .args(["output-toggle", "*"])
                .spawn();
        })
        .allow_when_locked()
        .group("Display")
        .description("Power on monitors");
}
