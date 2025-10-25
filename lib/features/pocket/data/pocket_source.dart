import 'package:dio/dio.dart';
import 'package:dompet/core/services/api/api_client.dart';
import 'package:dompet/features/pocket/domain/forms/create_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_recurring_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_saving_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_spending_pocket_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketSource {
  final Dio _dio;
  final Ref _ref;

  static final _prefix = '/api/pockets';

  PocketSource(this._ref, this._dio);

  Future<List<dynamic>> getPockets() async {
    final response = await _dio.get(_prefix);
    return response.data ?? [];
  }

  Future<Map<String, dynamic>> create() async {
    try {
      final form = _ref.read(createPocketFormProvider);
      final response = await _dio.post(_prefix, data: form.json);
      return response.data ?? {};
    } finally {
      _ref.invalidateSelf();
    }
  }

  Future<Map<String, dynamic>> createSpending() async {
    try {
      final pocketForm = _ref.read(createPocketFormProvider);
      final spendingForm = _ref.read(createSpendingPocketFormProvider);
      final response = await _dio.post('$_prefix/spendings', data: {
        ...pocketForm.json,
        ...spendingForm.json,
      });
      return response.data ?? {};
    } finally {
      _ref.invalidateSelf();
    }
  }

  Future<Map<String, dynamic>> createSaving() async {
    try {
      final pocketForm = _ref.read(createPocketFormProvider);
      final savingForm = _ref.read(createSavingPocketFormProvider);
      final response = await _dio.post('$_prefix/savings', data: {
        ...pocketForm.json,
        ...savingForm.json,
      });
      return response.data ?? {};
    } finally {
      _ref.invalidateSelf();
    }
  }

  Future<Map<String, dynamic>> createRecurring() async {
    try {
      final pocketForm = _ref.read(createPocketFormProvider);
      final recurringForm = _ref.read(createRecurringPocketFormProvider);
      final response = await _dio.post('$_prefix/recurrings', data: {
        ...pocketForm.json,
        ...recurringForm.json,
      });
      return response.data ?? {};
    } finally {
      _ref.invalidateSelf();
    }
  }
}

final pocketSourceProvider = Provider<PocketSource>((ref) {
  final dio = ref.read(apiClientProvider);
  return PocketSource(ref, dio);
});
