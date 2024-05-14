import { NotificationPopups } from "./notificationPopups.js";
import { Bar } from "./bar.js";

const scss = `${App.configDir}/style.scss`
const css = `${App.configDir}/style.css`

// make sure sassc is installed on your system
Utils.exec(`sass ${scss} ${css}`)

Utils.monitorFile(
    scss,
    function() {
        Utils.exec(`sass ${scss} ${css}`)
        App.resetCss()
        App.applyCss(css)
    },
)

App.config({
    style: css,
    windows: [
        Bar(),
        NotificationPopups(),
        // applauncher,
    ],
})

export { }
