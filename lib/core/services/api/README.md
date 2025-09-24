# Services API Directory

This directory contains API service clients for communicating with the backend.

## Purpose

API services in this directory:

- Handle HTTP communication with the backend API
- Serialize/deserialize JSON data
- Handle API errors and exceptions
- Manage authentication tokens

## Structure

- `api_client.dart` - Main API client implementation
- `auth_service.dart` - Authentication API service
- `wallet_service.dart` - Wallet API service
- `pocket_service.dart` - Pocket API service
- `transaction_service.dart` - Transaction API service
- `analytics_service.dart` - Analytics API service

## Implementation

Each API service:

- Uses Dio or http package for HTTP requests
- Handles request/response interceptors
- Implements error handling and retry logic
- Manages authentication headers

## Example

```dart
class WalletService {
  final ApiClient _apiClient;
  
  WalletService(this._apiClient);
  
  Future<WalletModel> getWallet() async {
    try {
      final response = await _apiClient.get<WalletModel>('/wallets/me');
      return WalletModel.fromJson(response.data);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        // Create a new wallet if one doesn't exist
        return await createWallet();
      }
      rethrow;
    }
  }
  
  Future<WalletModel> updateWalletBalance(double amount) async {
    try {
      final response = await _apiClient.patch<WalletModel>(
        '/wallets/me/balance',
        data: {'amount': amount},
      );
      return WalletModel.fromJson(response.data);
    } catch (e) {
      throw WalletApiException('Failed to update wallet balance: $e');
    }
  }
  
  Future<WalletModel> createWallet() async {
    try {
      final response = await _apiClient.post<WalletModel>('/wallets');
      return WalletModel.fromJson(response.data);
    } catch (e) {
      throw WalletApiException('Failed to create wallet: $e');
    }
  }
}
```
