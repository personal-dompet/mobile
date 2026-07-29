import 'package:dompet_app/core/widgets/spinner_loading.dart';
import 'package:flutter/material.dart';

class LoadingOverlay {
  OverlayEntry? _overlayEntry;

  // Fungsi untuk menampilkan loading
  void show(BuildContext context, {String? text}) {
    if (_overlayEntry != null) return; // Mencegah duplikasi overlay

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Background gelap transparan agar UI di belakang tidak bisa diklik
          ModalBarrier(
            color: Colors.black.withValues(alpha: 0.5),
            dismissible: false,
          ),
          // Widget loading di tengah layar
          Center(
            child: SizedBox(
              width: 200, // Kunci lebar Card di sini agar konsisten
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                    16.0,
                  ), // Padding dipindah ke sini agar rapi
                  child: SpinnerLoading(text: text),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Memasukkan overlay ke dalam layar aktif
    Overlay.of(context).insert(_overlayEntry!);
  }

  // Fungsi untuk menyembunyikan loading
  void hide() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}
