use pinnacle_api::Keysym;
use pinnacle_api::input;
use pinnacle_api::input::Bind;
use pinnacle_api::input::Mod;
use pinnacle_api::util::Direction;
use pinnacle_api::window::{get_all, get_focused};

fn nav_to_window(direction: Direction) {
    if let Some(focused) = get_focused()
        && let Some(closest) = focused.in_direction(direction).next()
    {
        closest.set_focused(true);
    } else if let Some(win) = get_all().find(|win| win.is_on_active_tag()) {
        win.set_focused(true);
    }
}

pub fn binds(mod_key: Mod) {
    input::keybind(mod_key, Keysym::Left)
        .on_press(move || nav_to_window(Direction::Left))
        .group("Navigation")
        .description("Focus window left");
    input::keybind(mod_key, 'h')
        .on_press(move || nav_to_window(Direction::Left))
        .group("Navigation")
        .description("Focus window left");

    input::keybind(mod_key, Keysym::Right)
        .on_press(move || nav_to_window(Direction::Right))
        .group("Navigation")
        .description("Focus window right");
    input::keybind(mod_key, 'l')
        .on_press(move || nav_to_window(Direction::Right))
        .group("Navigation")
        .description("Focus window right");

    input::keybind(mod_key, Keysym::Up)
        .on_press(move || nav_to_window(Direction::Up))
        .group("Navigation")
        .description("Focus window up");
    input::keybind(mod_key, 'k')
        .on_press(move || nav_to_window(Direction::Up))
        .group("Navigation")
        .description("Focus window up");

    input::keybind(mod_key, Keysym::Down)
        .on_press(move || nav_to_window(Direction::Down))
        .group("Navigation")
        .description("Focus window down");
    input::keybind(mod_key, 'j')
        .on_press(move || nav_to_window(Direction::Down))
        .description("Focus window down");
}
