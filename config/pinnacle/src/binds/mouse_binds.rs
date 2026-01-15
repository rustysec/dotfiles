use pinnacle_api::input;
use pinnacle_api::input::Bind;
use pinnacle_api::input::Mod;
use pinnacle_api::input::MouseButton;
use pinnacle_api::window;

pub fn binds(mod_key: Mod) {
    // `mod_key + left click` starts moving a window
    input::mousebind(mod_key, MouseButton::Left)
        .on_press(|| {
            window::begin_move(MouseButton::Left);
        })
        .group("Mouse")
        .description("Start an interactive window move");

    // `mod_key + right click` starts resizing a window
    input::mousebind(mod_key, MouseButton::Right)
        .on_press(|| {
            window::begin_resize(MouseButton::Right);
        })
        .group("Mouse")
        .description("Start an interactive window resize");
}
