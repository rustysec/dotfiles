use crate::binds::tags::{toggle_all_tags_everywhere, toggle_all_tags_on_focused};
use pinnacle_api::input::{self, Bind, GestureType, Mod, SwipeDirection};

pub fn binds(_mod_key: Mod) {
    input::gesturebind(Mod::empty(), GestureType::Swipe(SwipeDirection::Right), 3)
        .on_finish(|| {
            if let Some(output) = pinnacle_api::output::get_focused()
                && let Some(current) = output.active_tags().next()
                && let Some(pos) = output.tags().position(|tag| tag == current)
                && let Some(next) = output.tags().nth(pos + 1)
            {
                next.switch_to();
            }
        })
        .group("Gestures")
        .description("Next workspaces");

    input::gesturebind(Mod::empty(), GestureType::Swipe(SwipeDirection::Left), 3)
        .on_finish(|| {
            if let Some(output) = pinnacle_api::output::get_focused()
                && let Some(current) = output.active_tags().next()
                && let Some(pos) = output.tags().position(|tag| tag == current)
                && let Some(next) = output.tags().nth(pos.saturating_sub(1))
            {
                next.switch_to();
            }
        })
        .group("Gestures")
        .description("Previous workspaces");

    input::gesturebind(Mod::empty(), GestureType::Swipe(SwipeDirection::Up), 3)
        .on_finish(toggle_all_tags_on_focused)
        .group("Gestures")
        .description("Toggle all tags");

    input::gesturebind(Mod::empty(), GestureType::Swipe(SwipeDirection::Down), 3)
        .on_finish(toggle_all_tags_on_focused)
        .group("Gestures")
        .description("Toggle all tags");

    input::gesturebind(Mod::empty(), GestureType::Swipe(SwipeDirection::Up), 4)
        .on_finish(toggle_all_tags_everywhere)
        .group("Gestures")
        .description("Toggle all tags everywhere");

    input::gesturebind(Mod::empty(), GestureType::Swipe(SwipeDirection::Down), 4)
        .on_finish(toggle_all_tags_everywhere)
        .group("Gestures")
        .description("Toggle all tags everywhere");
}
