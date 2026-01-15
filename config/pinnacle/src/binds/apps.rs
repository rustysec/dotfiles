use pinnacle_api::Keysym;
use pinnacle_api::input::Bind;
use pinnacle_api::input::{self, Mod};
use pinnacle_api::process::Command;

pub fn binds(mod_key: Mod) {
    let terminal = "foot";

    // `mod_key + Return` spawns a terminal
    input::keybind(mod_key, Keysym::Return)
        .on_press(move || {
            Command::new(terminal).args(["tmux", "new"]).spawn();
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
}
