# QWEN.md - Dompet Mobile Application

## Project Overview

**Dompet** is a comprehensive personal finance management mobile application developed using Flutter. It implements a unique "pocket" based system that helps users manage their finances by allocating funds to different categories such as spending, saving, recurring payments, investments, and debt management.

This project is designed as a mobile-first solution with offline functionality and synchronization capabilities, targeting both Android and iOS platforms.

## Technology Stack

- **Framework**: Flutter (Dart)
- **State Management**: Riverpod
- **Routing**: go_router
- **Networking**: Dio
- **Local Storage**: SQLite (with flutter_secure_storage and shared_preferences)
- **Authentication**: Google Sign-In with Firebase
- **UI Components**: Flutter Material Design
- **Charts**: fl_chart for financial analytics
- **Forms**: reactive_forms
- **Internationalization**: intl
- **Environment variables**: flutter_dotenv

## Project Structure

```
dompet/mobile/
├── lib/                    # Main source code
│   ├── core/              # Shared utilities and constants
│   │   ├── constants/     # App constants
│   │   ├── enum/          # App enumerations
│   │   ├── services/      # Core services
│   │   ├── utils/         # Utility functions
│   │   └── widgets/       # Reusable UI widgets
│   ├── features/          # Feature modules (clean architecture)
│   │   ├── account/       # Account management feature
│   │   ├── auth/          # Authentication feature
│   │   ├── home/          # Home screen feature
│   │   ├── pocket/        # Pocket management feature
│   │   ├── transaction/   # Transaction management
│   │   ├── transfer/      # Transfer functionality
│   │   └── wallet/        # Wallet management
│   ├── main.dart          # App entry point
│   ├── router.dart        # Navigation router
│   └── theme_data.dart    # App theme definitions
├── assets/                # Static assets
│   ├── fonts/
│   ├── icons/
│   ├── images/
│   ├── translations/
│   └── .env               # Environment variables
├── test/                  # Test files
├── android/               # Android-specific build files
├── ios/                   # iOS-specific build files (not shown)
├── pubspec.yaml           # Project dependencies and assets
└── README.md              # Project documentation
```

### Feature Structure (Clean Architecture)

Each feature follows a clean architecture pattern with three layers:

```
feature/
├── data/          # Data sources and repositories
├── domain/        # Business logic and entities
└── presentation/  # UI and state management
    ├── pages/     # Screen widgets
    └── widgets/   # UI components
```

## Key Features

1. **Pocket-Based Finance Management**: Users can create different "pockets" for spending, saving, recurring payments, investments, and debt management
2. **Offline-First Architecture**: Full functionality available without internet connection with automatic synchronization
3. **Secure Authentication**: Google Sign-In with Firebase JWT token verification
4. **Transaction Management**: Record and categorize financial transactions
5. **Analytics & Insights**: Comprehensive reports and visualizations
6. **Multi-Platform Support**: Single codebase for Android and iOS

## Building and Running

### Prerequisites
- Flutter SDK (3.10.0 or higher)
- Android Studio or VS Code with Flutter extensions
- Android SDK (API level 26 or higher) or Xcode for iOS
- Git

### Setup Instructions

1. Clone the repository
2. Navigate to the mobile directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Verify Flutter installation:
   ```bash
   flutter doctor
   ```
5. Configure environment variables by creating a `.env` file based on `.env.example`
6. Run the app:
   ```bash
   flutter run
   ```

### Environment Configuration
- Create a `.env` file in the project root based on `.env.example`
- Configure API endpoints and other environment-specific variables

## Development Conventions

### Code Style
- Follow Dart/Flutter official style guide
- Use Riverpod for state management
- Implement clean architecture principles
- Use meaningful variable and function names
- Follow the pubspec.yaml linter rules (based on flutter_lints)

### Commit Messages
The project follows conventional commits specification:
- Format: `<type>[optional scope]: <description>`
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`
- Use imperative mood (e.g., "Add feature" not "Added feature")
- Reference issues when appropriate

### Testing
- Use Flutter's built-in testing framework
- Write widget tests for UI components
- Follow TDD practices where appropriate
- Current tests are in the `test/` directory

## Architecture

The application follows clean architecture principles with separation of concerns:

- **UI Layer**: Flutter-based user interface components
- **Business Logic**: Riverpod state management and business rules
- **Data Layer**: Local SQLite storage and API integration
- **Core Services**: Authentication, validation, and utility functions

## Dependencies

Key dependencies include:
- flutter_riverpod: For state management
- dio: For HTTP requests
- firebase_core/auth: For authentication
- fl_chart: For financial charting
- go_router: For navigation
- flutter_dotenv: For environment variables

## File Extensions and Patterns

- **.dart**: All source code files
- **.env**: Environment configuration
- **.png/.jpg**: Image assets
- **.svg**: Vector graphics (if present)
- **pubspec.yaml**: Project configuration
- **analysis_options.yaml**: Code analysis rules

## Navigation

The app uses go_router for navigation with a shell-based structure:
- Bottom navigation bar with Dompet (home), Pocket, Account, and Transfer tabs
- Additional screens for creating and managing entities
- AuthGuard to protect routes requiring authentication

## Testing

- Unit tests for business logic
- Widget tests for UI components
- Integration tests for feature flows
- Test files are located in the `test/` directory

## Deployment

The application can be deployed to both Google Play Store and Apple App Store. The app supports Android 8.0+ (API level 26+) and iOS 12+. For development and testing, it can run on both Android and iOS simulators/devices.

## Special Considerations

- The app uses environment variables loaded from `.env` file
- Firebase is initialized at app startup for authentication
- The app has offline functionality with data synchronization
- ProviderScope is used for Riverpod state management at the app level
- Each feature follows a clean architecture pattern with clear separation of concerns