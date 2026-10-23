import 'package:isar/isar.dart';
import '../../domain/savings_goal.dart';
import '../../domain/savings_contribution.dart';
import '../../domain/budget_profile.dart';

class SavingsRepository {
  final Isar isar;

  SavingsRepository(this.isar);

  // Obtener metas activas
  Future<List<SavingsGoal>> getGoals() async {
    final allGoals = await isar.savingsGoals.where().findAll();
    var active = allGoals.where((g) => !g.isDeleted).toList();

    // Si es la primera vez que entra y no tiene ninguna meta, crear la meta estrella de la Italika 280Z
    if (active.isEmpty && allGoals.isEmpty) {
      final defaultGoal = SavingsGoal()
        ..title = 'Italika 280Z'
        ..targetAmount = 48000.0
        ..currentSaved = 0.0
        ..createdAt = DateTime.now()
        ..iconName = 'two_wheeler'
        ..colorHex = '00E676';

      await isar.writeTxn(() async {
        await isar.savingsGoals.put(defaultGoal);
      });
      active = [defaultGoal];
    }

    // Cargar aportaciones de cada meta
    for (var goal in active) {
      await goal.contributions.load();
    }

    // Ordenar: primero no completadas, más recientes
    active.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    return active;
  }

  // Agregar nueva meta
  Future<void> addGoal(SavingsGoal goal) async {
    await isar.writeTxn(() async {
      await isar.savingsGoals.put(goal);
    });
  }

  // Actualizar meta existente
  Future<void> updateGoal(SavingsGoal goal) async {
    await isar.writeTxn(() async {
      await isar.savingsGoals.put(goal);
    });
  }

  // Registrar aportación a una meta
  Future<void> addContribution(int goalId, double amount, {String? note}) async {
    final goal = await isar.savingsGoals.get(goalId);
    if (goal == null) return;

    await isar.writeTxn(() async {
      final contribution = SavingsContribution()
        ..amount = amount
        ..date = DateTime.now()
        ..note = note ?? 'Aportación a meta';

      await isar.savingsContributions.put(contribution);
      goal.contributions.add(contribution);
      await goal.contributions.save();

      goal.currentSaved += amount;
      if (goal.currentSaved >= goal.targetAmount) {
        goal.isCompleted = true;
      }
      await isar.savingsGoals.put(goal);
    });
  }

  // Enviar meta a la papelera
  Future<void> softDeleteGoal(int goalId) async {
    final goal = await isar.savingsGoals.get(goalId);
    if (goal != null) {
      await isar.writeTxn(() async {
        goal.isDeleted = true;
        await isar.savingsGoals.put(goal);
      });
    }
  }

  // Restaurar meta
  Future<void> restoreGoal(int goalId) async {
    final goal = await isar.savingsGoals.get(goalId);
    if (goal != null) {
      await isar.writeTxn(() async {
        goal.isDeleted = false;
        await isar.savingsGoals.put(goal);
      });
    }
  }

  // Obtener metas en papelera
  Future<List<SavingsGoal>> getDeletedGoals() async {
    return await isar.savingsGoals.where().filter().isDeletedEqualTo(true).findAll();
  }

  // Configuración de presupuesto quincenal anti-ceros
  Future<BudgetProfile> getBudgetProfile() async {
    var profile = await isar.budgetProfiles.get(1);
    if (profile == null) {
      profile = BudgetProfile()
        ..id = 1
        ..biweeklyIncome = 6500.0 // Default sugerido, editable por el usuario
        ..fixedExpenses = 1500.0
        ..targetSavingsPerQuincena = 1000.0
        ..lastUpdated = DateTime.now();

      await isar.writeTxn(() async {
        await isar.budgetProfiles.put(profile!);
      });
    }
    return profile;
  }

  Future<void> saveBudgetProfile(BudgetProfile profile) async {
    profile.id = 1;
    profile.lastUpdated = DateTime.now();
    await isar.writeTxn(() async {
      await isar.budgetProfiles.put(profile);
    });
  }
}
