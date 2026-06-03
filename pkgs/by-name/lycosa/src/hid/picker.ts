import { BrowserWindow, ipcMain, session } from "electron";
import { generatePickerHTML } from "./template";

function showCustomHIDPicker(
	parentWindow: BrowserWindow,
	devices: any[],
): Promise<string> {
	return new Promise((resolve) => {
		const picker = new BrowserWindow({
			width: 380,
			height: 280,
			parent: parentWindow,
			modal: true,
			resizable: false,
			minimizable: false,
			maximizable: false,
			autoHideMenuBar: true,
			title: "HID 设备选择",
			webPreferences: {
				nodeIntegration: true,
				contextIsolation: false,
			},
		});

		picker.webContents.on("dom-ready", () => {
			picker.webContents.setZoomFactor(0.65);
		});

		const htmlContent = generatePickerHTML(devices);

		picker.loadURL(
			`data:text/html;charset=utf-8,${encodeURIComponent(htmlContent)}`,
		);

		ipcMain.once("hid-picker-respond", (event, id) => {
			if (!picker.isDestroyed()) picker.close();
			resolve(id);
		});

		picker.on("closed", () => {
			resolve("");
		});
	});
}

export function setupHID(mainWindow: BrowserWindow) {
	const ses = session.defaultSession;
	ses.setPermissionCheckHandler(() => true);

	ses.on("select-hid-device", async (event, details, callback) => {
		event.preventDefault();

		const devices = details.deviceList;

		const selectedDeviceId = await showCustomHIDPicker(mainWindow, devices);
		callback(selectedDeviceId);
	});
}
