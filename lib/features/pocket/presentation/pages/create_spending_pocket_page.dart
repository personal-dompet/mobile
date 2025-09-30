import 'package:dompet/features/pocket/domain/forms/create_spending_pocket_form.dart';
import 'package:dompet/core/utils/helpers/scaffold_snackbar_helper.dart';
import 'package:dompet/core/widgets/masked_amount_input.dart';
import 'package:dompet/core/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateSpendingPocketPage extends ConsumerStatefulWidget {
  const CreateSpendingPocketPage({super.key});

  @override
  ConsumerState<CreateSpendingPocketPage> createState() =>
      _CreateSpendingPocketPageState();
}

class _CreateSpendingPocketPageState
    extends ConsumerState<CreateSpendingPocketPage> {
  late FocusNode _descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final form = ref.read(createSpendingPocketFormProvider);
    if (form.valid) {
      // TODO: Implement the actual creation logic
      // For now, we'll just show a success message and return the form data
      context.showSuccessSnackbar('Spending pocket created successfully!');
      Navigator.of(context).pop<CreateSpendingPocketForm>(form);
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(createSpendingPocketFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Spending Pocket'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name input
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pocket Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ReactiveTextField<String>(
                        formControlName: 'name',
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Enter pocket name',
                          border: OutlineInputBorder(),
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                              'Pocket name is required',
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Description input
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ReactiveTextField<String?>(
                        formControlName: 'description',
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Enter description (optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Initial Balance input
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Initial Balance',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      MaskedAmountInput(
                        formControlName: 'balance',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter initial balance',
                          border: OutlineInputBorder(),
                        ),
                        validationMessages: {
                          ValidationMessage.number: (_) =>
                              'Please enter a valid number',
                          ValidationMessage.min: (_) =>
                              'Balance must be greater than or equal to 0',
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Low Balance Settings
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Low Balance Settings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      MaskedAmountInput(
                        formControlName: 'lowBalanceThreshold',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          hintText: 'Enter threshold amount',
                          border: OutlineInputBorder(),
                        ),
                        validationMessages: {
                          ValidationMessage.number: (_) =>
                              'Please enter a valid number',
                          ValidationMessage.min: (_) =>
                              'Threshold must be greater than or equal to 0',
                        },
                      ),
                      const SizedBox(height: 16),
                      ReactiveSwitchListTile(
                        formControlName: 'lowBalanceReminder',
                        title: const Text('Enable Low Balance Reminder'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit button
              SubmitButton(
                text: 'Create Pocket',
                onPressed: () => _submit(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
