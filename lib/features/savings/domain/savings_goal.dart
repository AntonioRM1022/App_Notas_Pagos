import 'package:isar/isar.dart';
import 'savings_contribution.dart';

part 'savings_goal.g.dart';

@collection
class SavingsGoal {
  Id id = Isar.autoIncrement;

  late String title; // Ej: "Italika 280Z", "Casco y equipo"
  late double targetAmount; // Monto meta en MXN
  late double currentSaved; // Total ahorrado acumulado
  late DateTime createdAt;
  DateTime? targetDate; // Fecha estimada objetivo
  String iconName = 'two_wheeler'; // 'two_wheeler', 'savings', 'laptop', 'shield', 'flight'
  String colorHex = '00E676'; // Verde neón por defecto
  
  bool isCompleted = false;
  bool isDeleted = false;

  final contributions = IsarLinks<SavingsContribution>();
}
