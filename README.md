# MedSync

## AI-Powered Hospital Recommendation and Emergency Healthcare Assistance System

---

## Team Name

**TEAM VIOLET**

---

## Problem Statement

During medical emergencies, finding the right hospital quickly can be difficult. Patients and their attendants may have limited information about nearby hospitals, ICU and room availability, doctor availability, emergency services, and the distance to each hospital.

A hospital that is geographically close may not necessarily have the required ICU bed, room, specialist doctor, or emergency facility available at that moment. This can result in delays in receiving appropriate medical care.

MedSync aims to address this problem by providing a centralized healthcare assistance platform that helps users identify suitable hospitals based on their location, medical requirements, resource availability, and doctor availability.

---

## Solution Overview

MedSync is an AI-assisted healthcare platform designed to help users identify suitable hospitals based on their current location and medical requirements.

The platform consists of a **Flutter-based mobile application** for patients and a **web-based hospital management portal** for managing hospital information and resources.

The mobile application uses GPS-based location services to identify nearby hospitals and provides information such as hospital distance, emergency availability, ICU availability, room availability, and doctor availability.

Users can search for hospitals or specify a disease, medical condition, or emergency requirement. The system can analyze the available hospital information and rank suitable hospitals based on the user's requirements.

The platform also supports route/navigation and hospital booking functionality.

The hospital web portal provides the interface for managing hospital-side information and resources. This allows the healthcare ecosystem to maintain updated information that can be used by the patient-facing application.

---

## Key Features

### Patient Mobile Application

* Nearest hospital identification using GPS
* Hospital search functionality
* Disease and threat-based hospital recommendations
* Doctor availability checking
* ICU availability checking
* Room availability checking
* Emergency facility availability
* Hospital distance calculation
* Route and navigation support
* Hospital booking system
* AI-assisted hospital recommendation

### Hospital Web Portal

* Hospital resource management
* Hospital information management
* Doctor information and availability
* ICU and room availability management
* Firebase-based authentication
* Real-time Firestore data management
* Hospital-side resource updates

---

## Application Architecture

MedSync consists of two major application interfaces connected through the backend infrastructure.

```text
                    MEDSYNC
                       │
          ┌────────────┴────────────┐
          │                         │
          ▼                         ▼
  Patient Mobile App        Hospital Web Portal
      Flutter/Dart            React/Vite
          │                         │
          └────────────┬────────────┘
                       │
                       ▼
              Firebase Backend
                       │
          ┌────────────┼────────────┐
          │            │            │
          ▼            ▼            ▼
   Authentication   Firestore    Hosting
          │
          ▼
   Hospital Information
   Doctor Availability
   ICU Availability
   Room Availability
   Emergency Resources
   Booking Information
          │
          ▼
    AI Recommendation
          │
          ▼
   Suitable Hospital
```

---

## Application Workflow

```text
User
  │
  ▼
MedSync Mobile Application
  │
  ├───────────────┐
  │               │
  ▼               ▼
GPS Location    User Input
  │             Disease / Threat
  │               │
  └───────┬───────┘
          │
          ▼
   Hospital Search
          │
          ▼
 Hospital Availability
          │
    ┌─────┼─────┬──────────┐
    ▼     ▼     ▼          ▼
   ICU   Rooms Doctors   Emergency
    │     │      │          │
    └─────┴──────┴──────────┘
          │
          ▼
   AI Recommendation
          │
          ▼
 Suitable Hospital List
          │
       ┌──┴──┐
       ▼     ▼
     Route Booking
```

---

## Technology Stack

### Mobile Application

* Flutter
* Dart
* Android Studio
* Geolocator
* GPS / Device Location Services

### Hospital Web Portal

* React.js
* JavaScript (ES6)
* Vite
* HTML5
* CSS3
* Tailwind CSS

### Backend

* Firebase Authentication
* Firebase Firestore
* Firebase Hosting
* Firebase Security Rules

### AI / Machine Learning

* **Google Gemini 2.5 Flash**

The AI component is intended to analyze user medical requirements and hospital availability information to assist in recommending suitable hospitals.

### Database

* Firebase Firestore
* Firebase CLI

### Development Tools

* Android Studio
* Antigravity IDE
* Visual Studio Code
* Node.js
* npm

---

## AI-Based Hospital Recommendation

MedSync incorporates **Google Gemini 2.5 Flash** as the AI component of the platform.

The recommendation system is designed to consider the user's medical requirement together with available hospital information.

