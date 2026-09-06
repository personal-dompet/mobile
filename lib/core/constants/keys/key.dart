import 'package:flutter/material.dart';

const initialSetupKey = Key('initial_setup_key');

/// Kunci widget untuk integration test. Tidak berpengaruh ke tampilan;
/// dipakai agar test tidak bergantung pada teks UI yang bisa berubah.
abstract class TestKeys {
  // Bottom sheet tambah dompet (open_add_account_bottom_sheet).
  static const addAccountType = ValueKey('add_account_type');
  static const addAccountName = ValueKey('add_account_name');
  static const addAccountBalance = ValueKey('add_account_balance');
  static const addAccountSave = ValueKey('add_account_save');
  static const addAccountCancel = ValueKey('add_account_cancel');

  // Halaman form dompet (AssetFormPage).
  static const assetFormType = ValueKey('asset_form_type');
  static const assetFormName = ValueKey('asset_form_name');
  static const assetFormBalance = ValueKey('asset_form_balance');
  static const assetFormSave = ValueKey('asset_form_save');

  // Halaman transaksi (TransactionPage).
  static const transactionAmount = ValueKey('transaction_amount');
  static const transactionAsset = ValueKey('transaction_asset');
  static const transactionSave = ValueKey('transaction_save');

  // Halaman pindah dana (TransferPage).
  static const transferAmount = ValueKey('transfer_amount');
  static const transferSource = ValueKey('transfer_source');
  static const transferDestination = ValueKey('transfer_destination');
  static const transferSwap = ValueKey('transfer_swap');
  static const transferSave = ValueKey('transfer_save');

  // Dialog konfirmasi generik (DompetDialog).
  static const dialogCancel = ValueKey('dialog_cancel');
  static const dialogConfirm = ValueKey('dialog_confirm');
}
