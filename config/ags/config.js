import { NotificationPopups } from "./notificationPopups.js";
import { Bar } from "./bar.js";
import Gdk from "gi://Gdk"

const scss = `${App.configDir}/style.scss`
const css = `${App.configDir}/style.css`

Utils.exec(`sass ${scss} ${css}`)

Utils.monitorFile(
    scss,
    function() {
        Utils.exec(`sass ${scss} ${css}`)
        App.resetCss()
        App.applyCss(css)
    },
)


function range(length = 1, start = 1) {
    return Array.from({ length }, (_, i) => i + start)
}

function allMonitors(/** @type {any} */ widget) {
    const n = Gdk.Display.get_default()?.get_n_monitors() || 1
    return range(n, 0).map(widget).flat(1)
}

App.config({
    style: css,
    windows: [
        ...allMonitors(Bar),
        ...allMonitors(NotificationPopups),
    ],
})

export { }
