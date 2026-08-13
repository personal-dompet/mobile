import 'package:freezed_annotation/freezed_annotation.dart';

enum JournalSource {
  @JsonValue('setup')
  setup('setup'),
  @JsonValue('transfer')
  transfer('transfer'),
  @JsonValue('transaction')
  transaction('transaction'),
  @JsonValue('bill_generated')
  billGenerated('bill_generated'),
  @JsonValue('bill_payment')
  billPayment('bill_payment'),
  @JsonValue('adjustment')
  adjustment('adjustment');

  final String value;

  const JournalSource(this.value);

  static List<String> get allValues {
    return JournalSource.values.map((policy) => policy.value).toList();
  }
}
