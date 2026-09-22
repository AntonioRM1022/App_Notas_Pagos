import 'package:isar/isar.dart';

part 'love_note.g.dart';

@collection
class LoveNote {
  Id id = Isar.autoIncrement;

  late String title;
  late DateTime date;
  late String concept;
  bool isDeleted = false;
}
