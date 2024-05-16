const audio = await Service.import("audio")
import brightness from "./services/brightness.js";

function Brightness() {
    let icon = `display-brightness-symbolic`;

    const slider = Widget.Slider({
        hexpand: true,
        draw_value: false,
        value: brightness.bind("screen_value"),
        on_change: ({ value }) => brightness.screen_value = value,
        setup: self => self.hook(brightness, (self, screenValue) => {
            self.value = screenValue || 0
        }),
    })

    return Widget.Box({
        class_name: "volume",
        css: "min-width: 100px",
        children: [
            Widget.Button({ child: Widget.Icon({ icon }) }),
            slider,
        ],
    })
}

function MicVolume() {
    const icons = {
        101: "overamplified",
        67: "high",
        34: "medium",
        1: "low",
        0: "muted",
    }

    function getIcon() {
        const icon = audio.microphone.is_muted ? 0 : [101, 67, 34, 1, 0].find(
            threshold => threshold <= audio.microphone.volume * 100)

        return `audio-input-microphone-${icons[icon]}-symbolic`
    }

    const icon = Widget.Icon({
        icon: Utils.watch(getIcon(), audio.microphone, getIcon),
    })

    const button = Widget.Button({
        child: icon,
        on_primary_click: () => audio.microphone["is-muted"] = !audio.microphone.is_muted,
    })

    const slider = Widget.Slider({
        hexpand: true,
        draw_value: false,
        on_change: ({ value }) => audio.microphone.volume = value,
        setup: self => self.hook(audio.microphone, () => {
            self.value = audio.microphone.volume || 0
        }),
    })

    return Widget.Box({
        class_name: "volume",
        css: "min-width: 100px",
        children: [
            button,
            slider,
        ],
    })
}

function Volume() {
    const icons = {
        101: "overamplified",
        67: "high",
        34: "medium",
        1: "low",
        0: "muted",
    }

    function getIcon() {
        const icon = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
            threshold => threshold <= audio.speaker.volume * 100)

        return `audio-volume-${icons[icon]}-symbolic`
    }

    const icon = Widget.Icon({
        icon: Utils.watch(getIcon(), audio.speaker, getIcon),
    })

    const button = Widget.Button({
        child: icon,
        on_primary_click: () => audio.speaker["is-muted"] = !audio.speaker.is_muted,
    })

    const slider = Widget.Slider({
        hexpand: true,
        draw_value: false,
        on_change: ({ value }) => audio.speaker.volume = value,
        setup: self => self.hook(audio.speaker, () => {
            self.value = audio.speaker.volume || 0
        }),
    })

    return Widget.Box({
        class_name: "volume",
        css: "min-width: 100px",
        children: [button, slider],
    })
}


function rowBuilder(/** @type {array} */ opts, /** @type {string?} */ cmd = null) {
    let toMatch = Variable("")

    if (cmd) {
        // toMatch = Utils.exec(cmd)
        toMatch = Variable("", {
            poll: [1000, cmd],
        })
    }

    let children = opts.map(opt =>
        Widget.Button({
            class_name: toMatch && toMatch.bind().as(toMatch => toMatch == opt.toMatch ? "sys-menu-item--selected" : "sys-menu-item"),
            on_primary_click: () => Utils.exec(opt.action),
            child: Widget.Box({
                children: [
                    Widget.Icon(opt.icon),
                    Widget.Label({
                        label: opt.name,
                        hexpand: true,
                    })
                ]
            })
        }))


    return Widget.Box({
        vertical: false,
        hexpand: true,
        children: [Widget.Box({
            homogeneous: true,
            spacing: 10,
            children,
        })]
    })
}

function Separator() {
    return Widget.Box({
        css: "padding-top: 1em; padding-bottom: 1em;",
        spacing: 10,
        hexpand: true,
        vertical: false,
        homogeneous: true,
        children: [Widget.Separator({ vertical: false })]
    })
}

export function SystemMenu(monitor = 0) {
    let shutdownOptions = [
        { name: "Shutdown", icon: "system-shutdown-symbolic", action: "loginctl shutdown" },
        { name: "Reboot", icon: "system-reboot-symbolic", action: "loginctl reboot" },
        { name: "Logout", icon: "application-exit-symbolic", action: "loginctl logout" },
    ]

    let powerOptions = [
        { name: "Perf", icon: "power-profile-performance-symbolic", action: "powerprofilesctl set performance", toMatch: "performance" },
        { name: "Balanced", icon: "power-profile-balanced-symbolic", action: "powerprofilesctl set balanced", toMatch: "balanced" },
        { name: "Saver", icon: "power-profile-power-saver-symbolic", action: "powerprofilesctl set power-saver", toMatch: "power-saver" },
    ]

    const shutdown = rowBuilder(shutdownOptions)
    const power = rowBuilder(powerOptions, "powerprofilesctl get")


    const list = Widget.Box({
        vertical: true,
        hexpand: true,
        class_name: "system-menu",
        children: [
            Brightness(),
            Volume(),
            MicVolume(),
            Separator(),
            power,
            Separator(),
            shutdown,
        ]
    })

    return Widget.Window({
        name: `system-menu-${monitor}`,
        anchor: ["top", "right"],
        class_name: "notification-popups",
        monitor,
        exclusivity: "exclusive",
        child: Widget.Box({
            css: "min-width: 2px; min-height: 2px;",
            vertical: true,
            child: list,
        }),
    })
}
