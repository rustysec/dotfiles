import { NotificationPopups } from "./notificationPopups.js";
import { applauncher } from "./applauncher.js";

App.config({
    style: "./style.css",
    windows: [
        applauncher,
        NotificationPopups(),
    ],
})

export { }
