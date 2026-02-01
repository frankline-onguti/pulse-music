import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'library_repository.dart';

final libraryProvider = FutureProvider((ref) async {
  return LibraryRepository.fetchSongs();
});