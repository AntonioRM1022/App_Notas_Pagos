class AiSavingsPlan {
  final double biweeklyIncome;
  final double biweeklyTransport;
  final double biweeklyFixedExpenses;
  final double cardDebtsToPay;
  final double recommendedSavingsItalika;
  final double safeDailyAllowance;
  final int estimatedQuincenasToBike;
  final String coachVerdict;
  final List<String> actionPlan;
  final String motivationPhrase;

  AiSavingsPlan({
    required this.biweeklyIncome,
    required this.biweeklyTransport,
    required this.biweeklyFixedExpenses,
    required this.cardDebtsToPay,
    required this.recommendedSavingsItalika,
    required this.safeDailyAllowance,
    required this.estimatedQuincenasToBike,
    required this.coachVerdict,
    required this.actionPlan,
    required this.motivationPhrase,
  });

  factory AiSavingsPlan.fromJson(Map<String, dynamic> json) {
    return AiSavingsPlan(
      biweeklyIncome: (json['biweeklyIncome'] as num?)?.toDouble() ?? 0.0,
      biweeklyTransport: (json['biweeklyTransport'] as num?)?.toDouble() ?? 0.0,
      biweeklyFixedExpenses: (json['biweeklyFixedExpenses'] as num?)?.toDouble() ?? 0.0,
      cardDebtsToPay: (json['cardDebtsToPay'] as num?)?.toDouble() ?? 0.0,
      recommendedSavingsItalika: (json['recommendedSavingsItalika'] as num?)?.toDouble() ?? 1000.0,
      safeDailyAllowance: (json['safeDailyAllowance'] as num?)?.toDouble() ?? 100.0,
      estimatedQuincenasToBike: (json['estimatedQuincenasToBike'] as num?)?.toInt() ?? 24,
      coachVerdict: json['coachVerdict'] as String? ?? 'Plan estructurado por tu Coach IA.',
      actionPlan: (json['actionPlan'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      motivationPhrase: json['motivationPhrase'] as String? ?? '¡A darle que esa Italika 280Z no se va a comprar sola!',
    );
  }
}
