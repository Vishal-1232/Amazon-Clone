// earnings_model.dart

class Earnings {
  final double totalEarnings;
  final double mobileEarnings;
  final double essentialEarnings;
  final double applianceEarnings;
  final double booksEarnings;
  final double fashionEarnings;
  final double electronicsEarnings;

  Earnings({
    required this.totalEarnings,
    required this.mobileEarnings,
    required this.essentialEarnings,
    required this.applianceEarnings,
    required this.booksEarnings,
    required this.fashionEarnings,
    required this.electronicsEarnings
  });

  factory Earnings.fromJson(Map<String, dynamic> json) {
    return Earnings(
      totalEarnings: json['totalEarnings'].toDouble(),
      mobileEarnings: json['mobileEarnings'].toDouble(),
      essentialEarnings: json['essentialEarnings'].toDouble(),
      applianceEarnings: json['applianceEarnings'].toDouble(),
      booksEarnings: json['booksEarnings'].toDouble(),
      fashionEarnings: json['fashionEarnings'].toDouble(),
      electronicsEarnings: json['electronicsEarnings'].toDouble(),
    );
  }
}
