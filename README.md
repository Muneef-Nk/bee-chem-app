# ![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter&logoColor=white) BEE CHEM Mobile App


## Features

### Login Screen
- Email & Password input with validation (Email format + Password ≥ 6 characters)  
- "Remember Me" functionality (saves email locally)  
- Password visibility toggle  
- Custom SnackBars for success/error messages  
- Redirects to **Personnel List Screen** on successful login  

### Personnel List Screen
- Fetches personnel data via API  
- Displays **Full Name, Role, Contact Number, Full Address**  
- Search bar with input + “GO” button  
- Floating Action Button to navigate to **Add Personnel Screen**  
- Handles **loading, error, and empty states**  

### Add Personnel Screen
- Input fields: Full Name, Address, Suburb, State, Postcode, Country, Contact Number  
- Role dropdown fetched from API  
- Status toggle: Active / Inactive  
- Latitude & Longitude display  
- Save & Cancel buttons with form validation and API submission  

---

##  Tech Stack

- **Flutter** ≥3.x  
- **State Management**: Provider  
- **Networking**: HTTP  
- **Local Storage**: Shared Preferences  
- **Architecture**: Clean separation between core, data, and presentation layers  

---

## Project Structure

```text
lib/
├── core/
│   ├── constants/    # API endpoints
│   ├── network/      # HTTP client
│   ├── storage/      # SharedPreferences helper
│   └── utils/        # Form validators
├── data/
│   ├── models/       # Login, Personnel, Role models
│   └── services/     # API service classes
├── presentation/
│   ├── providers/    # State management
│   ├── screens/      # UI screens
│   └── widgets/      # Reusable widgets
└── main.dart
