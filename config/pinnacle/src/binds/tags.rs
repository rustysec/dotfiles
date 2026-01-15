use pinnacle_api::input;
use pinnacle_api::input::Bind;
use pinnacle_api::input::Mod;
use pinnacle_api::output;
use pinnacle_api::tag;
use pinnacle_api::window::get_focused;

pub fn binds(mod_key: Mod) {
    let tag_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];

    // Setup all monitors with tags "1" through "9"
    output::for_each_output(move |output| {
        let mut tags = tag::add(output, tag_names);
        tags.next().unwrap().set_active(true);
    });

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

        // `mod_key + shift + 1-9` moves the focused window to tag "1" to "9"
        input::keybind(mod_key | Mod::CTRL | Mod::SHIFT, tag_name)
            .on_press(move || {
                if let Some(tag) = tag::get(tag_name)
                    && let Some(win) = get_focused()
                {
                    win.move_to_tag(&tag);
                }
            })
            .group("Tag")
            .description(format!("Move the focused window to tag {tag_name}"));
    }
}
