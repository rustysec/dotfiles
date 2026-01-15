use pinnacle_api::Keysym;
use pinnacle_api::input;
use pinnacle_api::input::Bind;
use pinnacle_api::input::Mod;
use pinnacle_api::window;
use pinnacle_api::window::get_focused;

pub fn binds(mod_key: Mod) {
    // `mod_key + shift + c` closes the focused window
    input::keybind(mod_key | Mod::SHIFT, 'q')
        .on_press(|| {
            if let Some(window) = window::get_focused() {
                window.close();
            }
        })
        .group("Window")
        .description("Close the focused window");

    // `mod_key + ctrl + space` toggles floating
    input::keybind(mod_key | Mod::CTRL, Keysym::space)
        .on_press(|| {
            if let Some(window) = get_focused() {
                window.toggle_floating();
                window.raise();
            }
        })
        .group("Window")
        .description("Toggle floating on the focused window");

    // `mod_key + f` toggles fullscreen
    input::keybind(mod_key, 'f')
        .on_press(|| {
            if let Some(window) = get_focused() {
                window.toggle_fullscreen();
                window.raise();
            }
        })
        .group("Window")
        .description("Toggle fullscreen on the focused window");

    // `mod_key + m` toggles maximized
    input::keybind(mod_key, 'm')
        .on_press(|| {
            if let Some(window) = get_focused() {
                window.toggle_maximized();
                window.raise();
            }
        })
        .group("Window")
        .description("Toggle maximized on the focused window");
}
