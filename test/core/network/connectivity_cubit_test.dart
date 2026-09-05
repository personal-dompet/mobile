import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dompet_app/core/network/connectivity_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConnectivityCubit.isOnlineFromResults', () {
    test('none saja berarti offline', () {
      expect(
        ConnectivityCubit.isOnlineFromResults([ConnectivityResult.none]),
        isFalse,
      );
    });

    test('wifi/mobile/vpn berarti online', () {
      expect(
        ConnectivityCubit.isOnlineFromResults([ConnectivityResult.wifi]),
        isTrue,
      );
      expect(
        ConnectivityCubit.isOnlineFromResults([ConnectivityResult.mobile]),
        isTrue,
      );
      expect(
        ConnectivityCubit.isOnlineFromResults([
          ConnectivityResult.none,
          ConnectivityResult.vpn,
        ]),
        // none tidak pernah campur tipe lain di API v7, tapi jika terjadi
        // maka hasil non-none tetap menang (online).
        isTrue,
      );
    });

    test('list kosong dianggap offline', () {
      expect(ConnectivityCubit.isOnlineFromResults([]), isFalse);
    });
  });
}
