use pinnacle_api::window;

pub fn configure() {
    window::add_window_rule(|window| {
        if window.app_id() == "org.gnome.Nautilus" {
            window.set_floating(false);
            window.set_maximized(false);
            window.set_fullscreen(false);
        }
    });
}
