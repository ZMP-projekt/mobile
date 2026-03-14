class GymClass {
  final int id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String trainerId;
  final String trainerName;
  final int maxParticipants;
  final int currentParticipants;
  final bool isBookedByUser;
  final String? description;
  final String? imageUrl;

  GymClass({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.trainerId,
    required this.trainerName,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.isBookedByUser,
    this.description,
    this.imageUrl,
  });

  int get durationMinutes {
    return endTime.difference(startTime).inMinutes;
  }

  bool get isFull {
    return currentParticipants >= maxParticipants;
  }

  int get spotsLeft {
    return maxParticipants - currentParticipants;
  }

  bool get isPast {
    return DateTime.now().isAfter(endTime);
  }

  bool get isOngoing {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  bool get isFuture {
    return DateTime.now().isBefore(startTime);
  }

  String get startTimeFormatted {
    return '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
  }

  String get dateFormatted {
    final months = ['Sty', 'Lut', 'Mar', 'Kwi', 'Maj', 'Cze', 'Lip', 'Sie', 'Wrz', 'Paź', 'Lis', 'Gru'];
    return '${startTime.day} ${months[startTime.month - 1]}';
  }

  String get dayOfWeek {
    final days = ['Poniedziałek', 'Wtorek', 'Środa', 'Czwartek', 'Piątek', 'Sobota', 'Niedziela'];
    return days[startTime.weekday - 1];
  }

  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
        startTime.month == now.month &&
        startTime.day == now.day;
  }

  factory GymClass.fromJson(Map<String, dynamic> json) {
    return GymClass(
      id: json['id'],
      name: json['name'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      trainerId: json['trainerId'].toString(),
      trainerName: json['trainerName'],
      maxParticipants: json['maxParticipants'],
      currentParticipants: json['currentParticipants'],
      isBookedByUser: json['isBookedByUser'] ?? false,
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  GymClass copyWith({
    int? id,
    String? name,
    DateTime? startTime,
    DateTime? endTime,
    String? trainerId,
    String? trainerName,
    int? maxParticipants,
    int? currentParticipants,
    bool? isBookedByUser,
    String? description,
    String? imageUrl,
  }) {
    return GymClass(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      trainerId: trainerId ?? this.trainerId,
      trainerName: trainerName ?? this.trainerName,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      isBookedByUser: isBookedByUser ?? this.isBookedByUser,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'GymClass(id: $id, name: $name, startTime: $startTimeFormatted, spots: $spotsLeft/$maxParticipants, booked: $isBookedByUser)';
  }
}