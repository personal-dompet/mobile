import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/widgets/dompet_text_field.dart';
import 'package:dompet_app/core/widgets/spinner_loading.dart';
import 'package:dompet_app/features/savings/cubits/saving_cubit.dart';
import 'package:dompet_app/features/savings/cubits/saving_signal_cubit.dart';
import 'package:dompet_app/features/savings/widgets/saving_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class SavingPage extends StatefulWidget {
  const SavingPage({super.key});

  @override
  State<SavingPage> createState() => _SavingPageState();
}

class _SavingPageState extends State<SavingPage> {
  final _keywordControl = FormControl<String>();

  Timer? _debounce;

  final _savingCubit = getIt<SavingCubit>();

  @override
  void initState() {
    super.initState();
    _keywordControl.valueChanges.listen((keyword) {
      _debounce?.cancel();
      _debounce = Timer(Duration(milliseconds: 300), () {
        _savingCubit.fetch(keyword: keyword);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _savingCubit.close();
    _keywordControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavingSignalCubit, int>(
      listener: (context, state) {
        _savingCubit.refresh();
      },
      child: BlocProvider.value(
        value: _savingCubit..fetch(keyword: _keywordControl.value),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ).copyWith(bottom: 28),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                DompetTextField(
                  placeholder: 'Cari nama target...',
                  formControl: _keywordControl,
                  textInputAction: .search,
                  clearable: true,
                ),
                Expanded(
                  child: BlocBuilder<SavingCubit, SavingState>(
                    bloc: _savingCubit,
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () => SizedBox.shrink(),
                        error: (message) => Center(
                          child: Text(
                            message,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                            textAlign: .center,
                          ),
                        ),
                        loading: () {
                          return Padding(
                            padding: const EdgeInsets.only(top: 64),
                            child: SpinnerLoading(),
                          );
                        },
                        loaded: (plans) {
                          return SavingList(plans: plans);
                        },
                        refreshing: (plans) {
                          return SavingList(plans: plans);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
