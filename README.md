# Attendance Management App

## 📌 Overview
This is a **Flutter application** designed to manage and display employee absences efficiently. It meets all the **product requirements**, including listing absences, filtering by type and date, pagination, and exporting absences to an **iCal file** for import into Outlook.

## 🚀 Features
- ✅ View a **list of employee absences** with essential details.
- ✅ **Pagination**: Loads the first 10 absences and supports loading more.
- ✅ **Total Absences Count**: Displays the total number of absences.
- ✅ Each absence includes:
    - **Employee Name**
    - **Type of Absence** (e.g., Sickness, Vacation, Other)
    - **Period** (Start & End Dates)
    - **Member Note** (if available)
    - **Status** (Requested, Confirmed, Rejected)
    - **Admitter Note** (if available)
- ✅ **Filtering**:
    - By **absence type**
    - By **date range**
- ✅ **Loading State**: Displays a loading indicator while fetching data.
- ✅ **Error Handling**: Shows an error message if the list fails to load.
- ✅ **Empty State**: Indicates when no absences are found.
- ✅ **Export to iCal**: Generates an **.ics file** that can be imported into **Outlook**.

## 🛠️ Tech Stack
- **Flutter** (UI framework)
- **Dart** (Programming language)
- **BLoC (Business Logic Component)** (State management)
- **Equatable** (For value comparisons in BLoC)
- **Intl** (For date formatting)
- **flutter_test** (Unit & widget testing)
- **bloc_test** (For testing BLoC logic)

## 📂 Folder Structure
```
lib/
├── core/                 # Core utilities, resources, and common widgets
│   ├── res/              # Colors, media assets
│   ├── utils/            # Helper functions and constants
│   ├── errors/           # Exception and failure handling
├── src/
│   ├── home/
│   │   ├── domain/       # Business logic (Entities, Use Cases)
│   │   ├── data/         # Data sources and repositories
│   │   ├── presentation/ # UI (Widgets, Screens, BLoC)
│   │       ├── bloc/     # AbsencesBloc for state management
└── main.dart             # App entry point
```

## 🏗️ Setup & Installation
### 1️⃣ **Clone the Repository**
```sh
git clone https://github.com/rajatkdhamija/attendance_management.git
cd attendance-management
```

### 2️⃣ **Install Dependencies**
```sh
flutter pub get
```

### 3️⃣ **Run the App**
```sh
flutter run
```

## 🧪 Running Tests
Unit and widget tests ensure the app works correctly.
```sh
flutter test
```

## 🎯 API / Data Handling
- The app uses **mock JSON files** for demonstration purposes.

## 📜 License
This project is licensed under the **MIT License**.

## 👨‍💻 Author
- **Rajat Dhamija**
- ✉️ [Your Email](mailto:rajatkdhamija@gmail.com)
---

