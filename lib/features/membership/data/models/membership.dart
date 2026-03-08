class Membership {
  final int id;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final int? daysRemainingFromApi;

  Membership({
    required this.id,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.type,
    this.daysRemainingFromApi,
  });

  int get daysRemaining {
    if (daysRemainingFromApi != null) {
      return daysRemainingFromApi!;
    }

    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays;
  }

  bool get isActive {
    return status == 'ACTIVE' && DateTime.now().isBefore(endDate);
  }

  double get usagePercentage {
    final totalDays = endDate.difference(startDate).inDays;
    final usedDays = DateTime.now().difference(startDate).inDays;
    if (totalDays == 0) return 0;
    return (usedDays / totalDays).clamp(0.0, 1.0);
  }

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      id: json['id'],
      status: json['status'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      type: json['type'],
      daysRemainingFromApi: json['daysRemaining'],
    );
  }

  @override
  String toString() {
    return 'Membership(id: $id, status: $status, type: $type, daysRemaining: $daysRemaining)';
  }
}