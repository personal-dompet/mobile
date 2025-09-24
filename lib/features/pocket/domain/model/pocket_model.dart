class PocketModel {
  final String id;
  final String name;
  final String type;
  final double balance;
  final double targetAmount;
  final String icon;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  PocketModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.targetAmount,
    required this.icon,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  // Calculate progress percentage for saving pockets
  double get progressPercentage {
    if (targetAmount <= 0) return 0.0;
    return (balance / targetAmount) * 100;
  }

  // Factory constructor to create a PocketModel from JSON
  factory PocketModel.fromJson(Map<String, dynamic> json) {
    return PocketModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      balance: (json['balance'] as num).toDouble(),
      targetAmount: (json['target_amount'] as num?)?.toDouble() ?? 0.0,
      icon: json['icon'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Convert PocketModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'balance': balance,
      'target_amount': targetAmount,
      'icon': icon,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Copy with method for updating properties
  PocketModel copyWith({
    String? id,
    String? name,
    String? type,
    double? balance,
    double? targetAmount,
    String? icon,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PocketModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      targetAmount: targetAmount ?? this.targetAmount,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}