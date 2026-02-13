use pinnacle_api::Keysym;
use pinnacle_api::input;
use pinnacle_api::input::Bind;
use pinnacle_api::input::Mod;
use pinnacle_api::output;
use pinnacle_api::output::OutputHandle;
use pinnacle_api::tag;
use pinnacle_api::tag::TagHandle;
use pinnacle_api::window::get_focused;
use std::collections::HashMap;
use std::sync::{LazyLock, Mutex};

static ACTIVE_TAG_CACHE: LazyLock<Mutex<HashMap<OutputHandle, Vec<TagHandle>>>> =
    LazyLock::new(|| Mutex::new(HashMap::new()));
static ACTIVE_OVERVIEW_STATUS: LazyLock<Mutex<HashMap<OutputHandle, Vec<TagHandle>>>> =
    LazyLock::new(|| Mutex::new(HashMap::new()));

pub fn binds(mod_key: Mod) {
    let tag_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];

    // Setup all monitors with tags "1" through "9"
    output::for_each_output(move |output| {
        let mut tags = tag::add(output, tag_names);
        tags.next().unwrap().set_active(true);
    });

    // `mod_key + o` toggles all windows on all tags on current monitor
    input::keybind(mod_key, Keysym::o)
        .on_press(toggle_all_tags_on_focused)
        .group("Tag")
        .description("Overview on current monitor");

    // `mod_key + Shift + o` toggles all tags on all monitor
    input::keybind(mod_key | Mod::SHIFT, Keysym::o)
        .on_press(toggle_all_tags_everywhere)
        .group("Tag")
        .description("Overview on all monitors");

    for tag_name in tag_names {
        // `mod_key + 1-9` switches to tag "1" to "9"
        input::keybind(mod_key, tag_name)
            .on_press(move || {
                if let Some(tag) = tag::get(tag_name) {
                    tag.switch_to();
                }
            })
            .group("Tag")
            .description(format!("Switch to tag {tag_name}"));

        // `mod_key + shift + 1-9` toggles window tag "1" to "9"
        input::keybind(mod_key | Mod::SHIFT, tag_name)
            .on_press(move || {
                if let Some(tag) = tag::get(tag_name)
                    && let Some(focused) = get_focused()
                {
                    focused.toggle_tag(&tag);
                }
            })
            .group("Tag")
            .description(format!("Toggle window tag {tag_name}"));

        // `mod_key + ctrl + 1-9` moves the focused window to tag "1" to "9"
        input::keybind(mod_key | Mod::CTRL, tag_name)
            .on_press(move || {
                if let Some(tag) = tag::get(tag_name)
                    && let Some(win) = get_focused()
                {
                    win.move_to_tag(&tag);
                }
            })
            .group("Tag")
            .description(format!("Move the focused window to tag {tag_name}"));

        // `mod_key + alt + 1-9` toggles tag "1" to "9"
        input::keybind(mod_key | Mod::ALT, tag_name)
            .on_press(move || {
                if let Some(tag) = tag::get(tag_name) {
                    tag.toggle_active();
                }
            })
            .group("Tag")
            .description(format!("Toggle tag {tag_name}"));
    }
}

pub fn toggle_all_tags_everywhere() {
    for output in output::get_all() {
        toggle_all_tags(output);
    }
}

pub fn toggle_all_tags_on_focused() {
    if let Some(output) = output::get_focused() {
        toggle_all_tags(output);
    }
}

fn toggle_all_tags(output: OutputHandle) {
    let mut remove_when_done = false;

    if let Some(active_tags) = ACTIVE_TAG_CACHE.lock().unwrap().get(&output) {
        remove_when_done = true;

        for tag in output.tags() {
            if !active_tags.contains(&tag) {
                tag.set_active(false);
            }
        }
    } else {
        let mut cached_tags = Vec::new();

        for tag in output.tags() {
            if tag.active() {
                cached_tags.push(tag.clone());
            } else {
                tag.set_active(true);
            }
        }

        ACTIVE_TAG_CACHE
            .lock()
            .unwrap()
            .insert(output.clone(), cached_tags);
    }

    if remove_when_done {
        ACTIVE_TAG_CACHE.lock().unwrap().remove(&output);
    }
}
