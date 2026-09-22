import 'package:isar/isar.dart';
import '../../domain/love_note.dart';
import '../../domain/personal_note.dart';

class NotesRepository {
  final Isar isar;

  NotesRepository(this.isar);

  // === Love Notes ===
  Future<List<LoveNote>> getLoveNotes() async {
    final allNotes = await isar.loveNotes.where().findAll();
    return allNotes.where((note) => !note.isDeleted).toList();
  }

  Future<void> addLoveNote(LoveNote note) async {
    await isar.writeTxn(() async {
      await isar.loveNotes.put(note);
    });
  }

  // === Personal Notes ===
  Future<List<PersonalNote>> getPersonalNotes() async {
    final allNotes = await isar.personalNotes.where().findAll();
    return allNotes.where((note) => !note.isDeleted).toList();
  }

  Future<void> addPersonalNote(PersonalNote note) async {
    await isar.writeTxn(() async {
      await isar.personalNotes.put(note);
    });
  }

  Future<void> softDeleteLoveNote(int id) async {
    final note = await isar.loveNotes.get(id);
    if (note != null) {
      await isar.writeTxn(() async {
        note.isDeleted = true;
        await isar.loveNotes.put(note);
      });
    }
  }

  Future<List<LoveNote>> getDeletedLoveNotes() async {
    return await isar.loveNotes.where().filter().isDeletedEqualTo(true).findAll();
  }

  Future<void> restoreLoveNote(int id) async {
    final note = await isar.loveNotes.get(id);
    if (note != null) {
      await isar.writeTxn(() async {
        note.isDeleted = false;
        await isar.loveNotes.put(note);
      });
    }
  }

  Future<void> softDeletePersonalNote(int id) async {
    final note = await isar.personalNotes.get(id);
    if (note != null) {
      await isar.writeTxn(() async {
        note.isDeleted = true;
        await isar.personalNotes.put(note);
      });
    }
  }

  Future<List<PersonalNote>> getDeletedPersonalNotes() async {
    return await isar.personalNotes.where().filter().isDeletedEqualTo(true).findAll();
  }

  Future<void> restorePersonalNote(int id) async {
    final note = await isar.personalNotes.get(id);
    if (note != null) {
      await isar.writeTxn(() async {
        note.isDeleted = false;
        await isar.personalNotes.put(note);
      });
    }
  }
}
