import 'package:isar/isar.dart';

part 'personal_note.g.dart';

@collection
class PersonalNote {
  Id id = Isar.autoIncrement;

  late String category; // "Contraseñas", "Citas", etc.
  late String title;
  late String content;
  bool requiresAuth = false;
  bool isDeleted = false;
}
