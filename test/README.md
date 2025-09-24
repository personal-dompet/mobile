# Test Directory

This directory contains all tests for the mobile application.

## Purpose

The test directory holds:
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for complete features
- Test utilities and mocks

## Structure

- `/unit` - Unit tests for use cases, entities, and utilities
- `/widget` - Widget tests for UI components
- `/integration` - Integration tests for complete features
- `/mocks` - Mock implementations for testing
- `/utils` - Test utilities and helpers

## Testing Strategy

Following the testing pyramid:
1. **Unit Tests** (70%) - Test business logic, use cases, and utilities
2. **Widget Tests** (20%) - Test UI components in isolation
3. **Integration Tests** (10%) - Test complete user flows

## Example

```dart
// Unit test example
void main() {
  group('WalletEntity', () {
    test('updateBalance should correctly add amount', () {
      final wallet = WalletEntity(
        id: 1,
        userId: 1,
        storedBalance: 100.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final updatedWallet = wallet.updateBalance(50.0);
      
      expect(updatedWallet.storedBalance, 150.0);
    });
    
    test('updateBalance should throw exception for insufficient funds', () {
      final wallet = WalletEntity(
        id: 1,
        userId: 1,
        storedBalance: 100.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      expect(
        () => wallet.updateBalance(-150.0),
        throwsA(isA<InsufficientFundsException>()),
      );
    });
  });
}
```