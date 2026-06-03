export function generatePickerHTML(devices: any[]): string {
	const deviceButtons = devices
		.map((d) => {
			const name = d.testName || d.productName || "HID 设备";
			const vid = d.vendorId.toString(16).padStart(4, "0");
			const pid = d.productId.toString(16).padStart(4, "0");
			return `<button onclick="select('${d.deviceId}')">[${vid}:${pid}] ${name}</button>`;
		})
		.join("");

	return `
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        * { box-sizing: border-box; }
        html, body {
          margin: 0;
          padding: 0;
          height: 100%;
          background-color: #1e1e2e;
          color: #cdd6f4;
          font-family: sans-serif;
          overflow: hidden;
        }
        body {
          padding: 16px;
          display: flex;
          flex-direction: column;
        }
        h3 { margin: 0 0 12px 0; font-size: 16px; color: #89b4fa; font-weight: 600; }
        .list {
          display: flex;
          flex-direction: column;
          gap: 8px;
          flex-grow: 1;
          overflow-y: auto;
        }
        button {
          background-color: #313244;
          color: #cdd6f4;
          border: 1px solid #45475a;
          padding: 10px 12px;
          border-radius: 6px;
          cursor: pointer;
          text-align: left;
          font-size: 13px;
          width: 100%;
          transition: background 0.15s ease;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }
        button:hover { background-color: #45475a; border-color: #89b4fa; }
        .cancel {
          background-color: #f38ba8;
          color: #11111b;
          text-align: center;
          font-weight: bold;
          margin-top: 12px;
          border: none;
          flex-shrink: 0;
        }
        .cancel:hover { background-color: #f5e0dc; }
      </style>
    </head>
    <body>
      <h3>请选择要连接的键盘：</h3>
      <div class="list">
        ${deviceButtons}
      </div>
      <button class="cancel" onclick="select('')">取消连接</button>

      <script>
        const { ipcRenderer } = require('electron');
        function select(id) {
          ipcRenderer.send('hid-picker-respond', id);
        }
      </script>
    </body>
    </html>
  `;
}
