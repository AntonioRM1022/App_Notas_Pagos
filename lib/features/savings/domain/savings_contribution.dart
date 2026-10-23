import 'package:isar/isar.dart';
import 'savings_goal.dart';

part 'savings_contribution.g.dart';

@collection
class SavingsContribution {
  Id id = Isar.autoIncrement;

  late double amount;
  late DateTime date;
  String? note; // Ej: "Aporte de quincena", "Sobrante de la semana"

  @Backlink(to: 'contributions')
  final goal = IsarLink<SavingsGoal>();
}
