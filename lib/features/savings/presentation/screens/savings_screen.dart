import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/savings_goal.dart';
import '../providers/savings_providers.dart';
import '../widgets/ai_coach_modal.dart';

class SavingsScreen extends ConsumerStatefulWidget {
  const SavingsScreen({super.key});

  @override
  ConsumerState<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends ConsumerState<SavingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    return Scaffold(
      backgroundColor: const Color(0xFF10141D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF10141D),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ahorro & Disciplina', style: TextStyle(fontSize: 12, color: Color(0xFF8E9BB0))),
            Text('Metas & Control Quincenal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy_outlined, color: Color(0xFF00B0FF), size: 26),
            onPressed: () => AiCoachModal.show(context),
            tooltip: 'Coach Financiero IA',
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF161F33),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF00E676),
              ),
              labelColor: const Color(0xFF10141D),
              unselectedLabelColor: const Color(0xFF8E9BB0),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.two_wheeler, size: 18),
                      SizedBox(width: 6),
                      Flexible(child: Text('Metas de Ahorro', overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.security, size: 18),
                      SizedBox(width: 6),
                      Flexible(child: Text('Anti-Ceros', overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGoalsTab(context, currencyFormatter),
          _buildAntiZeroTab(context, currencyFormatter),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: METAS DE AHORRO (ITALIKA 280Z HERO)
  // ==========================================
  Widget _buildGoalsTab(BuildContext context, NumberFormat formatter) {
    final goalsAsync = ref.watch(savingsGoalsProvider);
    final profileAsync = ref.watch(budgetProfileProvider);
    final quota = profileAsync.valueOrNull?.targetSavingsPerQuincena ?? 1608.0;

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(savingsGoalsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            goalsAsync.when(
              data: (goals) {
                // Buscamos la meta estrella (Italika o primera)
                SavingsGoal heroGoal = goals.isNotEmpty ? goals.first : SavingsGoal();
                for (final g in goals) {
                  if (g.title.toLowerCase().contains('italika') || g.iconName == 'two_wheeler') {
                    heroGoal = g;
                    break;
                  }
                }

                final otherGoals = goals.where((g) => g.id != heroGoal.id).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (heroGoal.title.isNotEmpty) ...[
                      _buildHeroGoalCard(heroGoal, formatter, quota),
                      const SizedBox(height: 25),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Otras Metas de Ahorro',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        TextButton.icon(
                          onPressed: () => _showAddGoalModal(context),
                          icon: const Icon(Icons.add, size: 18, color: Color(0xFF00E676)),
                          label: const Text('Nueva Meta', style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (otherGoals.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161F33),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF2A3650)),
                        ),
                        child: const Center(
                          child: Text(
                            'Puedes crear metas adicionales (ej. Casco certificado, Fondo de emergencia, Viaje).',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 13),
                          ),
                        ),
                      )
                    else
                      ...otherGoals.map((g) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildSecondaryGoalCard(g, formatter),
                      )),
                  ],
                );
              },
              loading: () => const Center(child: Padding(
                padding: EdgeInsets.all(50.0),
                child: CircularProgressIndicator(),
              )),
              error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Tarjeta Heroica de la Italika 280Z
  Widget _buildHeroGoalCard(SavingsGoal goal, NumberFormat formatter, double quota) {
    final progress = goal.targetAmount > 0 ? (goal.currentSaved / goal.targetAmount) : 0.0;
    final percentage = (progress * 100).clamp(0.0, 100.0);
    final remaining = (goal.targetAmount - goal.currentSaved).clamp(0.0, goal.targetAmount);

    // Estimación dinámica con la cuota real del plan
    final safeQuota = quota > 0 ? quota : 1608.0;
    final quincenasLeft = (remaining / safeQuota).ceil();
    final monthsLeft = (quincenasLeft / 2).ceil();

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF161F33), Color(0xFF1E2D4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF00E676).withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E676).withOpacity(0.12),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E676).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Color(0xFF00E676)),
                    SizedBox(width: 4),
                    Text('META PRINCIPAL', style: TextStyle(color: Color(0xFF00E676), fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Color(0xFF8E9BB0), size: 20),
                onPressed: () => _showEditGoalModal(context, goal),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E676).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.two_wheeler, size: 36, color: Color(0xFF00E676)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Objetivo: ${formatter.format(goal.targetAmount)}',
                      style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Barra de progreso y monto ahorrado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Llevas ahorrado: ${formatter.format(goal.currentSaved)}',
                style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: const Color(0xFF10141D),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00E676)),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 14),

          // Métricas de proyección
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10141D).withOpacity(0.7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(child: _buildGoalMiniStat('Faltan', formatter.format(remaining), const Color(0xFFE94057))),
                Container(width: 1, height: 30, color: const Color(0xFF2A3650)),
                Expanded(child: _buildGoalMiniStat('Aporte ${formatter.format(safeQuota)}/q', '~ $quincenasLeft quincenas', const Color(0xFF00B0FF))),
                Container(width: 1, height: 30, color: const Color(0xFF2A3650)),
                Expanded(child: _buildGoalMiniStat('Estreno en', '~ $monthsLeft meses', const Color(0xFF00E676))),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Botón de Aportar
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E676),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => _showAddContributionModal(context, goal),
              icon: const Icon(Icons.add_circle, color: Color(0xFF10141D)),
              label: const Text(
                'APORTAR A LA META',
                style: TextStyle(color: Color(0xFF10141D), fontWeight: FontWeight.bold, letterSpacing: 1.1),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00B0FF), width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => AiCoachModal.show(context),
              icon: const Icon(Icons.calculate_outlined, color: Color(0xFF00B0FF), size: 18),
              label: const Text(
                'ESTRUCTURAR AHORRO & PASAJES',
                style: TextStyle(color: Color(0xFF00B0FF), fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),

          // Aportaciones recientes si existen
          if (goal.contributions.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Aportaciones Recientes:', style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            ...goal.contributions.take(3).map((c) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${DateFormat('dd MMM', 'es_ES').format(c.date)} - ${c.note ?? 'Aporte'}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '+${formatter.format(c.amount)}',
                    style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildGoalMiniStat(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 11), textAlign: TextAlign.center),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildSecondaryGoalCard(SavingsGoal goal, NumberFormat formatter) {
    final progress = goal.targetAmount > 0 ? (goal.currentSaved / goal.targetAmount) : 0.0;
    final percentage = (progress * 100).clamp(0.0, 100.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A3650)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(goal.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(
                '${formatter.format(goal.currentSaved)} / ${formatter.format(goal.targetAmount)}',
                style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: const Color(0xFF10141D),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00B0FF)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${percentage.toStringAsFixed(1)}% completado', style: const TextStyle(color: Color(0xFF00B0FF), fontSize: 11)),
              TextButton(
                onPressed: () => _showAddContributionModal(context, goal),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
                child: const Text('+ Aportar', style: TextStyle(color: Color(0xFF00E676), fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: CONTROL QUINCENAL ANTI-CEROS
  // ==========================================
  Widget _buildAntiZeroTab(BuildContext context, NumberFormat formatter) {
    final diagnosisAsync = ref.watch(antiZeroDiagnosisProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(antiZeroDiagnosisProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: diagnosisAsync.when(
          data: (diagnosis) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner del Coach Financiero IA
              _buildAiCoachPromoBanner(context),

              // Semáforo y Alerta Diaria
              _buildDailyLimitBanner(diagnosis, formatter),
              const SizedBox(height: 20),

              // Desglose de la Fórmula
              _buildQuincenaBreakdown(diagnosis, formatter),
              const SizedBox(height: 20),

              // Reglas de Oro Anti-Despilfarro
              _buildGoldenRulesCard(),
              const SizedBox(height: 30),
            ],
          ),
          loading: () => const Center(child: Padding(
            padding: EdgeInsets.all(50.0),
            child: CircularProgressIndicator(),
          )),
          error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
        ),
      ),
    );
  }

  Widget _buildAiCoachPromoBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF161F33), Color(0xFF132B4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00B0FF).withOpacity(0.5), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF00B0FF).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_outlined, color: Color(0xFF00B0FF), size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Coach Financiero Personal',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Calcula tus pasajes de chamba, sueldo y comidas para blindar tu Italika.',
                  style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 12),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => AiCoachModal.show(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B0FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'ESTRUCTURAR QUINCENA',
                      style: TextStyle(color: Color(0xFF10141D), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyLimitBanner(AntiZeroDiagnosis diag, NumberFormat formatter) {
    final statusColor = diag.isAtRisk ? const Color(0xFFE94057) : const Color(0xFF00E676);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(diag.isAtRisk ? Icons.warning_amber_rounded : Icons.shield_outlined, color: statusColor, size: 20),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        diag.isAtRisk ? 'ALERTA DESPILFARRO' : 'PRESUPUESTO SEGURO',
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10141D),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Faltan ${diag.daysRemainingInQuincena} días',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Límite Diario Recomendado:',
            style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 13),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                formatter.format(diag.safeDailyLimit),
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: statusColor),
              ),
              const Text(' / día', style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            diag.statusMessage,
            style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildQuincenaBreakdown(AntiZeroDiagnosis diag, NumberFormat formatter) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A3650)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Desglose de tu Quincena', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Color(0xFF00E676), size: 20),
                onPressed: () => _showEditBudgetProfileModal(context),
                tooltip: 'Ajustar Sueldo y Gastos',
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildBreakdownRow('Sueldo Quincenal Neto', '+${formatter.format(diag.biweeklyIncome)}', const Color(0xFF00E676), Icons.arrow_downward),
          const Divider(color: Color(0xFF2A3650), height: 20),
          _buildBreakdownRow('Pago de Tarjetas (Deudas corte)', '-${formatter.format(diag.cardPaymentsDue)}', const Color(0xFFE94057), Icons.credit_card),
          const SizedBox(height: 8),
          _buildBreakdownRow('Gastos Fijos Esenciales', '-${formatter.format(diag.fixedExpenses)}', const Color(0xFFFFB300), Icons.home_outlined),
          const SizedBox(height: 8),
          _buildBreakdownRow('Aporte Intocable a Italika 280Z', '-${formatter.format(diag.forcedSavingsItalika)}', const Color(0xFF00B0FF), Icons.two_wheeler),
          const Divider(color: Color(0xFF2A3650), height: 20),
          _buildBreakdownRow(
            'Dinero Realmente Libre',
            formatter.format(diag.realFreeMoney),
            diag.realFreeMoney >= 0 ? const Color(0xFF00E676) : const Color(0xFFE94057),
            Icons.account_balance_wallet,
            isBold: true,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2A3650)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _showEditBudgetProfileModal(context),
              icon: const Icon(Icons.edit, size: 16, color: Color(0xFF8E9BB0)),
              label: const Text('Editar Sueldo y Cuota de Ahorro', style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String amount, Color color, IconData icon, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: Colors.white, fontSize: isBold ? 14 : 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
        Text(
          amount,
          style: TextStyle(color: color, fontSize: isBold ? 16 : 13, fontWeight: isBold ? FontWeight.bold : FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildGoldenRulesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A3650)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Color(0xFFFFB300), size: 20),
              SizedBox(width: 8),
              Text('Reglas de Oro Anti-Despilfarro', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          SizedBox(height: 14),
          _RuleBullet(
            number: '1',
            title: 'Págate a ti primero:',
            desc: 'En cuanto caiga la quincena, aparta de inmediato los \$1,000 de tu Italika. Si lo dejas para "lo que sobre", nunca sobrará.',
          ),
          SizedBox(height: 10),
          _RuleBullet(
            number: '2',
            title: 'La trampa del sobrante:',
            desc: 'Tener dinero en la cuenta bancaria no significa que puedas gastarlo. Respeta tu límite diario.',
          ),
          SizedBox(height: 10),
          _RuleBullet(
            number: '3',
            title: 'Cero tarjetazos por impulso:',
            desc: 'Si no tienes el efectivo ya apartado hoy para pagar esa salida o compra, no uses la tarjeta.',
          ),
        ],
      ),
    );
  }

  // Modales
  void _showAddContributionModal(BuildContext context, SavingsGoal goal) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161F33),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Aportar a ${goal.title}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              const Text('Cada peso te acerca más a estrenar tu moto.', style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 13)),
              const SizedBox(height: 18),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Monto a Depositar (\$)',
                  labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                  prefixIcon: Icon(Icons.attach_money, color: Color(0xFF00E676)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: noteController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nota (ej. Aporte quincena, Ahorro de comida)',
                  labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                  prefixIcon: Icon(Icons.note, color: Color(0xFF8E9BB0)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () async {
                    final amount = double.tryParse(amountController.text) ?? 0.0;
                    if (amount <= 0) return;

                    final repo = ref.read(savingsRepositoryProvider);
                    await repo.addContribution(goal.id, amount, note: noteController.text.trim());

                    if (context.mounted) {
                      Navigator.pop(ctx);
                      ref.invalidate(savingsGoalsProvider);
                      ref.invalidate(antiZeroDiagnosisProvider);
                    }
                  },
                  child: const Text('REGISTRAR APORTE', style: TextStyle(color: Color(0xFF10141D), fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddGoalModal(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161F33),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nueva Meta de Ahorro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 18),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Meta (ej. Casco y Guantes)',
                  labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Monto Objetivo (\$)',
                  labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () async {
                    final title = titleController.text.trim();
                    final amount = double.tryParse(amountController.text) ?? 0.0;
                    if (title.isEmpty || amount <= 0) return;

                    final newGoal = SavingsGoal()
                      ..title = title
                      ..targetAmount = amount
                      ..currentSaved = 0.0
                      ..createdAt = DateTime.now()
                      ..iconName = 'savings'
                      ..colorHex = '00B0FF';

                    final repo = ref.read(savingsRepositoryProvider);
                    await repo.addGoal(newGoal);

                    if (context.mounted) {
                      Navigator.pop(ctx);
                      ref.invalidate(savingsGoalsProvider);
                    }
                  },
                  child: const Text('CREAR META', style: TextStyle(color: Color(0xFF10141D), fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditGoalModal(BuildContext context, SavingsGoal goal) {
    final titleController = TextEditingController(text: goal.title);
    final amountController = TextEditingController(text: goal.targetAmount.toStringAsFixed(0));

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161F33),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Editar Meta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 18),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Título de la Meta',
                  labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Precio Objetivo (\$)',
                  labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
                  onPressed: () async {
                    final title = titleController.text.trim();
                    final amount = double.tryParse(amountController.text) ?? goal.targetAmount;
                    if (title.isEmpty) return;

                    goal.title = title;
                    goal.targetAmount = amount;

                    final repo = ref.read(savingsRepositoryProvider);
                    await repo.updateGoal(goal);

                    if (context.mounted) {
                      Navigator.pop(ctx);
                      ref.invalidate(savingsGoalsProvider);
                      ref.invalidate(antiZeroDiagnosisProvider);
                    }
                  },
                  child: const Text('GUARDAR CAMBIOS', style: TextStyle(color: Color(0xFF10141D), fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditBudgetProfileModal(BuildContext context) async {
    final repo = ref.read(savingsRepositoryProvider);
    final profile = await repo.getBudgetProfile();

    final incomeController = TextEditingController(text: profile.biweeklyIncome.toStringAsFixed(0));
    final fixedController = TextEditingController(text: profile.fixedExpenses.toStringAsFixed(0));
    final savingsTargetController = TextEditingController(text: profile.targetSavingsPerQuincena.toStringAsFixed(0));

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161F33),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ajustes de Presupuesto Quincenal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              const Text('Ingresa tus datos reales para calcular tu límite diario seguro.', style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 13)),
              const SizedBox(height: 18),
              TextField(
                controller: incomeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Sueldo Neto por Quincena (\$)',
                  labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: fixedController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Gastos Fijos Esenciales (\$)',
                  labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: savingsTargetController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Aporte Intocable de Ahorro / Quincena (\$)',
                  labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
                  onPressed: () async {
                    final income = double.tryParse(incomeController.text) ?? profile.biweeklyIncome;
                    final fixed = double.tryParse(fixedController.text) ?? profile.fixedExpenses;
                    final savings = double.tryParse(savingsTargetController.text) ?? profile.targetSavingsPerQuincena;

                    profile.biweeklyIncome = income;
                    profile.fixedExpenses = fixed;
                    profile.targetSavingsPerQuincena = savings;

                    await repo.saveBudgetProfile(profile);

                    if (context.mounted) {
                      Navigator.pop(ctx);
                      ref.invalidate(budgetProfileProvider);
                      ref.invalidate(antiZeroDiagnosisProvider);
                    }
                  },
                  child: const Text('ACTUALIZAR PRESUPUESTO', style: TextStyle(color: Color(0xFF10141D), fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RuleBullet extends StatelessWidget {
  final String number;
  final String title;
  final String desc;

  const _RuleBullet({required this.number, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: const Color(0xFF00E676).withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
              children: [
                TextSpan(text: '$title ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: desc, style: const TextStyle(color: Color(0xFF8E9BB0))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
