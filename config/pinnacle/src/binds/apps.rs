use pinnacle_api::Keysym;
use pinnacle_api::input::Bind;
use pinnacle_api::input::{self, Mod};
use pinnacle_api::process::Command;

use crate::expand;

pub fn binds(mod_key: Mod) {
    let terminal = "foot";

    // `mod_key + Return` spawns a terminal with tmux
    input::keybind(mod_key, Keysym::Return)
        .on_press(move || {
            Command::new(terminal).args(["tmux", "new"]).spawn();
        })
        .group("Process")
        .description("Spawn a terminal + tmux");

    // `mod_key + Shift + Return` spawns a terminal
    input::keybind(mod_key | Mod::SHIFT, Keysym::Return)
        .on_press(move || {
            Command::new(terminal).spawn();
        })
        .group("Process")
        .description("Spawn a terminal");

    // `mod_key + Space` spawns fuzzel
    input::keybind(mod_key, Keysym::space)
        .on_press(move || {
            Command::new("fuzzel").spawn();
        })
        .group("Process")
        .description("Spawn fuzzel");

    // `mod_key + Shift + e` launch session menu
    input::keybind(mod_key | Mod::SHIFT, Keysym::e)
        .on_press(move || {
            Command::new(expand("~/dotfiles/config/locker/menu.sh")).spawn();
        })
        .group("Process")
        .description("Session Menu");
}
