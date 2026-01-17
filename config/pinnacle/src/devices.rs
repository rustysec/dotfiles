use pinnacle_api::input::{self, XkbConfig};

pub fn configure() {
    input::set_xkb_config(
        XkbConfig::new()
            .with_layout("us(colemak),us")
            .with_options("caps:escape_shifted_capslock,lv3:menu_switch,lv3:ralt_alt"),
    );

    input::libinput::for_each_device(|device| {
        if device.device_type().is_touchpad() {
            device.set_natural_scroll(true);
            device.set_click_method(input::libinput::ClickMethod::Clickfinger);
        }
    });
}
