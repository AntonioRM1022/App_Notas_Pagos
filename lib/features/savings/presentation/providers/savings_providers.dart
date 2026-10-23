import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../../data/repository/savings_repository.dart';
import '../../domain/savings_goal.dart';
import '../../domain/budget_profile.dart';
import '../../../dashboard/presentation/providers/dashboard_providers.dart';

final savingsRepositoryProvider = Provider<SavingsRepository>((ref) {
  return SavingsRepository(isar);
});

final savingsGoalsProvider = FutureProvider<List<SavingsGoal>>((ref) async {
  final repo = ref.watch(savingsRepositoryProvider);
  return repo.getGoals();
});

final budgetProfileProvider = FutureProvider<BudgetProfile>((ref) async {
  final repo = ref.watch(savingsRepositoryProvider);
  return repo.getBudgetProfile();
});

class AntiZeroDiagnosis {
  final double biweeklyIncome;
  final double cardPaymentsDue;
  final double fixedExpenses;
  final double forcedSavingsItalika;
  final double realFreeMoney;
  final int daysRemainingInQuincena;
  final double safeDailyLimit;
  final bool isAtRisk;
  final String statusMessage;

  AntiZeroDiagnosis({
    required this.biweeklyIncome,
    required this.cardPaymentsDue,
    required this.fixedExpenses,
    required this.forcedSavingsItalika,
    required this.realFreeMoney,
    required this.daysRemainingInQuincena,
    required this.safeDailyLimit,
    required this.isAtRisk,
    required this.statusMessage,
  });
}

final antiZeroDiagnosisProvider = FutureProvider<AntiZeroDiagnosis>((ref) async {
  final profile = await ref.watch(budgetProfileProvider.future);
  
  // Obtener compromisos de tarjetas del dashboard provider si están disponibles
  double cardDue = 0.0;
  final cardSummariesAsync = ref.watch(cardSummariesProvider);
  cardSummariesAsync.whenData((summaries) {
    for (var s in summaries) {
      // Priorizar el saldo para no generar intereses del corte o total debido
      final due = s.statement.previousCutoffDue > 0 
          ? s.statement.previousCutoffDue 
          : s.statement.currentCutoffAccumulated;
      cardDue += due;
    }
  });

  // Calcular días restantes de la quincena actual
  final now = DateTime.now();
  final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
  
  int daysRemaining;
  if (now.day <= 15) {
    daysRemaining = (15 - now.day) + 1;
  } else {
    daysRemaining = (lastDayOfMonth - now.day) + 1;
  }
  if (daysRemaining < 1) daysRemaining = 1;

  final totalIncome = profile.biweeklyIncome;
  final fixed = profile.fixedExpenses;
  final forcedSavings = profile.targetSavingsPerQuincena;

  // Dinero realmente libre para sobrevivir sin caer en ceros
  final realFree = totalIncome - cardDue - fixed - forcedSavings;
  final safeDaily = realFree > 0 ? (realFree / daysRemaining) : 0.0;
  final isRisk = realFree <= 0 || safeDaily < 60;

  String message;
  if (realFree <= 0) {
    message = '¡ALERTA ROJA! Tus deudas y gastos superan tu ingreso quincenal. ¡No gastes ni un peso más!';
  } else if (safeDaily < 80) {
    message = '¡Cuidado! Tu margen diario es muy ajustado. Si gastas en salidas hoy, te quedarás en ceros.';
  } else {
    message = '¡Vas en buen camino! Respeta tu límite diario y tu ahorro para la Italika estará 100% blindado.';
  }

  return AntiZeroDiagnosis(
    biweeklyIncome: totalIncome,
    cardPaymentsDue: cardDue,
    fixedExpenses: fixed,
    forcedSavingsItalika: forcedSavings,
    realFreeMoney: realFree,
    daysRemainingInQuincena: daysRemaining,
    safeDailyLimit: safeDaily,
    isAtRisk: isRisk,
    statusMessage: message,
  );
});
