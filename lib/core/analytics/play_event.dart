class PlayEvent {
  final String songId;
  final DateTime timestamp;
  final int positionSeconds;

  PlayEvent({
    required this.songId,
    required this.timestamp,
    required this.positionSeconds,
  });
}