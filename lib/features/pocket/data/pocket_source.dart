import 'package:dio/dio.dart';
import 'package:dompet/core/services/api/api_client.dart';
import 'package:dompet/features/pocket/domain/forms/create_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_recurring_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_saving_pocket_form.dart';
import 'package:dompet/features/pocket/domain/forms/create_spending_pocket_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PocketSource {
  final Dio _dio;

  static final _prefix = '/api/pockets';

  PocketSource(this._dio);

  Future<List<dynamic>> getPockets() async {
    final response = await _dio.get(_prefix);
    return response.data ?? [];
  }

  Future<Map<String, dynamic>> create(CreatePocketForm form) async {
    final response = await _dio.post(_prefix, data: form.json);
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> createSpending(CreatePocketForm pocketForm,
      CreateSpendingPocketForm spendingForm) async {
    final response = await _dio.post('$_prefix/spendings', data: {
      ...pocketForm.json,
      ...spendingForm.json,
    });
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> createSaving(
      CreatePocketForm pocketForm, CreateSavingPocketForm savingForm) async {
    final response = await _dio.post('$_prefix/savings', data: {
      ...pocketForm.json,
      ...savingForm.json,
    });
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> createRecurring(CreatePocketForm pocketForm,
      CreateRecurringPocketForm recurringForm) async {
    final response = await _dio.post('$_prefix/recurrings', data: {
      ...pocketForm.json,
      ...recurringForm.json,
    });
    return response.data ?? {};
  }
}

final pocketSourceProvider = Provider.autoDispose<PocketSource>((ref) {
  final dio = ref.read(apiClientProvider);
  return PocketSource(dio);
});
