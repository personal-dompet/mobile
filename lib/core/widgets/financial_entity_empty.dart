import 'package:dompet/core/enum/list_type.dart';
import 'package:dompet/core/models/entity_base_type.dart';
import 'package:dompet/core/models/financial_entity_filter.dart';
import 'package:dompet/features/account/domain/enum/account_type.dart';
import 'package:dompet/features/pocket/domain/enum/pocket_type.dart';
import 'package:dompet/theme_data.dart';
import 'package:flutter/material.dart';

class FinancialEntityEmpty<T extends EntityBaseType> extends StatelessWidget {
  final ListType listType;
  final VoidCallback onCreate;
  final bool hideButton;
  final FinancialEntityFilter<T> filter;

  const FinancialEntityEmpty({
    super.key,
    required this.onCreate,
    required this.filter,
    this.listType = ListType.filtered,
    this.hideButton = false,
  });

  bool get _isPocket => filter.type is PocketType;

  String get _entityType => _isPocket ? 'pocket' : 'account';

  String get _capitalizeEntityType {
    final chars = _entityType.toLowerCase().split('');
    chars[0] = chars[0].toUpperCase();
    return chars.join();
  }

  String? get _keyword => filter.keyword;

  EntityBaseType get _type {
    if (listType == ListType.option && filter.type is PocketType) {
      return PocketType.all;
    }

    if (listType == ListType.option && filter.type is AccountType) {
      return AccountType.all;
    }

    return filter.type;
  }

  String get _displayMessage {
    final isAll = _type == PocketType.all || _type == AccountType.all;
    final isSearched = _keyword != null && _keyword!.isNotEmpty;
    final isAllFilterActive = isSearched && !isAll;
    final isFilterActive = isSearched || !isAll;

    if (isAllFilterActive) {
      return 'Couldn\'t find any ${_type.displayName.toLowerCase()} ${_entityType}s matching "$_keyword". Try a different search term or filter. Or would you like to create a new $_entityType?';
    }

    if (isSearched && isAll) {
      return 'Couldn\'t find any ${_entityType}s matching "$_keyword". Try a different search term. Or would you like to create a new $_entityType?';
    }

    if (!isSearched && !isAll) {
      return 'You don\'t have any ${_type.displayName.toLowerCase()} ${_entityType}s yet. Would you like to create one?';
    }

    if (!isFilterActive && !hideButton) {
      return 'Start organizing your finances by creating your first $_entityType.';
    }

    return 'Create your first $_entityType in the $_capitalizeEntityType menu to start managing your finances.';
  }

  String get _displayTitle {
    final isAll = _type == PocketType.all || _type == AccountType.all;
    final isSearched = _keyword != null && _keyword!.isNotEmpty;
    final isFilterActive = isSearched || !isAll;

    if (isFilterActive) return 'No matching $_entityType';
    return 'No ${_entityType}s yet';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _type.icon,
            size: 64,
            color: AppTheme.textColorPrimary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _displayTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _displayMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textColorPrimary,
            ),
          ),
          const SizedBox(height: 24),
          if (!hideButton)
            ElevatedButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded),
              label: Text('Create ${_entityType}s'),
            ),
        ],
      ),
    );
  }
}
