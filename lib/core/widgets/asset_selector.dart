import 'package:dompet_app/core/dependencies/init_dependency.dart';
import 'package:dompet_app/core/extensions/number.dart';
import 'package:dompet_app/core/widgets/widget.dart';
import 'package:dompet_app/features/assets/cubits/asset_cubit.dart';
import 'package:dompet_app/features/assets/forms/asset_selector_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AssetSelector extends StatelessWidget {
  final AssetSelectorForm accountSelectorForm;
  final String label;
  final int? disabledAssetId;

  const AssetSelector({
    super.key,
    required this.accountSelectorForm,
    required this.label,
    this.disabledAssetId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AssetCubit>()..fetch(),
      child: ReactiveFormField<int, int>(
        formControl: accountSelectorForm.idControl,
        validationMessages: {
          ValidationMessage.required: (_) =>
              'Pilih salah satu dompet terlebih dahulu.',
        },
        builder: (field) {
          final themeData = Theme.of(context);

          return Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 8),
              BlocConsumer<AssetCubit, AssetState>(
                listener: (context, state) {
                  state.maybeWhen(
                    orElse: () {},
                    loaded: (assets) {
                      if (assets.length == 1) {
                        accountSelectorForm.idControl.value = assets.first.id;
                        accountSelectorForm.nameControl.value =
                            assets.first.name;
                        accountSelectorForm.balanceControl.value =
                            assets.first.balance;
                      }
                    },
                  );
                },
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => SizedBox.shrink(),
                    loading: () => SizedBox(
                      height: 100,
                      child: Center(child: SpinnerLoading()),
                    ),
                    error: (message) => Text(
                      message,
                      style: TextStyle(color: themeData.colorScheme.error),
                    ),
                    loaded: (assets) {
                      return SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: assets.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 8);
                          },
                          itemBuilder: (context, index) {
                            final asset = assets[index];
                            final isActive = field.value == asset.id;

                            final activeColor = themeData.colorScheme.primary;
                            final isDisabled = disabledAssetId == asset.id;

                            return Container(
                              width: 160,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isActive
                                      ? activeColor
                                      : Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Opacity(
                                opacity: isDisabled ? 0.1 : 1,
                                child: Card(
                                  clipBehavior: .antiAlias,
                                  child: InkWell(
                                    onTap: isDisabled
                                        ? null
                                        : () {
                                            accountSelectorForm
                                                    .idControl
                                                    .value =
                                                asset.id;
                                            accountSelectorForm
                                                    .nameControl
                                                    .value =
                                                asset.name;
                                            accountSelectorForm
                                                    .balanceControl
                                                    .value =
                                                asset.balance;
                                          },
                                    child: Column(
                                      mainAxisSize: .min,
                                      mainAxisAlignment: .center,
                                      children: [
                                        Text(
                                          asset.name,
                                          style: TextStyle(
                                            color: isActive
                                                ? activeColor
                                                : themeData
                                                      .colorScheme
                                                      .onSurface,
                                          ),
                                        ),
                                        Text(
                                          asset.balance.currency,
                                          style: TextStyle(
                                            color: isActive
                                                ? activeColor
                                                : themeData
                                                      .colorScheme
                                                      .onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              if (field.errorText != null) ...[
                SizedBox(height: 4),
                Text(
                  field.errorText!,
                  style: themeData.textTheme.labelMedium?.copyWith(
                    color: themeData.colorScheme.error,
                  ),
                ),
              ],
              if (field.errorText == null) ...[
                SizedBox(height: 4),
                Opacity(
                  opacity: 0,
                  child: Text(
                    'field.errorText!',
                    style: themeData.textTheme.labelMedium?.copyWith(
                      color: themeData.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
