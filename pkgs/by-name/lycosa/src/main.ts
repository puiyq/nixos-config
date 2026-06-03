import { app, BrowserWindow } from "electron";
import { setupHID } from "./hid/picker";

function createWindow() {
	const win = new BrowserWindow({
		width: 1200,
		height: 800,
		autoHideMenuBar: true,
	});

	win.loadURL("https://hero.aulastar.com/keyboard");

	win.webContents.on("dom-ready", () => {
		win.webContents.setZoomFactor(0.65);
	});

	win.webContents.setVisualZoomLevelLimits(1, 1);

	setupHID(win);
}

app.commandLine.appendSwitch("force-device-scale-factor", "1");

app.whenReady().then(() => {
	createWindow();
});

app.on("window-all-closed", () => {
	if (process.platform !== "darwin") app.quit();
});
