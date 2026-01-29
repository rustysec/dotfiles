mod binds;
mod devices;
mod rules;
mod selector;
mod startup;
mod theme;

use std::sync::Arc;
use std::sync::Mutex;

use pinnacle_api::input;
use pinnacle_api::input::Bind;
use pinnacle_api::input::Keysym;
use pinnacle_api::input::Mod;
use pinnacle_api::layout;
use pinnacle_api::layout::LayoutGenerator;
use pinnacle_api::layout::LayoutNode;
use pinnacle_api::layout::LayoutResponse;
use pinnacle_api::layout::generators::Dwindle;
use pinnacle_api::layout::generators::Fair;
use pinnacle_api::layout::generators::MasterSide;
use pinnacle_api::layout::generators::MasterStack;
use pinnacle_api::layout::generators::Spiral;
use pinnacle_api::output;
use pinnacle_api::pinnacle;
use pinnacle_api::pinnacle::Backend;
use pinnacle_api::signal::OutputSignal;
use pinnacle_api::signal::WindowSignal;
use pinnacle_api::util::Axis;
use pinnacle_api::util::Batch;
use pinnacle_api::window::connect_signal;

use crate::selector::Selector;

async fn config() {
    // Change the mod key to `Alt` when running as a nested window.
    let mod_key = match pinnacle::backend() {
        Backend::Tty => Mod::SUPER,
        Backend::Window => Mod::ALT,
    };

    devices::configure();
    theme::configure();
    rules::configure();

    //------------------------
    // Keybinds              |
    //------------------------
    binds::apps::binds(mod_key);
    binds::display::binds(mod_key);
    binds::gestures::binds(mod_key);
    binds::media::binds(mod_key);
    binds::mouse_binds::binds(mod_key);
    binds::moves::binds(mod_key);
    binds::navigation::binds(mod_key);
    binds::snowcap::binds(mod_key);
    binds::tags::binds(mod_key);
    binds::window::binds(mod_key);

    // `mod_key + alt + space` cycles the keyboard layout
    input::keybind(mod_key | Mod::ALT, Keysym::space).on_press(|| {
        input::cycle_xkb_layout_forward();
    });

    // `mod_key + ctrl + r` reloads the config
    input::keybind(mod_key | Mod::CTRL, 'r')
        .set_as_reload_config()
        .group("Compositor")
        .description("Reload the config");

    //------------------------
    // Layouts               |
    //------------------------

    // Pinnacle supports a tree-based layout system built on layout nodes.
    //
    // To determine the tree used to layout windows, Pinnacle requests your config for a tree data structure
    // with nodes containing gaps, directions, etc. There are a few provided utilities for creating
    // a layout, known as layout generators.
    //
    // ### Layout generators ###
    // A layout generator is a table that holds some state as well as
    // the `layout` function, which takes in a window count and computes
    // a tree of layout nodes that determines how windows are laid out.
    //
    // There are currently six built-in layout generators, one of which delegates to other
    // generators as shown below.

    fn into_box<'a, T: LayoutGenerator + Send + 'a>(
        generator: T,
    ) -> Box<dyn LayoutGenerator + Send + 'a> {
        Box::new(generator) as _
    }

    // Create a cycling layout generator that can cycle between layouts on different tags.
    let selector = Arc::new(Mutex::new(Selector::new([
        into_box(MasterStack {
            master_side: MasterSide::Left,
            ..Default::default()
        }),
        into_box(MasterStack {
            master_side: MasterSide::Right,
            ..Default::default()
        }),
        into_box(MasterStack {
            master_side: MasterSide::Top,
            ..Default::default()
        }),
        into_box(MasterStack {
            master_side: MasterSide::Bottom,
            ..Default::default()
        }),
        into_box(Dwindle::default()),
        into_box(Spiral::default()),
        into_box(Fair::default()),
        into_box(Fair {
            axis: Axis::Horizontal,
            ..Default::default()
        }),
    ])));

    // Use the cycling layout generator to manage layout requests.
    // This returns a layout requester that allows you to request layouts manually.
    let layout_requester = layout::manage({
        let cycler = selector.clone();
        move |args| {
            let Some(tag) = args.tags.first() else {
                return LayoutResponse {
                    root_node: LayoutNode::new(),
                    tree_id: 0,
                };
            };

            let mut cycler = cycler.lock().unwrap();
            cycler.set_current_tag(tag.clone());

            let root_node = cycler.layout(args.window_count);
            let tree_id = cycler.current_tree_id();
            LayoutResponse { root_node, tree_id }
        }
    });

    // `mod_key + shift + space` cycles to the next layout
    input::keybind(mod_key | Mod::SHIFT, Keysym::space)
        .on_press({
            let selector = selector.clone();
            let requester = layout_requester.clone();
            move || {
                let Some(focused_op) = output::get_focused() else {
                    return;
                };
                let Some(first_active_tag) = focused_op
                    .tags()
                    .batch_find(|tag| Box::pin(tag.active_async()), |active| *active)
                else {
                    return;
                };

                selector
                    .lock()
                    .unwrap()
                    .cycle_layout_forward(&first_active_tag);
                requester.request_layout_on_output(&focused_op);
            }
        })
        .group("Layout")
        .description("Cycle the layout forward");

    // ---- Run the `pinnacle-ctl` listener ----
    {
        let ipc_server = pinnacle_ctl::ipc::server::IpcServer::default().with_layout_selector({
            let selector = selector.clone();
            let requester = layout_requester.clone();
            move |idx: usize| {
                let Some(focused_op) = output::get_focused() else {
                    return;
                };
                let Some(first_active_tag) = focused_op
                    .tags()
                    .batch_find(|tag| Box::pin(tag.active_async()), |active| *active)
                else {
                    return;
                };

                selector.lock().unwrap().set_layout(&first_active_tag, idx);

                requester.request_layout_on_output(&focused_op);
            }
        });

        ipc_server.run().await;
    }

    // Enable focus borders with titlebars
    #[cfg(feature = "snowcap")]
    {
        use pinnacle_api::experimental::snowcap_api::widget::Color;
        use pinnacle_api::{snowcap::FocusBorder, window::add_window_rule};

        // Dracula colors
        let focused = Color::rgb(0.74, 0.58, 0.98);
        let unfocused = Color::rgb(0.38, 0.45, 0.64);

        // Add borders to already existing windows.
        for window in pinnacle_api::window::get_all() {
            let mut border = FocusBorder::new(&window);
            border.focused_color = focused;
            border.unfocused_color = unfocused;

            let _ = border.decorate();
        }

        // Add borders to new windows.
        add_window_rule(move |window| {
            use pinnacle_api::window::DecorationMode;

            window.set_decoration_mode(DecorationMode::ServerSide);
            let mut border = FocusBorder::new(&window);
            border.focused_color = focused;
            border.unfocused_color = unfocused;
            let _ = border.decorate();
        });
    }

    // Enable sloppy focus
    connect_signal(WindowSignal::PointerEnter(Box::new(|win| {
        win.set_focused(true);
    })));

    // Focus outputs when the pointer enters them
    output::connect_signal(OutputSignal::PointerEnter(Box::new(|output| {
        output.focus();
    })));

    #[cfg(feature = "snowcap")]
    if let Some(error) = pinnacle_api::pinnacle::take_last_error() {
        // Show previous crash messages
        pinnacle_api::snowcap::ConfigCrashedMessage::new(error).show();
    } else {
        // Or show the bind overlay on startup
        // pinnacle_api::snowcap::BindOverlay::new().show();
    }

    startup::run();
}

pinnacle_api::main!(config);

pub fn expand<S: AsRef<str>>(input: S) -> String {
    match std::env::var("HOME") {
        Ok(home) => input.as_ref().replace("~", &home),
        Err(_) => input.as_ref().to_string(),
    }
}
