# Testing Documentation - Incoming Order Feature

This document details the tests and verification steps for the Native Incoming Order (Sticky Notification) feature implemented in the Rider App.

## Feature Overview
The goal is to simulate an incoming phone call style notification ("Sticky Notification") when an order is received, ensuring the device wakes up even if locked. This is achieved using the `flutter_callkit_incoming` package.

## 1. Environment & Build Setup

### Build Configuration Changes
To ensure compatibility and successful builds, the following changes were applied:
1.  **Kotlin Version Downgrade:**
    - Downgraded Kotlin from `2.1.0` to `1.9.24` in `android/settings.gradle` and `android/app/build.gradle`.
    - **Reason:** Many Flutter plugins (specifically `background_locator_2` and `flutter_background_service`) are not yet compatible with Kotlin 2.x.
2.  **Manifest Merge Conflict Resolution:**
    - Added `tools:replace="android:launchMode,android:theme"` to the `CallkitIncomingActivity` in `android/app/src/main/AndroidManifest.xml`.
    - **Reason:** To resolve conflicts between the app's manifest and the plugin's manifest regarding activity attributes.
3.  **ProGuard Rules:**
    - Added `-keep class com.hiennv.flutter_callkit_incoming.** { *; }` to `android/app/proguard-rules.pro`.
    - **Reason:** To prevent code obfuscation from breaking the feature in Release builds.

### Verification Command
Run the following to verify the build environment:
```bash
flutter clean
flutter pub get
flutter build apk --debug
```

## 2. Test Cases

### Test Case 1: Simulate Incoming Order (Foreground)
**Objective:** Verify the call screen appears when the app is open.
**Steps:**
1.  Launch the app.
2.  Tap the floating action button (FAB) labeled "Simulate Incoming Order" (Phone Icon) at the bottom right.
**Expected Result:**
- A native full-screen incoming call interface appears.
- Caller Name: "Burger King #402"
- Subtitle: "Delivery - 2.5km"
- Accept and Decline buttons are visible.

### Test Case 2: Accept Order
**Objective:** Verify navigation upon accepting the call.
**Steps:**
1.  Trigger the incoming call (Test Case 1).
2.  Tap the "Accept" button.
**Expected Result:**
- The call screen closes.
- The app navigates to the `OrderDetailsPage`.
- The `OrderDetailsPage` displays the Order ID (UUID generated during the test).
- **Log Verification:** Check logs for `DEBUG: Call Accepted`.

### Test Case 3: Decline Order
**Objective:** Verify logging/feedback upon declining the call.
**Steps:**
1.  Trigger the incoming call.
2.  Tap the "Decline" button.
**Expected Result:**
- The call screen closes.
- A SnackBar appears saying "Order Declined" (if app is in foreground).
- **Log Verification:** Check logs for `DEBUG: Call Declined`.

### Test Case 4: Background/Locked State (The "Sticky" Test)
**Objective:** Verify the "Wake Up" functionality.
**Steps:**
1.  Open the app.
2.  Lock the device screen.
3.  (Requires external trigger or delayed timer) *Since the FAB cannot be pressed while locked, real-world testing requires sending a Push Notification via OneSignal that triggers `showIncomingCall`.*
    - *Alternative for local testing:* Add a `Future.delayed` in `main.dart`'s `initState` to trigger the call after 10 seconds, then lock the phone immediately.
**Expected Result:**
- The device screen should turn on.
- The full-screen incoming call UI should be visible over the lock screen.

## 3. Troubleshooting & Logs

- **Build Failures:** If `compileKotlin` fails, ensure the Kotlin version is strictly `1.9.24`.
- **Manifest Errors:** If "Attribute application@label value=..." errors occur, ensure `tools:replace` is correctly set in the `<application>` tag (this was already present).
- **Runtime Permissions:** On Android 14+, ensure `FlutterCallkitIncoming.requestFullIntentPermission()` is called if the screen doesn't wake up.

## 4. Code Locations
- **Logic:** `lib/custom_code/actions/show_incoming_call.dart`
- **Wiring/Listeners:** `lib/main.dart` (inside `_MyAppState`)
- **Navigation:** `lib/flutter_flow/nav/nav.dart` (GlobalKey implementation)
- **Callback Fix:** `lib/custom_code/location_callback.dart` (Type signature fix)
