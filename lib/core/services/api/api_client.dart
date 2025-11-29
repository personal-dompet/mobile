import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio();

  dio.options.baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  dio.options.connectTimeout = Duration(milliseconds: 30000);
  dio.options.receiveTimeout = Duration(milliseconds: 30000);
  dio.options.headers['Content-Type'] = 'application/json';

  dio.interceptors.add(_AuthInterceptor());

  if (kDebugMode) {
    dio.interceptors.add(_DelayInterceptor());
    dio.interceptors.add(_DebugInterceptor());
  }
  return dio;
});

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final token = await user.getIdToken();
    options.headers['Authorization'] = 'Bearer $token';
    super.onRequest(options, handler);
  }
}

class _DelayInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    await Future.delayed(Duration(seconds: 3));
    super.onRequest(options, handler);
  }
}

class _DebugInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('Request Error ${err.response?.statusCode}: $err');
    super.onError(err, handler);
  }
}
