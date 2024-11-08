import 'dart:convert';

class CouponModel {
  final String couponCode;
  final String description;
  final String discountType;
  final double discountValue;
  final double minimumPurchaseRequirement;
  final double? maximumDiscountLimit;
  final DateTime startDate;
  final DateTime endDate;
  final int perUserLimit;
  final List<UsageLimitPerUser> usageLimitPerUser;
  final int? totalUsageLimit;
  final List<String>? eligibleProducts;
  final List<String>? excludedProducts;
  final List<String>? eligibleCategories;
  final List<String>? excludedCategories;
  final String userRestrictions;
  final String usageStatus;
  final bool autoApply;
  final String? id;

  CouponModel({
    required this.couponCode,
    required this.description,
    required this.discountType,
    required this.discountValue,
    this.minimumPurchaseRequirement = 0,
    this.maximumDiscountLimit,
    required this.startDate,
    required this.endDate,
    this.perUserLimit = 1,
    this.usageLimitPerUser = const [],
    this.totalUsageLimit,
    this.eligibleProducts,
    this.excludedProducts,
    this.eligibleCategories,
    this.excludedCategories,
    this.userRestrictions = "all",
    this.usageStatus = "active",
    this.autoApply = false,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'couponCode': couponCode,
      'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      'minimumPurchaseRequirement': minimumPurchaseRequirement,
      'maximumDiscountLimit': maximumDiscountLimit,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'perUserLimit': perUserLimit,
      'usageLimitPerUser': usageLimitPerUser.map((x) => x.toMap()).toList(),
      'totalUsageLimit': totalUsageLimit,
      'eligibleProducts': eligibleProducts,
      'excludedProducts': excludedProducts,
      'eligibleCategories': eligibleCategories,
      'excludedCategories': excludedCategories,
      'userRestrictions': userRestrictions,
      'usageStatus': usageStatus,
      'autoApply': autoApply,
      '_id': id,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      couponCode: map['couponCode'] ?? '',
      description: map['description'] ?? '',
      discountType: map['discountType'] ?? 'percentage',
      discountValue: (map['discountValue'] ?? 0).toDouble(),
      minimumPurchaseRequirement: (map['minimumPurchaseRequirement'] ?? 0).toDouble(),
      maximumDiscountLimit: map['maximumDiscountLimit'] != null ? (map['maximumDiscountLimit']).toDouble() : null,
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      perUserLimit: map['perUserLimit'] ?? 1,
      usageLimitPerUser: (map['usageLimitPerUser'] as List<dynamic>?)
          ?.map((x) => UsageLimitPerUser.fromMap(x))
          .toList() ??
          [],
      totalUsageLimit: map['totalUsageLimit'],
      eligibleProducts: List<String>.from(map['eligibleProducts'] ?? const []),
      excludedProducts: List<String>.from(map['excludedProducts'] ?? const []),
      eligibleCategories: List<String>.from(map['eligibleCategories'] ?? const []),
      excludedCategories: List<String>.from(map['excludedCategories'] ?? const []),
      userRestrictions: map['userRestrictions'] ?? 'all',
      usageStatus: map['usageStatus'] ?? 'active',
      autoApply: map['autoApply'] ?? false,
      id: map['_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CouponModel.fromJson(String source) =>
      CouponModel.fromMap(json.decode(source));
}

class UsageLimitPerUser {
  final String userId;
  final int limitUsed;

  UsageLimitPerUser({
    required this.userId,
    this.limitUsed = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'limitUsed': limitUsed,
    };
  }

  factory UsageLimitPerUser.fromMap(Map<String, dynamic> map) {
    return UsageLimitPerUser(
      userId: map['userId'] ?? '',
      limitUsed: map['limitUsed'] ?? 1,
    );
  }
}
