use pinnacle_api::process::Command;

pub fn run() {
    let items = vec![
        ("dms", vec!["run"], vec![("DMS_DISABLE_MATUGEN", "1")]),
        ("kanshi", vec![], vec![]),
    ];

    for (app, args, env) in items {
        Command::new(app).args(args).envs(env).spawn();
    }
}
