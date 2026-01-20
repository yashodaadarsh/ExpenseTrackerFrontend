# 📱 ExpenseTracker Mobile App (Flutter)

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?style=flat-square&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?style=flat-square&logo=dart)
![Android](https://img.shields.io/badge/Platform-Android-3DDC84?style=flat-square&logo=android)
![Automation](https://img.shields.io/badge/Feature-SMS%20Automation-FF6F00?style=flat-square&logo=googlecloud)

##  Executive Summary
The **ExpenseTracker Frontend** is a cross-platform mobile application built with **Flutter**, designed to serve as the primary interface for the microservices-based backend. 

Beyond standard CRUD operations, this application solves a major user pain point—manual data entry—by implementing **Background SMS Listening**. The app automatically detects transaction alerts from banks, parses the amount and merchant, and logs the expense without user intervention, ensuring 100% financial tracking accuracy.

---

##  Key Feature: Automatic Expense Automation
*The flagship feature that differentiates this application from standard expense trackers.*

### **How It Works (Telephony Integration)**
1.  **Background Listening:** The app utilizes a custom Telephony implementation (`packages/telephony`) to listen for incoming SMS messages safely in the background.

2.  **Edge Capture (Mobile):** 
* The app uses a background service (`packages/telephony`) to securely intercept transaction SMS messages in real-time.
    * Instead of processing locally, it acts as a secure conduit, forwarding the **raw message payload** to the backend via the Kong API Gateway.

3.  **Cloud Processing (LLM Engine):**
    * The backend **Data Science Service** receives the raw text.
    * An **LLM (Large Language Model)** analyzes the natural language of the SMS. It intelligently distinguishes between a "spent" transaction, a "received" refund, or a spam message, extracting:
        * **Amount** (normalized currency)
        * **Merchant** (context-aware extraction)
        * **Category** (AI-predicted tagging)
3.  **Result:** * The user swipes their card, receives an SMS, and the expense appears in the app automatically—tagged, categorized, and cleaned by AI without a single manual tap.
---

##  Tech Stack & Modules
* **Framework:** Flutter (Dart)
* **State Management:** Provider / BLoC (Scalable state handling)
* **Native Integration:** Kotlin (Android) & Swift (iOS) bridges for deep system access.
* **Networking:** Dio / Http (for communicating with Kong API Gateway)
* **Local Storage:** Hive / Shared Preferences (for offline caching)

---

##  Application Architecture
The app follows a **Clean Architecture** principle to ensure maintainability and testability.

| Layer | Responsibility |
| :--- | :--- |
| **Presentation** | Flutter Widgets, UI logic, and Animations. |
| **Domain/Logic** | State management and business rules (e.g., parsing logic). |
| **Data** | API repositories (Retrofit/Dio) and Local Database. |
| **Services** | Background services for SMS listening (`android/` & `packages/telephony`). |

---

##  Getting Started

### **Prerequisites**
* Flutter SDK installed (`flutter doctor`)
* Android Studio / VS Code
* Physical Android Device (required for testing SMS features)

### **Installation**
1.  **Clone the Repository**
    ```bash
    git clone [https://github.com/yashodaadarsh/ExpenseTrackerFrontend.git](https://github.com/yashodaadarsh/ExpenseTrackerFrontend.git)
    cd ExpenseTrackerFrontend
    ```

2.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run the App**
    * Ensure your backend services (Docker) are running.
    * Connect your device via USB.
    * Run:
    ```bash
    flutter run
    ```

### **Permissions Note**
* On first launch, the app will request `READ_SMS` and `RECEIVE_SMS` permissions. These are strictly required for the automation feature to function.

---

## Screenshots
*(Add your screenshots here: Login Screen, Dashboard, and an "Expense Added" Notification)*

| Dashboard | Auto-Log Notification | Analytics View |
| :---: | :---: | :---: |
| ![Dashboard](https://via.placeholder.com/200x400?text=Dashboard) | ![Notification](https://via.placeholder.com/200x400?text=SMS+Detected) | ![Analytics](https://via.placeholder.com/200x400?text=Graphs) |

---
