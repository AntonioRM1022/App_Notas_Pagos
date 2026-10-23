import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/ai_savings_plan.dart';
import '../../data/services/ai_savings_coach_service.dart';
import '../providers/savings_providers.dart';
import '../../../dashboard/presentation/providers/dashboard_providers.dart';

class AiCoachModal extends ConsumerStatefulWidget {
  const AiCoachModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161F33),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => const AiCoachModal(),
    );
  }

  @override
  ConsumerState<AiCoachModal> createState() => _AiCoachModalState();
}

class _AiCoachModalState extends ConsumerState<AiCoachModal> {
  final _coachService = AiSavingsCoachService();

  // Controladores de preguntas
  final _incomeController = TextEditingController(text: '6500');
  final _transportController = TextEditingController(text: '45');
  int _workDaysPerWeek = 6; // 5 o 6 días comunes en México
  final _foodWorkController = TextEditingController(text: '50');
  final _fixedExpensesController = TextEditingController(text: '1200');
  final _cardDebtsController = TextEditingController();
  final _habitsController = TextEditingController(text: 'Salidas los fines de semana, comida rápida y antojos');

  bool _isLoading = false;
  AiSavingsPlan? _generatedPlan;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Pre-cargar deuda de tarjetas del usuario si existe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cardSummaries = ref.read(cardSummariesProvider).valueOrNull ?? [];
      double totalDue = 0.0;
      for (var s in cardSummaries) {
        final due = s.statement.previousCutoffDue > 0
            ? s.statement.previousCutoffDue
            : s.statement.currentCutoffAccumulated;
        totalDue += due;
      }
      if (totalDue > 0) {
        _cardDebtsController.text = totalDue.toStringAsFixed(0);
      } else {
        _cardDebtsController.text = '800';
      }
    });
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _transportController.dispose();
    _foodWorkController.dispose();
    _fixedExpensesController.dispose();
    _cardDebtsController.dispose();
    _habitsController.dispose();
    super.dispose();
  }

  Future<void> _analyzeWithAi() async {
    final income = double.tryParse(_incomeController.text) ?? 0.0;
    final transport = double.tryParse(_transportController.text) ?? 0.0;
    final foodWork = double.tryParse(_foodWorkController.text) ?? 0.0;
    final fixed = double.tryParse(_fixedExpensesController.text) ?? 0.0;
    final cardDebts = double.tryParse(_cardDebtsController.text) ?? 0.0;
    final habits = _habitsController.text.trim();

    if (income <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa tu sueldo quincenal')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final plan = await _coachService.generatePlan(
        biweeklyIncome: income,
        dailyTransport: transport,
        workDaysPerWeek: _workDaysPerWeek,
        dailyFoodWork: foodWork,
        otherFixedExpenses: fixed,
        cardDebts: cardDebts,
        targetBikePrice: 48000.0,
        spendingHabits: habits,
      );

      setState(() {
        _generatedPlan = plan;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No se pudo generar el plan: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _applyPlanToBudget(AiSavingsPlan plan) async {
    final repo = ref.read(savingsRepositoryProvider);
    final profile = await repo.getBudgetProfile();

    profile.biweeklyIncome = plan.biweeklyIncome;
    profile.fixedExpenses = plan.biweeklyTransport + plan.biweeklyFixedExpenses;
    profile.targetSavingsPerQuincena = plan.recommendedSavingsItalika;

    await repo.saveBudgetProfile(profile);

    ref.invalidate(budgetProfileProvider);
    ref.invalidate(antiZeroDiagnosisProvider);
    ref.invalidate(savingsGoalsProvider);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF00E676),
          content: Text('¡Plan de ahorro aplicado con éxito a tu quincena!', style: TextStyle(color: Color(0xFF10141D), fontWeight: FontWeight.bold)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 24,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: const Color(0xFF2A3650), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),

            // Encabezado
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B0FF).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.smart_toy_outlined, color: Color(0xFF00B0FF), size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Coach Financiero Inteligente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('Estructura tu quincena y tu Italika 280Z', style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (_isLoading) ...[
              _buildLoadingView(),
            ] else if (_generatedPlan != null) ...[
              _buildPlanResultView(_generatedPlan!, currencyFormatter),
            ] else ...[
              _buildQuestionnaireView(),
            ],
          ],
        ),
      ),
    );
  }

  // Vista 1: Cuestionario Inteligente
  Widget _buildQuestionnaireView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Responde estas preguntas breves para calcular exactamente cuánto te cuesta ir a la chamba y cuánto debes apartar para tu moto:',
          style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
        ),
        const SizedBox(height: 18),

        // Pregunta 1: Sueldo
        _buildInputField(
          label: '1. ¿Cuánto ganas neto por quincena en la chamba?',
          controller: _incomeController,
          prefixIcon: Icons.attach_money,
          isNumeric: true,
        ),
        const SizedBox(height: 14),

        // Pregunta 2: Pasajes y días
        _buildInputField(
          label: '2. ¿Cuánto te gastas en pasajes al día para ir y volver?',
          controller: _transportController,
          prefixIcon: Icons.directions_bus,
          isNumeric: true,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Días que vas a la chamba por semana:', style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 12)),
            DropdownButton<int>(
              value: _workDaysPerWeek,
              dropdownColor: const Color(0xFF161F33),
              style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold),
              underline: Container(),
              items: [4, 5, 6, 7].map((d) => DropdownMenuItem(value: d, child: Text('$d días'))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _workDaysPerWeek = val);
              },
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Pregunta 3: Comidas en el trabajo
        _buildInputField(
          label: '3. ¿Cuánto gastas en comida o refrescos al día en la chamba?',
          controller: _foodWorkController,
          prefixIcon: Icons.fastfood_outlined,
          isNumeric: true,
        ),
        const SizedBox(height: 14),

        // Pregunta 4: Gastos Fijos
        _buildInputField(
          label: '4. Otros gastos fijos quincenales (servicios, apoyo casa)',
          controller: _fixedExpensesController,
          prefixIcon: Icons.home_outlined,
          isNumeric: true,
        ),
        const SizedBox(height: 14),

        // Pregunta 5: Deudas de tarjetas
        _buildInputField(
          label: '5. Pagos pendientes de tarjetas de crédito en esta quincena',
          controller: _cardDebtsController,
          prefixIcon: Icons.credit_card,
          isNumeric: true,
        ),
        const SizedBox(height: 14),

        // Pregunta 6: Fuga de dinero
        _buildInputField(
          label: '6. ¿En qué te sueles gastar lo que te sobra?',
          controller: _habitsController,
          prefixIcon: Icons.sentiment_dissatisfied_outlined,
          isNumeric: false,
        ),
        const SizedBox(height: 24),

        if (_errorMessage != null) ...[
          Text(_errorMessage!, style: const TextStyle(color: Color(0xFFE94057), fontSize: 12)),
          const SizedBox(height: 12),
        ],

        // Botón Analizar
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00B0FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: _analyzeWithAi,
            icon: const Icon(Icons.psychology, color: Color(0xFF10141D)),
            label: const Text(
              'ESTRUCTURAR MI AHORRO',
              style: TextStyle(color: Color(0xFF10141D), fontWeight: FontWeight.bold, letterSpacing: 1.1),
            ),
          ),
        ),
      ],
    );
  }

  // Vista 2: Cargando análisis
  Widget _buildLoadingView() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: const Column(
        children: [
          CircularProgressIndicator(color: Color(0xFF00B0FF)),
          SizedBox(height: 20),
          Text(
            'Analizando tus pasajes y estructurando tu quincena...',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Tu Coach Financiero está armando el plan para estrenar tu Italika 280Z.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Vista 3: Resultado del Plan de Ahorro
  Widget _buildPlanResultView(AiSavingsPlan plan, NumberFormat formatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Diagnóstico / Veredicto
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF10141D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF00B0FF).withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.record_voice_over_outlined, color: Color(0xFF00B0FF), size: 20),
                  SizedBox(width: 8),
                  Text('Veredicto del Coach:', style: TextStyle(color: Color(0xFF00B0FF), fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                plan.coachVerdict,
                style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Tarjetas métricas
        Row(
          children: [
            Expanded(
              child: _buildMetricMiniCard(
                'Pasajes Chamba',
                formatter.format(plan.biweeklyTransport),
                const Color(0xFFFFB300),
                Icons.directions_bus,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricMiniCard(
                'Ahorro Italika 280Z',
                formatter.format(plan.recommendedSavingsItalika),
                const Color(0xFF00E676),
                Icons.two_wheeler,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildMetricMiniCard(
                'Límite Diario Libre',
                '${formatter.format(plan.safeDailyAllowance)} / día',
                const Color(0xFF00B0FF),
                Icons.shield_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricMiniCard(
                'Meta de Estreno',
                '~${plan.estimatedQuincenasToBike} quincenas',
                const Color(0xFFE94057),
                Icons.flag_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Reglas de Acción
        const Text('Plan de Acción Inmediato:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 10),
        ...plan.actionPlan.map((rule) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF00E676), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(rule, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3)),
              ),
            ],
          ),
        )),
        const SizedBox(height: 14),

        // Frase motivacional
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF10141D),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A3650)),
          ),
          child: Text(
            '"${plan.motivationPhrase}"',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF00E676), fontStyle: FontStyle.italic, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 24),

        // Botón Aplicar Plan
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E676),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => _applyPlanToBudget(plan),
            icon: const Icon(Icons.check, color: Color(0xFF10141D)),
            label: const Text(
              'APLICAR ESTE PLAN A MI AHORRO',
              style: TextStyle(color: Color(0xFF10141D), fontWeight: FontWeight.bold, letterSpacing: 1.1),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton(
            onPressed: () => setState(() => _generatedPlan = null),
            child: const Text('Volver a calcular preguntas', style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 12)),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricMiniCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF10141D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A3650)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(label, style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 11), overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData prefixIcon,
    required bool isNumeric,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 12),
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF00B0FF), size: 18),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00B0FF))),
      ),
    );
  }
}
