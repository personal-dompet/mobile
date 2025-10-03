import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/enum/category.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:dompet/features/pocket/presentation/widgets/color_picker.dart';
import 'package:dompet/features/pocket/presentation/widgets/icon_picker.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_icon.dart';
import 'package:dompet/features/pocket/presentation/widgets/pocket_type_selector_bottom_sheet.dart';
import 'package:dompet/core/widgets/card_input.dart';
import 'package:dompet/core/widgets/submit_button.dart';
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

    final iconControl = pocketCreateForm.iconControl;
    final colorControl = pocketCreateForm.colorControl;

    final type = pocketCreateForm.typeControl.value;

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
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Pocket'),
          actions: [
            if (type != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _getPocketTypeColor(context, type)
                        .withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      type.icon,
                      color: _getPocketTypeColor(context, type),
                    ),
                    onPressed: () async {
                      final result = await showModalBottomSheet<PocketType>(
                        context: context,
                        isScrollControlled: true,
                        useRootNavigator: true,
                        builder: (context) => const PocketTypeSelectorBottomSheet(),
                      );
                      if (result != null && context.mounted) {
                        final typeControl = pocketCreateForm.typeControl;
                        typeControl.value = result;
                      }
                    },
                  ),
                ),
              ),
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
                    CardInput(
                      label: 'Name',
                      child: ReactiveTextField<String>(
                        formControl: form.nameControl,
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
                    const SizedBox(height: 16),
                    CardInput(
                      label: 'Icon',
                      child: IconPicker(form: form),
                    ),
                    const SizedBox(height: 24),
                    SubmitButton(
                      text: 'Create Pocket',
                      onPressed: () {
                        // TODO: Implement form submission
                        // For now, just pop back with the form data
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
    );
  }
}
