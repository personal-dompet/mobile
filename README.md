# Dompet - Personal Finance Management App

<div align="center">
  <p>Dompet is a revolutionary personal finance management application that transforms how you manage your money with an intuitive "pocket" based system.</p>

  [![Flutter](https://img.shields.io/badge/Flutter-Framework-1FB7EC.svg?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-Language-0175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
  [![MIT License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)
  [![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-9CF.svg?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)

  ![Dompet Screenshot](assets/images/app_screenshot.png)
</div>

## 💡 The Problem
Managing personal finances can be overwhelming. Traditional budgeting apps often fall short of capturing real-world financial behaviors where people allocate money for different purposes. Most people use multiple bank accounts, apps, or mental notes to separate their money, leading to confusion and financial stress.

## 🔥 The Solution
Dompet introduces a revolutionary "pocket" system that mirrors how we naturally think about money:
- **Spending Pockets**: For daily expenses and discretionary spending
- **Saving Pockets**: Goals-based savings for future plans
- **Recurring Pockets**: For regular bills and subscriptions
- **Investment Pockets**: Track your investment portfolios
- **Debt Pockets**: Manage and pay down debts systematically

## ✨ Key Features

### 🎯 Pocket-Based Finance Management
- Create and manage multiple financial "pockets" for different purposes
- Intuitive categorization that mirrors real-world financial behavior
- Visual representation of your financial health across all pockets

### 📱 Mobile-First Experience
- Built with Flutter for a consistent experience across platforms
- Offline-first architecture with seamless synchronization
- Intuitive, modern UI/UX design

### 🔐 Secure Authentication
- Google Sign-In for easy and secure access
- Firebase JWT token verification
- Privacy-focused design with data stored securely

### 📈 Analytics & Insights
- Comprehensive spending and saving reports
- Visual charts and trend analysis
- Financial goal tracking and progress monitoring

### 🔄 Offline Functionality
- Full app functionality without internet connection
- Automatic data synchronization when online
- No loss of data during network interruptions

### 💳 Transaction Management
- Easy transaction recording and categorization
- Wallet-based fund transfers
- Recurring transaction automation

## 🚀 Quick Start

### Prerequisites

#### Mobile Development
- [Flutter SDK](https://flutter.dev/) (3.10.0 or higher)
- Android Studio or VS Code with Flutter extensions
- Android SDK (API level 26 or higher) or Xcode for iOS
- Git

### Setup & Run

1. Clone the repository:
```bash
git clone https://github.com/your-username/dompet.git
cd dompet/mobile
```

2. Install dependencies:
```bash
flutter pub get
```

3. Verify Flutter installation:
```bash
flutter doctor
```

4. Run the app:
```bash
flutter run
```

### Environment Configuration
Create a `.env` file in the assets folder based on `.env.example` for API configuration and other environment variables.

## 🏗️ Architecture Overview

Dompet follows a clean architecture approach with separation of concerns:

- **UI Layer**: Flutter-based user interface components
- **Business Logic**: Riverpod state management and business rules
- **Data Layer**: Local SQLite storage and API integration
- **Core Services**: Authentication, validation, and utility functions

## 🤝 Contributing

We welcome contributions from the community! Whether you're fixing a bug, adding a feature, or improving documentation, your help is appreciated.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Commit your changes following our [commit guide](COMMIT_GUIDE.md)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

Please read our [contributing guidelines](CONTRIBUTING.md) for more details.

## 📚 Documentation

- [Architecture Overview](../documentation/dompet-architecture.md)
- [Data Model](../documentation/dompet-data-model.md)
- [API Specification](../documentation/dompet-api-spec.md)
- [Quick Start Guide](../documentation/dompet-quick-start-guide.md)
- [Developer Tasks](../documentation/dompet-developer-tasks.md)
- [Commit Guide](COMMIT_GUIDE.md)

## 🛠️ Tech Stack

| Component | Technology |
|-----------|------------|
| **Frontend** | Flutter, Dart |
| **State Management** | Riverpod |
| **Networking** | Dio |
| **Local Storage** | SQLite |
| **Authentication** | Google Sign-In, Firebase JWT |
| **UI Components** | Flutter Material Design |
| **Charts** | fl_chart |

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🚀 Deployment

The mobile app can be deployed to both Google Play Store and Apple App Store. For development and testing, the app can run on both Android and iOS devices.

## 🙏 Acknowledgments

- Thanks to the Flutter community for the amazing framework and resources
- All contributors who help make Dompet better
- Our users who provide valuable feedback and insights

---

<div align="center">
  Made with ❤️ using Flutter<br>
  <sub>Built with the goal of helping everyone achieve financial clarity</sub>
</div>
