import 'package:dompet/core/utils/helpers/debounce_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ItemListSearchField extends ConsumerStatefulWidget {
  final FormGroup form;
  final FormControl formControl;
  final VoidCallback onSearch;

  const ItemListSearchField({
    super.key,
    required this.form,
    required this.formControl,
    required this.onSearch,
  });

  @override
  ConsumerState<ItemListSearchField> createState() => _ItemListSearchFieldState();
}

class _ItemListSearchFieldState extends ConsumerState<ItemListSearchField> {
  final Debounce _debounceHelper = Debounce();

  @override
  void dispose() {
    _debounceHelper.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: widget.form,
      child: ReactiveTextField(
        formControl: widget.formControl,
        onChanged: (control) {
          _debounceHelper.debounce(() {
            widget.onSearch();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search_rounded),
          suffixIcon: ReactiveValueListenableBuilder(
            formControl: widget.formControl,
            builder: (context, control, child) {
              return control.value == null || control.value.toString().isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        control.value = null;
                        control.markAsDirty();
                        widget.onSearch();
                      },
                    );
            },
          ),
        ),
      ),
    );
  }
}