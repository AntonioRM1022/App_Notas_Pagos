import 'package:isar/isar.dart';

part 'profile_event.g.dart';

@collection
class ProfileEvent {
  Id id = Isar.autoIncrement;

  late String profileName; // Ej: "Martha"
  
  late String eventType; // Cumpleaños, Aniversario, etc.
  
  late DateTime eventDate; // Fecha del evento
  
  bool isRecurring = true; // Anual por defecto

  // Relación con notas rápidas
  final quickNotes = IsarLinks<QuickNote>();
}

@collection
class QuickNote {
  Id id = Isar.autoIncrement;

  late String content; // Ej: "Talla de zapatos: 4"
  
  late DateTime createdAt;

  @Backlink(to: 'quickNotes')
  final event = IsarLink<ProfileEvent>();
}
