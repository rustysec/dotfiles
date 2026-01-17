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

    // Between Monitors

    input::keybind(mod_key | Mod::SHIFT | Mod::CTRL, Keysym::Left)
        .on_press(move || {
            if let Some(other_output) = pinnacle_api::output::get_focused()
                .and_then(|output| output.in_direction(Direction::Left).next())
                && let Some(focused) = get_focused()
            {
                focused.move_to_output(&other_output);
            }
        })
        .group("Navigation")
        .description("Move window to monitor left");
    input::keybind(mod_key | Mod::SHIFT | Mod::CTRL, 'h')
        .on_press(move || {
            if let Some(output) = pinnacle_api::output::get_focused()
                && let Some(other_output) = output.in_direction(Direction::Left).next()
                && let Some(focused) = get_focused()
            {
                focused.move_to_output(&other_output);
            }
        })
        .group("Navigation")
        .description("Move window to monitor left");

    input::keybind(mod_key | Mod::SHIFT | Mod::CTRL, Keysym::Right)
        .on_press(move || {
            if let Some(output) = pinnacle_api::output::get_focused()
                && let Some(other_output) = output.in_direction(Direction::Right).next()
                && let Some(focused) = get_focused()
            {
                focused.move_to_output(&other_output);
            }
        })
        .group("Navigation")
        .description("Move window to monitor right");
    input::keybind(mod_key | Mod::SHIFT | Mod::CTRL, 'l')
        .on_press(move || {
            if let Some(output) = pinnacle_api::output::get_focused()
                && let Some(other_output) = output.in_direction(Direction::Right).next()
                && let Some(focused) = get_focused()
            {
                focused.move_to_output(&other_output);
            }
        })
        .group("Navigation")
        .description("Move window to monitor right");

    input::keybind(mod_key | Mod::SHIFT | Mod::CTRL, Keysym::Up)
        .on_press(move || {
            if let Some(output) = pinnacle_api::output::get_focused()
                && let Some(other_output) = output.in_direction(Direction::Up).next()
                && let Some(focused) = get_focused()
            {
                focused.move_to_output(&other_output);
            }
        })
        .group("Navigation")
        .description("Move window to monitor up");
    input::keybind(mod_key | Mod::SHIFT | Mod::CTRL, 'k')
        .on_press(move || {
            if let Some(output) = pinnacle_api::output::get_focused()
                && let Some(other_output) = output.in_direction(Direction::Up).next()
                && let Some(focused) = get_focused()
            {
                focused.move_to_output(&other_output);
            }
        })
        .group("Navigation")
        .description("Move window to monitor up");

    input::keybind(mod_key | Mod::SHIFT | Mod::CTRL, Keysym::Down)
        .on_press(move || {
            if let Some(output) = pinnacle_api::output::get_focused()
                && let Some(other_output) = output.in_direction(Direction::Down).next()
                && let Some(focused) = get_focused()
            {
                focused.move_to_output(&other_output);
            }
        })
        .group("Navigation")
        .description("Move window to monitor down");
    input::keybind(mod_key | Mod::SHIFT | Mod::CTRL, 'j')
        .on_press(move || {
            if let Some(output) = pinnacle_api::output::get_focused()
                && let Some(other_output) = output.in_direction(Direction::Down).next()
                && let Some(focused) = get_focused()
            {
                focused.move_to_output(&other_output);
            }
        })
        .group("Navigation")
        .description("Move window to monitor down");
}
