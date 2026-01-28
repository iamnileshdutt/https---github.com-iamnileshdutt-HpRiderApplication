# Incoming Order CallKit Implementation

This project now includes `flutter_callkit_incoming` to display a native incoming call screen when an order is received.

## 1. Usage

A new Custom Action `showIncomingCall` has been added. You can call this action from your FlutterFlow logic (e.g., inside a Push Notification handler or `main.dart`).

**Parameters:**
- `callerName` (String): The name to display (e.g., "New Order").
- `callerNumber` (String): The phone number or subtitle (e.g., Restaurant Name).
- `avatarUrl` (String): URL to an avatar image.
- `backgroundUrl` (String): URL or asset path for the background.

**Example Code:**
```dart
await showIncomingCall(
  'New Order',
  'Restaurant XYZ',
  'https://example.com/avatar.png',
  'assets/images/order_bg.png'
);
```

## 2. Android Customization (Background)

To customize the background of the incoming call screen on Android using a native drawable resource:

1.  **Prepare your image**: Create your background image (e.g., `incoming_bg.png`).
2.  **Place it in the drawable folder**:
    Copy your image file to:
    `android/app/src/main/res/drawable/incoming_bg.png`

    (If the `drawable` folder doesn't exist, create it inside `android/app/src/main/res/`)

3.  **Update the Action Code**:
    Open `lib/custom_code/actions/show_incoming_call.dart` and update the `backgroundUrl` in `AndroidParams`:

    ```dart
    android: AndroidParams(
      // ... other params
      backgroundUrl: 'incoming_bg', // Name of the drawable without extension
    ),
    ```

    *Note: If you pass `backgroundUrl` as a parameter to the action, ensure you pass the drawable name if you want to use the native resource.*

## 3. Permissions

The following permissions have been added to `android/app/src/main/AndroidManifest.xml`:
- `USE_FULL_SCREEN_INTENT`: To show the UI when the device is locked.
- `WAKE_LOCK`: To wake up the device.
- `VIBRATE`: For ringing vibration.
- `FOREGROUND_SERVICE`: To keep the call active.

**Android 14+ Note:**
On Android 14 (SDK 34) and above, you may need to request permission to use full-screen intents at runtime if your app is not the default calling app. You can add a check in your app initialization:

```dart
await FlutterCallkitIncoming.requestFullIntentPermission();
```

## 4. Integration with OneSignal

To trigger this screen when a OneSignal notification arrives, you typically need to listen for the notification in `main.dart` or your `initOneSignal` action.

Example logic to add inside your notification handler:

```dart
OneSignal.Notifications.addForegroundWillDisplayListener((event) {
  // Check if the notification data indicates an incoming order
  if (event.notification.additionalData?['type'] == 'order') {
     showIncomingCall(
       event.notification.title,
       event.notification.body,
       null,
       null
     );
  }
});
```

## 5. Proguard Rules (Release Build)

Proguard rules have been added to `android/app/proguard-rules.pro` to ensure the CallKit classes are not obfuscated in release builds:

```
-keep class com.hiennv.flutter_callkit_incoming.** { *; }
```
