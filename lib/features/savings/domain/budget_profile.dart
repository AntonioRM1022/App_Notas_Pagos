import 'package:isar/isar.dart';

part 'budget_profile.g.dart';

@collection
class BudgetProfile {
  Id id = 1; // Registro único de configuración quincenal

  double biweeklyIncome = 0.0; // Sueldo o ingresos promedio por quincena
  double fixedExpenses = 0.0; // Gastos fijos (renta, servicios, comida esencial)
  double targetSavingsPerQuincena = 1000.0; // Cuota obligatoria intocable de ahorro
  DateTime? lastUpdated;
}
