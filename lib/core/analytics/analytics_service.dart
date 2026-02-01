import 'package:hive/hive.dart';

class AnalyticsService {
  final Box box = Hive.box('analytics');

  void logPlay({
    required String songId,
    required int positionSeconds,
  }) {
    box.add({
      'songId': songId,
      'timestamp': DateTime.now().toIso8601String(),
      'position': positionSeconds,
    });
  }

  List<Map> getAllEvents() {
    return box.values.cast<Map>().toList();
  }
}