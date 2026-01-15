use pinnacle_api::Keysym;
use pinnacle_api::input;
use pinnacle_api::input::Bind;
use pinnacle_api::input::Mod;
use pinnacle_api::util::Direction;
use pinnacle_api::window::get_focused;

pub fn binds(mod_key: Mod) {
    input::keybind(mod_key, Keysym::Left)
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(closest) = focused.in_direction(Direction::Left).next()
            {
                closest.set_focused(true);
            }
        })
        .group("Navigation")
        .description("Focus window left");
    input::keybind(mod_key, 'h')
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(closest) = focused.in_direction(Direction::Left).next()
            {
                closest.set_focused(true);
            }
        })
        .group("Navigation")
        .description("Focus window left");

    input::keybind(mod_key, Keysym::Right)
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(closest) = focused.in_direction(Direction::Right).next()
            {
                closest.set_focused(true);
            }
        })
        .group("Navigation")
        .description("Focus window right");
    input::keybind(mod_key, 'l')
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(closest) = focused.in_direction(Direction::Right).next()
            {
                closest.set_focused(true);
            }
        })
        .group("Navigation")
        .description("Focus window right");

    input::keybind(mod_key, Keysym::Up)
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(closest) = focused.in_direction(Direction::Up).next()
            {
                closest.set_focused(true);
            }
        })
        .group("Navigation")
        .description("Focus window up");
    input::keybind(mod_key, 'k')
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(closest) = focused.in_direction(Direction::Up).next()
            {
                closest.set_focused(true);
            }
        })
        .group("Navigation")
        .description("Focus window up");

    input::keybind(mod_key, Keysym::Down)
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(closest) = focused.in_direction(Direction::Down).next()
            {
                closest.set_focused(true);
            }
        })
        .group("Navigation")
        .description("Focus window down");
    input::keybind(mod_key, 'j')
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(closest) = focused.in_direction(Direction::Down).next()
            {
                closest.set_focused(true);
            }
        })
        .group("Navigation")
        .description("Focus window down");
}
