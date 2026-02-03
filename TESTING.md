# Testing Guide for Incoming Order & Background Service

This document outlines the procedures to test the new Incoming Order feature (Full Screen Intent) and the updated Background Location Service.

## 1. Incoming Order (Full Screen Intent)

### Goal
Verify that an incoming order triggers a native-style call screen that wakes the device and appears over the lock screen.

### Prerequisites
*   Android Device (Physical device recommended for accurate lock screen testing).
*   iOS Device (Physical device required for CallKit/VoIP).
*   App installed in **Release** or **Profile** mode (Debug mode may behave differently with background execution).

### Test Case A: App in Foreground (Simulation)
1.  Open the App.
2.  Tap the **Floating Action Button (Phone Icon)** in the bottom right corner.
3.  **Expected Result:**
    *   The "Incoming Call" screen appears immediately.
    *   You can "Accept" or "Decline".
    *   Tapping "Accept" navigates to the **Order Details Page**.
    *   Tapping "Decline" dismisses the screen and shows a "Order Declined" snackbar.

### Test Case B: App in Background / Device Locked (Android)
1.  **Crucial for Android 14+:** Ensure the app has "Full Screen Intent" permission enabled. On first launch, the app should prompt/request this, or you can check in *Settings > Apps > Rider App > Special App Access > Full screen alerts*.
2.  Lock the device screen.
3.  Send a push notification (via OneSignal dashboard or API) with the following data:
    *   **Title:** "New Order"
    *   **Body:** "Pizza Hut - 2 items"
    *   **Additional Data (JSON):**
        ```json
        {
          "type": "order",
          "uuid": "unique_uuid_123",
          "caller_name": "Pizza Hut",
          "phone_number": "Address or Subtitle"
        }
        ```
4.  **Expected Result:**
    *   The device screen turns on.
    *   The native incoming call UI appears *over* the lock screen (bypassing the keyguard).
    *   The phone rings/vibrates.

### Test Case C: App in Background / Device Locked (iOS)
1.  Lock the device screen.
2.  Send a VoIP push notification (this requires specific server-side setup with APNs).
3.  **Expected Result:**
    *   The native iOS CallKit screen appears.
    *   "Slide to Answer" works.
    *   Unlocking the phone opens the app to the Order Details Page.

---

## 2. Background Location Service

### Goal
Verify that the app tracks the rider's location in the background and updates Firestore, even when the app is minimized.

### Test Case A: Service Start & Notification
1.  Launch the App.
2.  **Expected Result:**
    *   A persistent notification appears in the status bar: **"Location Service: Tracking location in background..."**.
    *   This confirms the `flutter_background_service` has started automatically.

### Test Case B: Firestore Update
1.  Open your Firebase Console > Firestore Database.
2.  Navigate to the `location` collection.
3.  Look for a document with the ID:
    *   **If logged in:** The Rider's ID (e.g., `123`).
    *   **If not logged in/default:** `unknown_rider`.
4.  **Expected Result:**
    *   The `lat`, `long`, and `timestamp` fields in this document should update approximately every **15 seconds**.
    *   Move the device (or simulate location movement) and verify the coordinates change.

---

## 3. Order Details UI

### Goal
Verify the layout of the new Order Details screen.

### Test Steps
1.  Trigger an incoming order (Method A above).
2.  Tap **Accept**.
3.  **Expected Result:**
    *   The app navigates to the "Order Details" page.
    *   **Header:** Shows "Order Details" with a white background.
    *   **Order Card:** Displays "New Order", Order ID, Restaurant Name ("Burger King #402"), and Customer Name ("John Doe").
    *   **Items Card:** Lists items (Whopper Meal, Coke Zero) with prices and a Total ($15.99).
    *   **Buttons:** Two distinct buttons at the bottom: "Decline" (Red) and "Start Delivery" (Green).
