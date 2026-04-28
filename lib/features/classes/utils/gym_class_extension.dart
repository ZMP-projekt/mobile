import '../data/models/gym_class.dart';

extension GymClassImageExt on GymClass {
  String get displayImageUrl {
    if (imageUrl != null && imageUrl!.isNotEmpty) return imageUrl!;

    final nameLower = name.toLowerCase();

    if (nameLower.contains('yoga') || nameLower.contains('joga')) return 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=1200&q=90';
    if (nameLower.contains('crossfit') || nameLower.contains('hiit')) return 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=1200&q=90';
    if (nameLower.contains('pilates') || nameLower.contains('stretch')) return 'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=1200&q=90';
    if (nameLower.contains('spinning')) return 'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=1200&q=90';
    if (nameLower.contains('zumba')) return 'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?auto=format&fit=crop&w=1200&q=90';
    if (nameLower.contains('boxing')) return 'https://images.unsplash.com/photo-1549719386-74dfcbf7dbed?auto=format&fit=crop&w=1200&q=90';
    if (nameLower.contains('trx')) return 'https://images.unsplash.com/photo-1526506114842-8395dc559384?auto=format&fit=crop&w=1200&q=90';

    return 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=1200&q=90';
  }
}
