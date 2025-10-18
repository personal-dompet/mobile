import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/enum/category.dart';
import 'package:dompet/core/widgets/card_input.dart';
import 'package:dompet/core/widgets/submit_button.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/create_pocket_form.dart';
import 'package:dompet/features/pocket/presentation/provider/pocket_provider.dart';
import 'package:dompet/features/pocket/presentation/widgets/color_picker.dart';
import 'package:dompet/features/pocket/presentation/widgets/icon_picker.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_icon.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_type_selector_bottom_sheet.dart';
import 'package:dompet/routes/routes.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreatePocketPage extends ConsumerWidget {
  const CreatePocketPage({super.key});

  // Get color based on pocket type
  Color _getPocketTypeColor(BuildContext context, PocketType type) {
    switch (type) {
      case PocketType.spending:
        return Colors.redAccent; // Red for spending
      case PocketType.saving:
        return Colors.greenAccent; // Green for saving
      case PocketType.recurring:
        return Colors.blueAccent; // Blue for recurring
      default:
        return AppTheme.primaryColor;
    }
  }

  Future<PocketCreationType?> _toCreateSpendingPocketPage(
    BuildContext context,
  ) async {
    final detailResult =
        await CreateSpendingPocketRoute().push<PocketCreationType?>(context);
    return detailResult;
  }

  Future<PocketCreationType?> _toCreateSavingPocketPage(
    BuildContext context,
  ) async {
    final detailResult =
        await CreateSavingPocketRoute().push<PocketCreationType?>(context);
    return detailResult;
  }

  Future<PocketCreationType?> _toCreateRecurringPocketPage(
    BuildContext context,
  ) async {
    final detailResult =
        await CreateRecurringPocketRoute().push<PocketCreationType?>(context);
    return detailResult;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pocketCreateForm = ref.watch(createPocketFormProvider);

    final iconControl = pocketCreateForm.icon;
    final colorControl = pocketCreateForm.color;

    final type = pocketCreateForm.type.value;

    if (iconControl.value == null) {
      iconControl.value = Category.getRandomCategory();
    }

    if (colorControl.value == null) {
      colorControl.value = PocketColor.randomColor;
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        // ref.invalidate(createPocketFormProvider);
      },
      child: ReactiveForm(
        formGroup: pocketCreateForm,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Create Pocket'),
            actions: [
              if (type != null)
                ReactiveFormConsumer(
                  builder: (context, formGroup, child) {
                    final form = formGroup as CreatePocketForm;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getPocketTypeColor(context, form.typeValue!)
                              .withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            form.typeValue!.icon,
                            color:
                                _getPocketTypeColor(context, form.typeValue!),
                          ),
                          onPressed: () async {
                            final result =
                                await showModalBottomSheet<PocketType>(
                              context: context,
                              isScrollControlled: true,
                              useRootNavigator: true,
                              builder: (context) =>
                                  const PocketTypeSelectorBottomSheet(),
                            );
                            if (result != null && context.mounted) {
                              final typeControl = form.type;
                              typeControl.value = result;
                            }
                          },
                        ),
                      ),
                    );
                  },
                )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ReactiveForm(
              formGroup: pocketCreateForm,
              child: ReactiveFormConsumer(
                builder: (context, formGroup, child) {
                  final form = formGroup as CreatePocketForm;
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: PocketIcon(
                          form: form,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CardInput(
                        label: 'Name',
                        child: ReactiveTextField<String>(
                          formControl: form.name,
                          autofocus: false,
                          decoration: const InputDecoration(
                            hintText: 'Enter pocket name',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      CardInput(
                        label: 'Color',
                        child: ColorPicker(form: form),
                      ),
                      CardInput(
                        label: 'Icon',
                        child: IconPicker(form: form),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16).copyWith(bottom: 24),
            child: ReactiveFormConsumer(builder: (context, formGroup, _) {
              final form = formGroup as CreatePocketForm;
              final type = form.typeValue;
              return SubmitButton(
                text: 'Next',
                onPressed: () async {
                  form.markAllAsTouched();
                  if (form.invalid) return;
                  PocketCreationType? pocketCreationType;
                  if (type == PocketType.spending) {
                    pocketCreationType =
                        await _toCreateSpendingPocketPage(context);
                  } else if (type == PocketType.saving) {
                    pocketCreationType =
                        await _toCreateSavingPocketPage(context);
                  } else {
                    pocketCreationType =
                        await _toCreateRecurringPocketPage(context);
                  }
                  if (pocketCreationType == null || !context.mounted) return;
                  Navigator.of(context)
                      .pop<PocketCreationType?>(pocketCreationType);
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
