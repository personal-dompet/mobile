import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/enum/category.dart';
import 'package:dompet/core/widgets/card_input.dart';
import 'package:dompet/core/widgets/submit_button.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/presentation/widgets/color_picker.dart';
import 'package:dompet/features/pocket/presentation/widgets/icon_picker.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_icon.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_type_selector_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreatePocketPage extends ConsumerWidget {
  const CreatePocketPage({super.key});

  // Get color based on pocket type
  Color _getPocketTypeColor(BuildContext context, PocketType type) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case PocketType.spending:
        return Colors.redAccent; // Red for spending
      case PocketType.saving:
        return Colors.greenAccent; // Green for saving
      case PocketType.recurring:
        return Colors.blueAccent; // Blue for recurring
      default:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pocketCreateForm = ref.watch(pocketCreateFormProvider);

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
        ref.invalidate(pocketCreateFormProvider);
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
                    final form = formGroup as PocketCreateForm;
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
                  final form = formGroup as PocketCreateForm;
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
                      const SizedBox(height: 24),
                      SubmitButton(
                        text: 'Create Pocket',
                        onPressed: () {
                          Navigator.of(context).pop(pocketCreateForm);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