Potential recommendation factors include:

* Disease or medical requirement
* Emergency or threat level
* Hospital distance
* ICU availability
* Room availability
* Required doctor specialization
* Doctor availability
* Emergency facility availability

The resulting information can be used to identify and rank hospitals that are more suitable for the user's situation.

---

## Real-Time Hospital Information

The hospital web portal and patient-facing application are designed around a shared backend infrastructure using Firebase.

Hospital-side information can be maintained through the web portal, while the patient application can use the available hospital information when searching for suitable healthcare facilities.

This architecture allows MedSync to move toward real-time availability information rather than relying entirely on manually maintained static hospital data.

---

## Live Demonstration

**Live Demonstration:** [ADD LIVE DEMONSTRATION LINK HERE]

**Web Portal:** [ADD DEPLOYED WEB PORTAL LINK HERE]

**Mobile Application Demonstration:** [ADD MOBILE DEMO VIDEO/LINK HERE]

---

## Repository

**GitHub Repository:**

https://github.com/poorvajakr/HackMatrix-Team-violet

---

## Team Members

| Name                     | Role        |
| ------------------------ | ----------- |
| **Poorvaja KR**          | Team Leader |
| **Pragathesha Ds**       | Member      |
| **Poutheesh Kumar S**    | Member      |
| **Prasanna Venkatesh S** | Member      |

---

## Project Components

### Flutter Mobile Application

The patient-facing mobile application is developed using Flutter and Dart.

It provides:

* GPS-based hospital discovery
* Hospital search
* Hospital recommendations
* Doctor availability
* ICU and room availability
* Route/navigation
* Booking functionality

### Hospital Web Portal

The web-based hospital portal is developed using React.js and Vite.

It provides the hospital-side interface for managing hospital information and healthcare resources.

### Firebase Backend

Firebase provides the backend infrastructure for authentication, database management, hosting, and security.

---

## Setup Instructions

### Flutter Mobile Application

#### Prerequisites

Install:

* Flutter SDK
* Dart SDK
* Android Studio
* Android SDK
* Android Emulator or Android device

#### Install Dependencies

```bash
flutter pub get
```

#### Run the Application

```bash
flutter run
```

Alternatively, open the project in Android Studio, select an Android emulator or connected device, and click **Run**.

---

### Web Portal

#### Prerequisites

Install:

* Node.js
* npm

#### Install Dependencies

```bash
npm install
```

#### Start Development Server

```bash
npm run dev
```

The local development server can then be accessed through the URL displayed by Vite.

---

### Firebase Configuration

The Firebase configuration must be provided for the project components that use Firebase services.

The required Firebase services include:

* Firebase Authentication
* Firebase Firestore
* Firebase Hosting
* Firebase Security Rules

**Firebase configuration:** [ADD CONFIGURATION INSTRUCTIONS / ENVIRONMENT VARIABLES HERE]

---

## Project Structure

The project contains both the mobile application and the hospital web portal.

### Mobile Application

```text
Flutter / Dart
│
├── lib/
│   ├── core/
│   ├── models/
│   ├── screens/
│   ├── services/
│   ├── widgets/
│   └── main.dart
│
└── android/
```

### Hospital Web Portal

```text
React / Vite
│
├── src/
│   ├── components/
│   ├── pages/
│   ├── hooks/
│   ├── context/
│   ├── store/
│   ├── firebase/
│   └── utils/
│
└── public/
```

---

## Future Enhancements

* Real-time hospital resource synchronization
* Advanced AI-based emergency prioritization
* Real-time ICU and room availability
* Ambulance integration
* Advanced route optimization
* Push notifications
* Voice-based emergency assistance
* Multi-language support
* Patient medical profile integration
* Hospital-to-hospital resource coordination
* Predictive hospital resource analytics

---

## Disclaimer

MedSync is intended to assist users in identifying potentially suitable healthcare facilities based on available information.

The platform does not replace professional medical advice, diagnosis, or emergency medical services.

Hospital availability and doctor information should be verified with the respective healthcare facility before making critical medical decisions.

---

## License

**[ADD LICENSE INFORMATION HERE]**

---

## Contact

**Team:** TEAM VIOLET

**Repository:** https://github.com/poorvajakr/HackMatrix-Team-violet

**Live Demonstration:** [ADD LIVE DEMONSTRATION LINK HERE]

**Contact Email:** [ADD CONTACT EMAIL HERE]
