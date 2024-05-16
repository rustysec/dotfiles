const notifications = await Service.import("notifications")

/** @param {import('resource:///com/github/Aylur/ags/service/notifications.js').Notification} n */
function NotificationIcon({ app_entry, app_icon, image }) {
    if (image) {
        return Widget.Box({
            css: `background-image: url("${image}");`
                + "background-size: contain;"
                + "background-repeat: no-repeat;"
                + "background-position: center;",
        })
    }

    let icon = "dialog-information-symbolic"
    if (Utils.lookUpIcon(app_icon))
        icon = app_icon

    if (app_entry && Utils.lookUpIcon(app_entry))
        icon = app_entry

    return Widget.Box({
        child: Widget.Icon(icon),
    })
}

/** @param {import('resource:///com/github/Aylur/ags/service/notifications.js').Notification} n */
export function Notification(n) {

    const icon = Widget.Box({
        vpack: "start",
        class_name: "icon",
        child: NotificationIcon(n),
    })

    const title = Widget.Label({
        class_name: "title",
        xalign: 0,
        justification: "left",
        hexpand: true,
        max_width_chars: 24,
        truncate: "end",
        wrap: true,
        label: n.summary,
        use_markup: true,
    })

    const body = Widget.Label({
        class_name: "body",
        hexpand: true,
        use_markup: true,
        xalign: 0,
        justification: "left",
        label: n.body,
        wrap: true,
    })

    var actions = Widget.Box({
        class_name: "actions",
        children: n.actions.map(({ id, label }) => Widget.Button({
            class_name: "action-button",
            on_clicked: () => {
                n.invoke(id)
                n.dismiss()
            },
            hexpand: true,
            child: Widget.Label(label),
        }))
    })

    return Widget.EventBox(
        {
            attribute: { id: n.id },
            on_primary_click: () => {
                n.dismiss()
                n.close()
            },
        },
        Widget.Box(
            {
                class_name: `notification ${n.urgency}`,
                vertical: true,
            },
            Widget.Box([
                icon,
                Widget.Box(
                    { vertical: true },
                    title,
                    body,
                ),
            ]),
            actions,
        ),
    )
}

export function NotificationPopups(monitor = 0, onDemand = false) {
    const list = Widget.Box({
        vertical: true,
        children: onDemand ? notifications.notifications.map(Notification) : notifications.popups.map(Notification),
    })

    function onNotified(/** @type {any} */ _, /** @type {number} */ id) {
        const n = notifications.getNotification(id)
        if (n)
            list.children = [Notification(n), ...list.children]
    }

    function onDismissed(/** @type {any} */ _, /** @type {number} */ id) {
        let item = list.children.find(n => n.attribute.id === id);
        if (item?.destroy) {
            item?.destroy()
        }
    }

    list.hook(notifications, onDismissed, "dismissed")

    if (!onDemand) {
        list.hook(notifications, onNotified, "notified")
    }

    return Widget.Window({
        name: onDemand ? `od-notes` : `notifications`,
        class_name: "notification-popups",
        anchor: onDemand ? ["top", "left"] : ["top"],
        margins: [16, 16],
        monitor,
        child: Widget.Box({
            css: "min-width: 2px; min-height: 2px;",
            class_name: "notifications",
            vertical: true,
            child: list,
        }),
    })
}
