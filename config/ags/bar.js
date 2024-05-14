const notifications = await Service.import("notifications")
const mpris = await Service.import("mpris")
const audio = await Service.import("audio")
const battery = await Service.import("battery")
const systemtray = await Service.import("systemtray")
import brightness from "./brightness.js";

notifications.clear();

const date = Variable("", {
    poll: [1000, 'date "+%H:%M:%S | %e %b %Y"'],
})

function Clock() {
    return Widget.Label({
        class_name: "clock",
        label: date.bind(),
    })
}

// we don't need dunst or any other notification daemon
// because the Notifications module is a notification daemon itself
function Notification() {
    const notes = notifications.bind("notifications")

    return Widget.Box({
        visible: notes.as(p => p.length > 0),
        spacing: 10,
        class_name: "bar-notes",
        children: [
            Widget.Icon({
                icon: "preferences-system-notifications-symbolic",
            }),
            Widget.Label({
                label: notes.as(p => `${p.length || 0}`),
                class_name: "bar-notes",
            }),
        ],
    })
}

function Media() {
    const label = Utils.watch("", mpris, "player-changed", () => {
        if (mpris.players[0] && mpris.players[0].track_title) {
            const { track_artists, track_title } = mpris.players[0]
            return `${track_artists.join(", ")} - ${track_title}`.substring(0, 20)
        } else {
            return ""
        }
    })

    return Widget.Box({
        class_name: "media",
        visible: !!mpris.players[0] && !!label,
        children: [Widget.Label({ label })],
    })
}

function Brightness() {
    /*
    const icon = brightness.bind("screen_value").as(p =>
        `display-brightness-symbolic`)
    */

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
        css: "min-width: 140px",
        children: [
            Widget.Icon({ icon }),
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
        class_name: "volume",
        css: "min-width: 140px",
        spacing: 10,
        children: [
            icon,
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
        class_name: "volume",
        css: "min-width: 140px",
        children: [icon, slider],
    })
}

function Battery() {
    const value = battery.bind("percent").as(p => p > 0 ? p / 100 : 0)
    const icon = battery.bind("percent").as(p =>
        `battery-level-${Math.floor(p / 10) * 10}-symbolic`)

    return Widget.Box({
        class_name: "battery",
        css: "min-width: 140px",
        spacing: 10,
        visible: battery.bind("available"),
        tooltip_text: battery.bind("percent").as(p => `${p}%`),
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

    return Widget.Box({
        children: items,
    })
}

function Left() {
    return Widget.Box({
        hpack: "start",
        class_name: "bar-left",
        spacing: 10,
        children: [
            Notification(),
            Media(),
        ],
    })
}

function Center() {
    return Widget.Box({
        hpack: "center",
        spacing: 10,
        children: [
            Clock(),
        ],
    })
}

function Right() {
    return Widget.Box({
        hpack: "end",
        class_name: "bar-right",
        spacing: 10,
        children: [
            Brightness(),
            MicVolume(),
            Volume(),
            Battery(),
            SysTray(),
        ],
    })
}

export function Bar(monitor = 0) {
    return Widget.Window({
        name: `bar-${monitor}`, // name has to be unique
        class_name: "bar",
        monitor,
        anchor: ["top", "left", "right"],
        exclusivity: "exclusive",
        child: Widget.CenterBox({
            start_widget: Left(),
            center_widget: Center(),
            end_widget: Right(),
        }),
    })
}

