# Screenshot Builder

Screenshot Builder is a small macOS app (Swift/Cocoa) for composing and exporting device screenshots using included device frames and a simple drag-and-drop UI.

**Features**
- **Drag & Drop:** Add screenshots into the app window for composition.
- **Device Frames:** Uses device frame assets in `Assets.xcassets` (iPhone 8 Plus, iPhone X, etc.).
- **Screenshot Helper:** Includes a helper module to capture or assist with screenshots.

**Key Files**
- `AppDelegate.swift` — App lifecycle and startup.
- `ViewController.swift` — Main UI logic and composing/exporting screenshots.
- `DragView.swift` — Drag-and-drop handling and preview area.
- `ScreenshotHelper.swift` — Utilities for capturing/managing screenshots.
- `Assets.xcassets/` — Device frames and example images used by the app.

**Build & Run**
- Open the Xcode project: `Screenshot Builder.xcodeproj` (or the workspace if you use one).
- Select the `Screenshot Builder` macOS target and run in Xcode (macOS 10.14+ recommended).
- If prompted about code signing or entitlements, set your Team or adjust signing in the project settings.

**Usage (quick)**
1. Run the app from Xcode or the built app bundle.
2. Drag an image/screenshot into the main app window (or import via the UI).
3. Choose a device frame from available assets and position/scale as needed.
4. Export or save the composed image using the app's export controls.

**Notes & Tips**
- Add more device frames to `Assets.xcassets` to support additional devices.
- Review `ScreenshotHelper.swift` and the entitlements files if the app needs automated capture or elevated permissions.

**Contributing**
- Open issues or pull requests; keep changes focused and well-documented.

**License**
- No license file is included. Add one if you want to make this project open-source.
# Screenshot Builder

Screenshot Builder is a small macOS app (Swift/Cocoa) for composing and exporting device screenshots using included device frames and a simple drag-and-drop UI.

**Features**
- **Drag & Drop:** Add screenshots into the app window for composition.
- **Device Frames:** Uses device frame assets in `Assets.xcassets` (iPhone 8 Plus, iPhone X, etc.).
- **Screenshot Helper:** Includes a helper module to capture or assist with screenshots.

**Key Files**
- `AppDelegate.swift` — App lifecycle and startup.
- `ViewController.swift` — Main UI logic and composing/exporting screenshots.
- `DragView.swift` — Drag-and-drop handling and preview area.
- `ScreenshotHelper.swift` — Utilities for capturing/managing screenshots.
- `Assets.xcassets/` — Device frames and example images used by the app.

**Build & Run**
- Open the Xcode project: `Screenshot Builder.xcodeproj` (or the workspace if you use one).
- Select the `Screenshot Builder` macOS target and run in Xcode (macOS 10.14+ recommended).
- If prompted about code signing or entitlements, set your Team or adjust signing in the project settings.

**Usage (quick)**
1. Run the app from Xcode or the built app bundle.
2. Drag an image/screenshot into the main app window (or import via the UI).
3. Choose a device frame from available assets and position/scale as needed.
4. Export or save the composed image using the app's export controls.

**Notes & Tips**
- Add more device frames to `Assets.xcassets` to support additional devices.
- Review `ScreenshotHelper.swift` and the entitlements files if the app needs automated capture or elevated permissions.

**Contributing**
- Open issues or pull requests; keep changes focused and well-documented.

**License**
- No license file is included. Add one if you want to make this project open-source.
