import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/core/constants/keys/key.dart';
import 'package:dompet_app/core/extensions/icon_data.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/assets/forms/asset_form.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

Future<AssetForm?> openAddAccountBottomSheet(
  BuildContext context, {
  List<Account>? presetAccounts,
  Account? selectedPresetAccount,
}) async {
  final form = AssetForm();
  form.codeControl.value = selectedPresetAccount?.code;

  String placeholder = 'Contoh: Dompet Utama';

  if (selectedPresetAccount?.name == AccountPreset.bank.value) {
    placeholder = 'Contoh: BCA';
  } else if (selectedPresetAccount?.name == AccountPreset.eWallet.value) {
    placeholder = 'Contoh: GoPay';
  } else if (selectedPresetAccount?.name == AccountPreset.investment.value) {
    placeholder = 'Contoh: Bibit';
  }

  final result = await showModalBottomSheet<AssetForm?>(
    context: context,
    isDismissible: false,
    useSafeArea: true,
    enableDrag: true,
    isScrollControlled: true,
    builder: (context) {
      final themeData = Theme.of(context);
      return BottomSheet(
        onClosing: () {
          debugPrint('closing');
        },
        builder: (context) {
          return Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: ReactiveForm(
              formGroup: form,
              child: Padding(
                padding: const EdgeInsets.all(16).copyWith(bottom: 24),
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .stretch,
                  spacing: 16,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        spacing: 8,
                        children: [
                          if (selectedPresetAccount != null &&
                              selectedPresetAccount.iconCode != null)
                            Icon(
                              MaterialIconData.fromCode(
                                selectedPresetAccount.iconCode!,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              'Tambahkan Dompet ${selectedPresetAccount == null ? 'Baru' : selectedPresetAccount.name}',
                              style: themeData.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 12,
                      children: [
                        if (presetAccounts != null && presetAccounts.isNotEmpty)
                          DompetDropdownField(
                            key: TestKeys.addAccountType,
                            formControl: form.codeControl,
                            items: presetAccounts.map((account) {
                              return DropdownMenuItem(
                                value: account.code,
                                child: Text(account.name),
                              );
                            }).toList(),
                            label: 'Jenis Dompet',
                            placeholder: 'Pilih jenis dompet ini',
                            validationMessages: {
                              ValidationMessage.required: (_) =>
                                  'Pilih jenis dompet dahulu',
                            },
                          ),
                        DompetTextField(
                          key: TestKeys.addAccountName,
                          label: 'Nama Dompet',
                          formControl: form.nameControl,
                          placeholder: placeholder,
                          textInputAction: .next,
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                'Masukkan nama dompet terlebih dahulu',
                          },
                        ),
                        DompetNumberField(
                          key: TestKeys.addAccountBalance,
                          labelText: 'Saldo saat ini (Opsional)',
                          formControl: form.balanceControl,
                          border: OutlineInputBorder(),
                          isCurrency: true,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: .end,
                      spacing: 16,
                      children: [
                        TextButton(
                          key: TestKeys.addAccountCancel,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              color: themeData.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        FilledButton(
                          key: TestKeys.addAccountSave,
                          onPressed: () {
                            form.markAllAsTouched();
                            if (form.valid) {
                              Navigator.pop(context, form);
                            }
                          },
                          child: Text('Simpan'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        enableDrag: true,
      );
    },
  );
  return result;
}
