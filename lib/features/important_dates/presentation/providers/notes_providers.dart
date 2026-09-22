import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../../data/repository/notes_repository.dart';
import '../../domain/love_note.dart';
import '../../domain/personal_note.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepository(isar);
});

final loveNotesProvider = FutureProvider<List<LoveNote>>((ref) async {
  final repo = ref.watch(notesRepositoryProvider);
  return await repo.getLoveNotes();
});

final personalNotesProvider = FutureProvider<List<PersonalNote>>((ref) async {
  final repo = ref.watch(notesRepositoryProvider);
  return await repo.getPersonalNotes();
});
