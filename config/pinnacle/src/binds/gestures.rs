use pinnacle_api::{
    input::{self, GestureDirection, GestureType, Mod},
    process::Command,
};

pub fn binds(_mod_key: Mod) {
    input::gesturebind(Mod::empty(), GestureDirection::Up, 3, GestureType::Swipe).on_finish(|| {
        Command::with_shell(["bash", "-c"], "fuzzel 2>/dev/null || pkill -9 fuzzel").spawn();
    });

    input::gesturebind(Mod::empty(), GestureDirection::Down, 3, GestureType::Swipe).on_finish(
        || {
            Command::with_shell(["bash", "-c"], "pkill -9 fuzzel").spawn();
        },
    );

    input::gesturebind(Mod::empty(), GestureDirection::Left, 3, GestureType::Swipe).on_finish(
        || {
            if let Some(output) = pinnacle_api::output::get_focused()
                && let Some(current) = output.active_tags().next()
                && let Some(pos) = output.tags().position(|tag| tag == current)
                && let Some(next) = output.tags().nth(pos + 1)
            {
                next.switch_to();
            }
        },
    );

    input::gesturebind(Mod::empty(), GestureDirection::Right, 3, GestureType::Swipe).on_finish(
        || {
            if let Some(output) = pinnacle_api::output::get_focused()
                && let Some(current) = output.active_tags().next()
                && let Some(pos) = output.tags().position(|tag| tag == current)
                && let Some(next) = output.tags().nth(pos.saturating_sub(1))
            {
                next.switch_to();
            }
        },
    );

    input::gesturebind(Mod::empty(), GestureDirection::Up, 2, GestureType::Pinch).on_finish(|| {
        Command::with_shell(["bash", "-c"], "fuzzel >/dev/null 2>&1 || pkill -9 fuzzel").spawn();
    });
}
