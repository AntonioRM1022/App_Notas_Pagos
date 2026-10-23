import '../../domain/ai_savings_plan.dart';

class AiSavingsCoachService {
  AiSavingsCoachService();

  /// Motor financiero local inteligente (100% gratis, sin API keys ni conexión requerida)
  Future<AiSavingsPlan> generatePlan({
    required double biweeklyIncome,
    required double dailyTransport,
    required int workDaysPerWeek,
    required double dailyFoodWork,
    required double otherFixedExpenses,
    required double cardDebts,
    required double targetBikePrice,
    required String spendingHabits,
  }) async {
    // Simular un breve análisis para dar sensación de procesamiento
    await Future.delayed(const Duration(milliseconds: 600));

    // Cálculos de pasajes y gastos de chamba
    final workDaysPerQuincena = workDaysPerWeek * 2;
    final totalTransportQuincena = (dailyTransport * workDaysPerQuincena).roundToDouble();
    final totalFoodWorkQuincena = (dailyFoodWork * workDaysPerQuincena).roundToDouble();
    final totalFixedQuincena = (totalFoodWorkQuincena + otherFixedExpenses).roundToDouble();

    final obligatoryExpenses = totalTransportQuincena + totalFixedQuincena + cardDebts;
    final surplus = biweeklyIncome - obligatoryExpenses;

    double recommendedSavings;
    double safeDaily;

    if (surplus <= 0) {
      recommendedSavings = 300.0; // Ahorro mínimo para disciplina
      safeDaily = 0.0;
    } else if (surplus < 1200) {
      recommendedSavings = (surplus * 0.4).roundToDouble();
      final remainingForDays = (surplus - recommendedSavings);
      safeDaily = (remainingForDays / 15).roundToDouble();
    } else if (surplus < 2500) {
      recommendedSavings = (surplus * 0.5).roundToDouble();
      final remainingForDays = (surplus - recommendedSavings);
      safeDaily = (remainingForDays / 15).roundToDouble();
    } else {
      recommendedSavings = (surplus * 0.55).roundToDouble();
      final remainingForDays = (surplus - recommendedSavings);
      safeDaily = (remainingForDays / 15).roundToDouble();
    }

    final effectiveSavings = recommendedSavings > 0 ? recommendedSavings : 500.0;
    final quincenasNeeded = (targetBikePrice / effectiveSavings).ceil();

    final habitsMention = spendingHabits.trim().isNotEmpty
        ? 'Detectamos que tu fuga de dinero ocurre en: "$spendingHabits". '
        : '';

    final verdict = 'Antonio, con tu sueldo de \$${biweeklyIncome.toStringAsFixed(0)} MXN tus compromisos obligatorios (pasajes a la chamba: \$${totalTransportQuincena.toStringAsFixed(0)}, comidas/gastos fijos: \$${totalFixedQuincena.toStringAsFixed(0)} y tarjetas: \$${cardDebts.toStringAsFixed(0)}) suman \$${obligatoryExpenses.toStringAsFixed(0)} MXN. '
        '${habitsMention}Si apartas religiosamente \$${recommendedSavings.toStringAsFixed(0)} MXN en cuanto caiga la quincena, estrenas tu Italika 280Z en aproximadamente $quincenasNeeded quincenas sin quedarte en ceros.';

    return AiSavingsPlan(
      biweeklyIncome: biweeklyIncome,
      biweeklyTransport: totalTransportQuincena,
      biweeklyFixedExpenses: totalFixedQuincena,
      cardDebtsToPay: cardDebts,
      recommendedSavingsItalika: recommendedSavings,
      safeDailyAllowance: safeDaily,
      estimatedQuincenasToBike: quincenasNeeded,
      coachVerdict: verdict,
      actionPlan: [
        'Blindar Pasajes al cobrar: Tus pasajes de la chamba son exactamente \$${totalTransportQuincena.toStringAsFixed(0)} MXN por quincena ($workDaysPerQuincena días de ida y vuelta). En cuanto cobres, aparta ese efectivo exacto en un sobre o tarjeta de transporte y no lo toques.',
        'Págate a ti primero: Deposita de inmediato tus \$${recommendedSavings.toStringAsFixed(0)} MXN a tu alcancía de la Italika 280Z el mero 15 o 30, antes de pagar salidas o darte caprichos.',
        'Límite Diario Anti-Ceros: Tu presupuesto diario para gastar libre sin remordimiento es de máximo \$${safeDaily.toStringAsFixed(0)} MXN al día. Si un día te gastas más, al día siguiente no hay gastos extra.',
      ],
      motivationPhrase: 'Cada chela, salida o antojo innecesario que frenes hoy, es un litro de gasolina para rodar en tu Italika 280Z.',
    );
  }
}
