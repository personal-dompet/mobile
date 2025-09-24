import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dompet/core/widgets/masked_amount_input.dart';
import 'package:dompet/core/widgets/submit_button.dart';

class AmountInputExample extends StatefulWidget {
  const AmountInputExample({super.key});

  @override
  _AmountInputExampleState createState() => _AmountInputExampleState();
}

class _AmountInputExampleState extends State<AmountInputExample> {
  final FormGroup _form = FormGroup({
    'amount': FormControl<int>(value: 0),
    'description': FormControl<String>(validators: [Validators.required]),
  });

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masked Amount Input Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: _form,
          child: Column(
            children: [
              MaskedAmountInput(
                formControlName: 'amount',
                labelText: 'Amount',
                hintText: 'Enter amount',
                helperText: 'Enter amount in IDR',
                keyboardType: TextInputType.number,
                validationMessages: {
                  'required': (error) => 'Amount is required',
                },
              ),
              const SizedBox(height: 20),
              ReactiveTextField(
                formControlName: 'description',
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter transaction description',
                ),
                validationMessages: {
                  'required': (error) => 'Description is required',
                },
              ),
              const SizedBox(height: 20),
              SubmitButton(
                text: 'Submit',
                onPressed: () {
                  if (_form.valid) {
                    // Print the form values
                    debugPrint('Form values: ${_form.value}');

                    // Access the amount value as an integer
                    final amountControl = _form.control('amount');
                    if (amountControl.value != null) {
                      debugPrint('Amount (int): ${amountControl.value}');
                    }
                  } else {
                    _form.markAllAsTouched();
                  }
                },
              ),
              const SizedBox(height: 20),
              ReactiveFormConsumer(
                builder: (context, form, child) {
                  return Text(
                    'Current amount value: ${form.control('amount').value ?? 0}',
                    style: const TextStyle(fontSize: 16),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
