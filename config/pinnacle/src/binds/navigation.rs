use pinnacle_api::Keysym;
use pinnacle_api::input;
use pinnacle_api::input::Bind;
use pinnacle_api::input::Mod;
use pinnacle_api::util::Direction;

fn nav_to_window(direction: Direction) {
    use pinnacle_api::window::{get_all, get_focused};

    if let Some(focused) = get_focused()
        && let Some(closest) = focused.in_direction(direction).next()
    {
        closest.set_focused(true);
    } else if let Some(win) = get_all().find(|win| win.is_on_active_tag()) {
        win.set_focused(true);
    }
}

fn nav_to_output(direction: Direction) {
    use pinnacle_api::output::get_focused;

    if let Some(focused) = get_focused()
        && let Some(closest) = focused.in_direction(direction).next()
    {
        closest.focus();
    }
}

pub fn binds(mod_key: Mod) {
    //
    // ----- Window Navigation
    //
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
        .group("Navigation")
        .description("Focus window down");

    //
    // ----- Output Navigation
    //
    input::keybind(mod_key | Mod::CTRL, Keysym::Left)
        .on_press(move || nav_to_output(Direction::Left))
        .group("Navigation")
        .description("Move window left");
    input::keybind(mod_key | Mod::CTRL, 'h')
        .on_press(move || nav_to_output(Direction::Left))
        .group("Navigation")
        .description("Move window left");

    input::keybind(mod_key | Mod::CTRL, Keysym::Right)
        .on_press(move || nav_to_output(Direction::Right))
        .group("Navigation")
        .description("Move window right");
    input::keybind(mod_key | Mod::CTRL, 'l')
        .on_press(move || nav_to_output(Direction::Right))
        .group("Navigation")
        .description("Move window right");

    input::keybind(mod_key | Mod::CTRL, Keysym::Up)
        .on_press(move || nav_to_output(Direction::Up))
        .group("Navigation")
        .description("Move window up");
    input::keybind(mod_key | Mod::CTRL, 'k')
        .on_press(move || nav_to_output(Direction::Up))
        .group("Navigation")
        .description("Move window up");

    input::keybind(mod_key | Mod::CTRL, Keysym::Down)
        .on_press(move || nav_to_output(Direction::Down))
        .group("Navigation")
        .description("Move window down");
    input::keybind(mod_key | Mod::CTRL, 'j')
        .on_press(move || nav_to_output(Direction::Down))
        .group("Navigation")
        .description("Move window down");
}
