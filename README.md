# Smart Nutrition & Calorie Tracker (iOS – SwiftUI)

https://github.com/4LOKI/nutrition-tracker-ios-application/tree/main

This is an iOS application built with SwiftUI. It helps users track daily food intake, calories, macronutrients, water consumption, and visualize progress through interactive charts. The app works fully offline using JSON-based local storage.

---

## Features

### Food Logging
- Add meals with calories, protein, carbs, and fat.
- Add custom foods manually.
- Search existing food items.

### Dashboard
- View daily calorie intake and macro breakdown.
- Track water intake.
- View progress toward daily goals.

### Charts & Analytics
- Weekly and monthly calorie trends.
- Macro distribution charts.
- Water intake charts.
- Implemented using Swift Charts.

### User Profile
- Stores age, weight, height, gender.
- Activity level and calorie goals.
- Editable user profile.

### Local Storage
- All data is saved locally using JSON files.
- Persistence handled by `PersistenceManager.swift`.
- Works completely offline.

---

## Tech Stack

| Component       | Tools Used                                |
| --------------- | ----------------------------------------- |
| Frontend        | SwiftUI                                    |
| Architecture    | MVVM-inspired structure                    |
| State Management| `@State`, `@StateObject`, `@EnvironmentObject` |
| Data Models     | Swift `Codable`                             |
| Charts          | Swift Charts                                |
| Storage         | Local JSON files                             |
| Language        | Swift                                        |

---

## Project Structure



