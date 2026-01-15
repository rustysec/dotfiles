use pinnacle_api::Keysym;
use pinnacle_api::input;
use pinnacle_api::input::Bind;
use pinnacle_api::input::Mod;
use pinnacle_api::util::Direction;
use pinnacle_api::window::get_focused;

pub fn binds(mod_key: Mod) {
    input::keybind(mod_key | Mod::SHIFT, Keysym::Left)
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(other) = focused.in_direction(Direction::Left).next()
            {
                focused.swap(&other);
            }
        })
        .group("Navigation")
        .description("Swap window left");
    input::keybind(mod_key | Mod::SHIFT, 'h')
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(other) = focused.in_direction(Direction::Left).next()
            {
                focused.swap(&other);
            }
        })
        .group("Navigation")
        .description("Swap window left");

    input::keybind(mod_key | Mod::SHIFT, Keysym::Right)
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(other) = focused.in_direction(Direction::Right).next()
            {
                focused.swap(&other);
            }
        })
        .group("Navigation")
        .description("Swap window right");
    input::keybind(mod_key | Mod::SHIFT, 'l')
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(other) = focused.in_direction(Direction::Right).next()
            {
                focused.swap(&other);
            }
        })
        .group("Navigation")
        .description("Swap window right");

    input::keybind(mod_key | Mod::SHIFT, Keysym::Up)
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(other) = focused.in_direction(Direction::Up).next()
            {
                focused.swap(&other);
            }
        })
        .group("Navigation")
        .description("Swap window up");
    input::keybind(mod_key | Mod::SHIFT, 'k')
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(other) = focused.in_direction(Direction::Up).next()
            {
                focused.swap(&other);
            }
        })
        .group("Navigation")
        .description("Swap window up");

    input::keybind(mod_key | Mod::SHIFT, Keysym::Down)
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(other) = focused.in_direction(Direction::Down).next()
            {
                focused.swap(&other);
            }
        })
        .group("Navigation")
        .description("Swap window down");
    input::keybind(mod_key | Mod::SHIFT, 'j')
        .on_press(move || {
            if let Some(focused) = get_focused()
                && let Some(other) = focused.in_direction(Direction::Down).next()
            {
                focused.swap(&other);
            }
        })
        .group("Navigation")
        .description("Swap window down");
}
