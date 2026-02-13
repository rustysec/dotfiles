use pinnacle_api::process::Command;

pub fn run() {
    #[rustfmt::skip]
    #[allow(clippy::type_complexity)]
    let items: Vec<(&str, Vec<(&str, &str)>)> = vec![
        // ("dms", vec!["run"], vec![("DMS_DISABLE_MATUGEN", "1")]),
        ("waybar -c ~/.config/waybar/config.pinnacle", vec![]),
        ("swaybg -m fill -i /usr/share/wallpapers/Next/contents/images_dark/5120x2880.png", vec![]),
        ("kanshi", vec![]),
        (r#"swayidle -w timeout 300 'pgrep || swaylock' timeout 600 'pinnacle-ctl output-off "*"' resume 'pinnacle-ctl output-on "*"' before-sleep 'pgrep || swaylock'"#, vec![]),
        ("~/dotfiles/tools/rog.sh", vec![]),
        ("~/dotfiles/tools/wob.sh", vec![]),
    ];

    for (app, env) in items {
        Command::with_shell(["bash", "-c"], app)
            .envs(env)
            .once()
            .spawn();
    }
}
