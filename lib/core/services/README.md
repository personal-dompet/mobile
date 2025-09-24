# Services Directory

This directory contains service implementations for various application functionalities.

## Purpose

The services layer provides implementations for:

- API communication and HTTP clients
- Authentication services
- Local storage services
- Third-party integrations
- Background services

## Structure

- `/api` - API service clients for communicating with the backend
- `/auth` - Authentication services (Google Sign-In)
- `/storage` - Local storage services (secure storage, preferences)
- `/analytics` - Analytics services (if applicable)

## Implementation

Services in this layer handle the technical implementation details of external integrations and provide a clean interface for the rest of the application to use.

## Example

```dart
// API Service
class WalletService {
  final ApiClient apiClient;
  
  Future<Wallet> getWallet() async {
    final response = await apiClient.get('/wallets/me');
    return Wallet.fromJson(response.data);
  }
}

// Auth Service
class GoogleAuthService {
  Future<User> signInWithGoogle() async {
    // Implementation for Google Sign-In
  }
}
```
