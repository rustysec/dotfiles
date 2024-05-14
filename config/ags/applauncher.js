import brightness from "./brightness.js";
const battery = await Service.import("battery")
const audio = await Service.import("audio")
const systemtray = await Service.import("systemtray")

const WINDOW_NAME = "applauncher"

const date = Variable("", {
    poll: [1000, 'date "+%H:%M:%S // %e %b %Y"'],
})

function Clock() {
    return Widget.Label({
        label: date.bind(),
    })
}

function BrightnessLabel() {
    const icon = brightness.bind("screen_value").as(p =>
        `display-brightness-symbolic`)


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
        class_name: "item-box",
        spacing: 10,
        children: [
            Widget.Icon({ icon }),
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

    const slider = Widget.Slider({
        hexpand: true,
        draw_value: false,
        on_change: ({ value }) => audio.speaker.volume = value,
        setup: self => self.hook(audio.speaker, () => {
            self.value = audio.speaker.volume || 0
        }),
    })

    return Widget.Box({
        class_name: "item-box",
        spacing: 10,
        children: [
            icon,
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

    const slider = Widget.Slider({
        hexpand: true,
        draw_value: false,
        on_change: ({ value }) => audio.microphone.volume = value,
        setup: self => self.hook(audio.microphone, () => {
            self.value = audio.microphone.volume || 0
        }),
    })

    return Widget.Box({
        class_name: "item-box--bottom",
        spacing: 10,
        children: [
            icon,
            slider,
        ],
    })
}

function BatteryLabel() {
    const value = battery.bind("percent").as(p => p > 0 ? p / 100 : 0);

    const icon = battery.bind("percent").as(p =>
        `battery-level-${Math.floor(p / 10) * 10}-symbolic`
    );

    return Widget.Box({
        class_name: Utils.merge([battery.bind("charging"), battery.bind("charged")], (charged, charging) => {
            return charged || charging ? "item-box--charging" : "item-box--discharging";
        }),
        visible: battery.bind("available"),
        spacing: 10,
        children: [
            Widget.Icon({ icon }),
            Widget.LevelBar({
                hexpand: true,
                vpack: "center",
                value,
            }),
        ],
    })
}

function SysTray() {
    const items = systemtray.bind("items")
        .as(items => items.map(item => Widget.Button({
            child: Widget.Icon({ icon: item.bind("icon") }),
            on_primary_click: (_, event) => item.activate(event),
            on_secondary_click: (_, event) => item.openMenu(event),
            tooltip_markup: item.bind("tooltip_markup"),
        })))

    const systray = Widget.Box({
        class_name: "systray",
        children: items,
        hpack: "end",
    })

    return Widget.Box({
        vertical: false,
        spacing: 8,
        homogeneous: false,
        class_name: "top-bar",
        children: [Clock(), systray],
        hpack: "center"
    })
}

const Applauncher = () => {
    const inner = Widget.Box({
        vertical: true,
        class_name: "inside",
        children: [
            SysTray(),
            BatteryLabel(),
            BrightnessLabel(),
            Volume(),
            MicVolume(),
        ],
    })

    return Widget.Box({
        class_name: "outside",
        children: [inner],
    })
}

// there needs to be only one instance
export const applauncher = Widget.Window({
    name: WINDOW_NAME,
    setup: self => self.keybind("Escape", () => {
        App.closeWindow(WINDOW_NAME)
    }),
    visible: false,
    keymode: "exclusive",
    child: Applauncher(),
})
