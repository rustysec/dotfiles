const notifications = await Service.import("notifications")
const mpris = await Service.import("mpris")
const audio = await Service.import("audio")
const battery = await Service.import("battery")
const systemtray = await Service.import("systemtray")
import brightness from "./services/brightness.js";
import { NotificationPopups } from "./notificationPopups.js";

const date = Variable("", {
    poll: [1000, 'date "+%H:%M | %e %b %Y"'],
})

function Clock() {
    return Widget.Label({
        class_name: "clock",
        label: date.bind(),
    })
}

function Notification(monitor = 0) {
    const notes = notifications.bind("notifications")

    return Widget.Button({
        class_name: notes.as(p => p.length > 0 ? "bar-notes" : "bar-notes--empty"),
        onPrimaryClick: () => {
            if (notifications.notifications.length > 0) {
                NotificationPopups(monitor, true)
            }
        },
        child: Widget.Box({
            spacing: 10,
            children: [
                Widget.Icon({
                    icon: "preferences-system-notifications-symbolic",
                }),
                Widget.Label({
                    label: notes.as(p => `${p.length || 0}`),
                }),
            ],
        })
    })
}

function Media() {
    /** @param {import('types/service/mpris').MprisPlayer} player */
    const Player = player => Widget.Button({
        onClicked: () => player.playPause(),
        child: Widget.Label().hook(player, label => {
            const { track_artists, track_title } = player;
            let title = `${track_artists.join(', ')} - ${track_title}`

            if (title.length > 40) {
                title = `${title.substring(0, 40)}...`;
            }

            label.label = title;
        }),
    })

    return Widget.Box({
        class_name: "media",
        children: mpris.bind('players').as(p => p.map(Player)),
    })
}

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
        css: "min-width: 100px",
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
        css: "min-width: 100px",
        children: [icon, slider],
    })
}

function Battery() {
    const icon = battery.bind("percent").as(p =>
        `battery-level-${Math.floor(p / 10) * 10}-symbolic`)

    return Widget.Box({
        class_name: "battery",
        spacing: 10,
        visible: battery.bind("available"),
        tooltip_text: battery.bind("percent").as(p => `${p}%`),
        children: [
            Widget.Icon({ icon }),
            Widget.Label({ label: battery.bind("percent").as(p => `${p}%`) }),
        ],
    })
}

function SysTray() {
    const items = systemtray.bind("items")
        .as(items => items.map(item => Widget.Button({
            child: Widget.Icon({ icon: item.bind("icon") }),
            on_secondary_click: (_, event) => item.activate(event),
            // on_primary_click: (_, event) => item.openMenu(event),
            tooltip_markup: item.bind("tooltip_markup"),
        })))

    return Widget.Box({
        children: items,
    })
}

function Left(monitor = 0) {
    return Widget.Box({
        hpack: "start",
        class_name: "bar-left",
        spacing: 10,
        children: [
            Notification(monitor),
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
            start_widget: Left(monitor),
            center_widget: Center(),
            end_widget: Right(),
        }),
    })
}

