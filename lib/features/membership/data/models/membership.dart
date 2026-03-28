class Membership {
  final bool active;
  final DateTime endDate;
  final double price;
  final String type;

  Membership({
    required this.active,
    required this.endDate,
    required this.price,
    required this.type,
  });

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      active: json['active'] ?? false,
      endDate: DateTime.parse(json['endDate']),
      price: (json['price'] as num).toDouble(),
      type: json['type'] ?? 'UNKNOWN',
    );
  }

  int get daysRemaining {
    final remaining = endDate.difference(DateTime.now()).inDays;
    return remaining > 0 ? remaining : 0;
  }

  double get progressValue {
    if (daysRemaining >= 30) return 1.0;
    if (daysRemaining <= 0) return 0.0;
    return daysRemaining / 30.0;
  }
}