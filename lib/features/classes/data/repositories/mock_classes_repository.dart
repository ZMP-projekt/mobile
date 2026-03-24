import '../models/gym_class.dart';
import '../models/trainer.dart';

class MockClassesRepository {
  final Set<int> _bookedClassIds = {1, 4, 9};

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<List<GymClass>> getAllClasses() async {
    await _simulateNetworkDelay();
    return _generateMockClasses();
  }

  Future<List<GymClass>> getMyClasses() async {
    await _simulateNetworkDelay();
    final allClasses = _generateMockClasses();
    return allClasses.where((c) => c.isBookedByUser).toList();
  }

  Future<GymClass> bookClass(int classId) async {
    await _simulateNetworkDelay();
    _bookedClassIds.add(classId);
    final allClasses = _generateMockClasses();
    return allClasses.firstWhere((c) => c.id == classId);
  }

  Future<GymClass> cancelBooking(int classId) async {
    await _simulateNetworkDelay();
    _bookedClassIds.remove(classId);
    final allClasses = _generateMockClasses();
    return allClasses.firstWhere((c) => c.id == classId);
  }

  List<GymClass> _generateMockClasses() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      GymClass(
        id: 1,
        name: 'Yoga Relax',
        startTime: today.add(const Duration(hours: 18)),
        endTime: today.add(const Duration(hours: 19)),
        trainer: Trainer(firstName: 'Anna', lastName: 'Kowalska'),
        maxParticipants: 15,
        currentParticipants: _bookedClassIds.contains(1) ? 9 : 8,
        isBookedByUser: _bookedClassIds.contains(1),
        description: 'Relaksacyjna sesja jogi dla początkujących',
      ),
      GymClass(
        id: 2,
        name: 'CrossFit HIIT',
        startTime: today.add(const Duration(hours: 19, minutes: 30)),
        endTime: today.add(const Duration(hours: 20, minutes: 30)),
        trainer: Trainer(firstName: 'Michał', lastName: 'Nowak'),
        maxParticipants: 12,
        currentParticipants: _bookedClassIds.contains(2) ? 11 : 10,
        isBookedByUser: _bookedClassIds.contains(2),
        description: 'Intensywny trening interwałowy wysokiej intensywności',
      ),
      GymClass(
        id: 3,
        name: 'Pilates',
        startTime: today.add(const Duration(hours: 17)),
        endTime: today.add(const Duration(hours: 18)),
        trainer: Trainer(firstName: 'Karolina', lastName: 'Wiśniewska'),
        maxParticipants: 10,
        currentParticipants: _bookedClassIds.contains(3) ? 8 : 7,
        isBookedByUser: _bookedClassIds.contains(3),
        description: 'Pilates na wzmocnienie mięśni głębokich',
      ),
      GymClass(
        id: 4,
        name: 'Spinning',
        startTime: today.add(const Duration(days: 1, hours: 18)),
        endTime: today.add(const Duration(days: 1, hours: 19)),
        trainer: Trainer(firstName: 'Piotr', lastName: 'Kowalczyk'),
        maxParticipants: 20,
        currentParticipants: _bookedClassIds.contains(4) ? 16 : 15,
        isBookedByUser: _bookedClassIds.contains(4),
        description: 'Energetyczny trening na rowerach stacjonarnych',
      ),
      GymClass(
        id: 5,
        name: 'Zumba',
        startTime: today.add(const Duration(days: 1, hours: 19, minutes: 30)),
        endTime: today.add(const Duration(days: 1, hours: 20, minutes: 30)),
        trainer: Trainer(firstName: 'Maria', lastName: 'Lopez'),
        maxParticipants: 25,
        currentParticipants: _bookedClassIds.contains(5) ? 19 : 18,
        isBookedByUser: _bookedClassIds.contains(5),
        description: 'Taneczny fitness w rytmie latino',
      ),
      GymClass(
        id: 6,
        name: 'Body Pump',
        startTime: today.add(const Duration(days: 2, hours: 18)),
        endTime: today.add(const Duration(days: 2, hours: 19)),
        trainer: Trainer(firstName: 'Michał', lastName: 'Nowak'),
        maxParticipants: 15,
        currentParticipants: _bookedClassIds.contains(6) ? 13 : 12,
        isBookedByUser: _bookedClassIds.contains(6),
        description: 'Trening siłowy z ciężarkami do muzyki',
      ),
      GymClass(
        id: 7,
        name: 'Stretching',
        startTime: today.add(const Duration(days: 2, hours: 20)),
        endTime: today.add(const Duration(days: 2, hours: 21)),
        trainer: Trainer(firstName: 'Anna', lastName: 'Kowalska'),
        maxParticipants: 12,
        currentParticipants: _bookedClassIds.contains(7) ? 6 : 5,
        isBookedByUser: _bookedClassIds.contains(7),
        description: 'Rozciąganie i elastyczność całego ciała',
      ),
      GymClass(
        id: 8,
        name: 'Boxing',
        startTime: today.add(const Duration(days: 3, hours: 18, minutes: 30)),
        endTime: today.add(const Duration(days: 3, hours: 19, minutes: 30)),
        trainer: Trainer(firstName: 'Jan', lastName: 'Lewandowski'),
        maxParticipants: 10,
        currentParticipants: 10,
        isBookedByUser: false,
        description: 'Trening bokserski dla wszystkich poziomów',
      ),
      GymClass(
        id: 9,
        name: 'Yoga Power',
        startTime: today.add(const Duration(days: 3, hours: 17)),
        endTime: today.add(const Duration(days: 3, hours: 18)),
        trainer: Trainer(firstName: 'Anna', lastName: 'Kowalska'),
        maxParticipants: 15,
        currentParticipants: _bookedClassIds.contains(9) ? 10 : 9,
        isBookedByUser: _bookedClassIds.contains(9),
        description: 'Dynamiczna joga budująca siłę',
      ),
      GymClass(
        id: 10,
        name: 'TRX',
        startTime: today.add(const Duration(days: 4, hours: 19)),
        endTime: today.add(const Duration(days: 4, hours: 20)),
        trainer: Trainer(firstName: 'Michał', lastName: 'Nowak'),
        maxParticipants: 8,
        currentParticipants: _bookedClassIds.contains(10) ? 7 : 6,
        isBookedByUser: _bookedClassIds.contains(10),
        description: 'Trening z pasami TRX - cały korpus',
      ),
    ];
  }
}