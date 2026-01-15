use pinnacle_api::input::{set_xcursor_size, set_xcursor_theme};

pub fn configure() {
    set_xcursor_size(24);
    set_xcursor_theme("breeze_cursors");

    unsafe {
        std::env::set_var("GTK_THEME", "Dracula");
        std::env::set_var("DMS_DISABLE_MATUGEN", "1");
    }
}
