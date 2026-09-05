import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;

/// Scopes needed for backup. appDataFolder is private per-app.
class BackupScopes {
  static const appData = 'https://www.googleapis.com/auth/drive.appdata';
  static const all = [appData];
}

/// Web OAuth Client ID (opsi B: via --dart-define, bukan hardcode).
///
/// Cara run dengan `flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=...`
/// atau `--dart-define-from-file=env.json` (lihat env.example.json).
class BackupConfig {
  static const serverClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );
}

class BackupAuthService {
  final String serverClientId;

  BackupAuthService({String? serverClientId})
      : serverClientId = serverClientId ?? BackupConfig.serverClientId;

  bool _initialized = false;
  GoogleSignInAccount? _currentAccount;

  bool get isInitialized => _initialized;
  GoogleSignInAccount? get currentAccount => _currentAccount;

  /// Must be called once at startup before any other method.
  Future<void> ensureInitialized() async {
    if (_initialized) return;
    if (serverClientId.isEmpty) {
      throw StateError(
        'GOOGLE_SERVER_CLIENT_ID kosong. Jalankan dengan '
        '--dart-define=GOOGLE_SERVER_CLIENT_ID=<web-client-id> '
        'atau --dart-define-from-file=env.json (lihat env.example.json).',
      );
    }
    await GoogleSignIn.instance.initialize(serverClientId: serverClientId);
    _initialized = true;

    // Try lightweight sign-in restoration (no UI)
    try {
      final maybeAccount = GoogleSignIn.instance
          .attemptLightweightAuthentication();
      if (maybeAccount != null) {
        _currentAccount = await maybeAccount;
      }
    } catch (error) {
      debugPrint('[BackupAuthService] $error');
      // No previous session or error → stay signed out
      _currentAccount = null;
    }

    // Listen to future auth events to keep _currentAccount in sync
    GoogleSignIn.instance.authenticationEvents.listen(
      (event) {
        if (event is GoogleSignInAuthenticationEventSignIn) {
          _currentAccount = event.user;
        } else if (event is GoogleSignInAuthenticationEventSignOut) {
          _currentAccount = null;
        }
      },
      onError: (_) {
        _currentAccount = null;
      },
    );
  }

  /// Interactive sign-in. Must be called from user gesture.
  Future<GoogleSignInAccount> authenticate() async {
    if (!_initialized) {
      await ensureInitialized();
    }
    final account = await GoogleSignIn.instance.authenticate(
      scopeHint: BackupScopes.all,
    );
    _currentAccount = account;
    return account;
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    _currentAccount = null;
  }

  /// Returns an authenticated HTTP client for Drive API.
  ///
  /// Handles the two-step authz flow: authorizationForScopes → authorizeScopes.
  Future<gapis.AuthClient> getAuthClient({GoogleSignInAccount? account}) async {
    final acc = account ?? _currentAccount;
    if (acc == null) {
      throw StateError('Not signed in. Call authenticate() first.');
    }

    final client = acc.authorizationClient;

    // 1. Try without UI
    var authz = await client.authorizationForScopes(BackupScopes.all);
    // 2. Fallback to interactive (requires user gesture context)
    authz ??= await client.authorizeScopes(BackupScopes.all);

    return authz.authClient(scopes: BackupScopes.all);
  }

  /// Tries to get auth client after ensuring sign-in.
  Future<gapis.AuthClient> ensureAuthClient() async {
    var account = _currentAccount;
    account ??= await authenticate();
    return getAuthClient(account: account);
  }

  bool get isSignedIn => _currentAccount != null;
}
