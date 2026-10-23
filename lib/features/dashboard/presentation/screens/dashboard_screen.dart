import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:go_router/go_router.dart';
import '../providers/dashboard_providers.dart';
import '../../../cards_vault/presentation/providers/cards_providers.dart';
import '../../../loans/presentation/providers/loans_providers.dart';
import '../../../savings/presentation/providers/savings_providers.dart';
import '../../../savings/domain/savings_goal.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null);
  }

  @override
  Widget build(BuildContext context) {
    final upcomingEvents = ref.watch(upcomingEventsProvider);
    final cardSummaries = ref.watch(cardSummariesProvider);
    final loansSummary = ref.watch(loansSummaryProvider);
    final savingsGoals = ref.watch(savingsGoalsProvider);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => context.push('/settings'),
            child: CircleAvatar(
              backgroundColor: Colors.grey[800],
              backgroundImage: const AssetImage('assets/images/profile.jpg'),
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hola,', style: TextStyle(fontSize: 12, color: Color(0xFF8E9BB0))),
            Text('Antonio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(cardSummariesProvider);
          ref.invalidate(upcomingEventsProvider);
          ref.invalidate(cardsProvider);
          ref.invalidate(loansSummaryProvider);
          ref.invalidate(savingsGoalsProvider);
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionTitle(Icons.notifications_active_outlined, 'Alertas Financieras'),
            ),
            const SizedBox(height: 15),
            cardSummaries.when(
              data: (summaries) {
                if (summaries.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildEmptyFinancialCard(),
                  );
                }
                return SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.9),
                    itemCount: summaries.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _buildSingleCardFinancialSummary(summaries[index]),
                      );
                    },
                  ),
                );
              },
              loading: () => const SizedBox(height: 220, child: Center(child: CircularProgressIndicator())),
              error: (e, s) => Text('Error: $e', style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 22),

            // Banner de la Meta Italika 280Z
            _buildDashboardItalikaBanner(context, savingsGoals),
            const SizedBox(height: 22),

            // Widget de Cuentas Claras / Préstamos
            _buildDashboardLoansCard(context, loansSummary),
            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionTitle(Icons.event_outlined, 'Próximos Eventos'),
            ),
            const SizedBox(height: 15),
            upcomingEvents.when(
              data: (events) {
                if (events.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildEmptyUpcomingEventCard(),
                  );
                }
                return SizedBox(
                  height: 380,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.9),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _buildUpcomingEventCard(events[index]),
                      );
                    },
                  ),
                );
              },
              loading: () => const SizedBox(height: 380, child: Center(child: CircularProgressIndicator())),
              error: (e, s) => Text('Error: $e', style: const TextStyle(color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionTitle(Icons.bolt, 'Acceso Rápido'),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildQuickActionButton(Icons.add_shopping_cart, 'Compra', const Color(0xFF00E676), () => _showQuickActionModal(context, 'compra')),
                  const SizedBox(width: 12),
                  _buildQuickActionButton(Icons.payment, 'Pagar', const Color(0xFFE94057), () => _showQuickActionModal(context, 'pago')),
                  const SizedBox(width: 12),
                  _buildQuickActionButton(Icons.handshake_outlined, 'Prestar', const Color(0xFF00B0FF), () => context.go('/loans')),
                  const SizedBox(width: 12),
                  _buildQuickActionButton(Icons.two_wheeler, 'Italika 280Z', const Color(0xFFFFB300), () => context.go('/savings')),
                  const SizedBox(width: 12),
                  _buildQuickActionButton(Icons.edit_note, 'Nueva Nota', const Color(0xFFAB47BC), () => _showQuickActionNoteModal(context)),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF8E9BB0)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 85,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF161F33),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActionModal(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161F33),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, child) {
            final cardsAsync = ref.watch(cardsProvider);
            return cardsAsync.when(
              data: (cards) {
                if (cards.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Text('No tienes tarjetas registradas', style: TextStyle(color: Colors.white)),
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Text(type == 'compra' ? 'Selecciona tarjeta para comprar' : 'Selecciona tarjeta a pagar', 
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...cards.map((card) => ListTile(
                      leading: const Icon(Icons.credit_card, color: Color(0xFF8E9BB0)),
                      title: Text(card.alias, style: const TextStyle(color: Colors.white)),
                      onTap: () {
                         Navigator.pop(ctx);
                         context.push('/cards/detail', extra: {'card': card, 'action': type});
                      },
                    )).toList(),
                    const SizedBox(height: 20),
                  ],
                );
              },
              loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
              error: (e,s) => Text('Error: $e', style: const TextStyle(color: Colors.white)),
            );
          }
        );
      }
    );
  }

  void _showQuickActionNoteModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161F33),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Text('¿Qué tipo de nota quieres crear?', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.favorite, color: Color(0xFFE94057)),
              title: const Text('Nota de Amor', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                context.go('/personal_space', extra: 'amor');
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Color(0xFF00B0FF)),
              title: const Text('Nota Personal (Contraseñas)', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                context.go('/personal_space', extra: 'personal');
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      }
    );
  }

  Widget _buildEmptyFinancialCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 40, color: Color(0xFF8E9BB0)),
            SizedBox(height: 10),
            Text('No hay alertas financieras', style: TextStyle(color: Color(0xFF8E9BB0))),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleCardFinancialSummary(CardFinancialSummary summary) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(summary.card.alias, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(Icons.swipe, color: Colors.white.withOpacity(0.3), size: 18),
            ],
          ),
          const SizedBox(height: 15),
          if (summary.alert != null)
            _buildAlertRow(
              icon: summary.alert!.isOverdue ? Icons.warning_rounded : Icons.check_circle_outline,
              iconColor: summary.alert!.isOverdue ? const Color(0xFFE94057) : const Color(0xFF00E676),
              title: summary.alert!.cardAlias,
              subtitle: summary.alert!.statusText,
              amount: summary.alert!.amount > 0 ? '\$${summary.alert!.amount.toStringAsFixed(2)}' : 'Al corriente',
              isOverdue: summary.alert!.isOverdue,
            ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('A PAGAR (CORTE ANTERIOR)', style: TextStyle(fontSize: 10, color: Color(0xFF8E9BB0), letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text(
                      '\$${summary.statement.previousCutoffDue.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: summary.statement.previousCutoffDue > 0 ? const Color(0xFFE94057) : const Color(0xFF00E676)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('ACUMULADO (MES ACTUAL)', style: TextStyle(fontSize: 10, color: Color(0xFF8E9BB0), letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text(
                      '\$${summary.statement.currentCutoffAccumulated.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String amount,
    required bool isOverdue,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isOverdue ? const Color(0xFFE94057).withOpacity(0.1) : Colors.transparent,
            shape: BoxShape.circle,
            border: !isOverdue ? Border.all(color: const Color(0xFF2A3650)) : null,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isOverdue ? const Color(0xFFE94057) : const Color(0xFF8E9BB0),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('MONTO A PAGAR', style: TextStyle(fontSize: 9, color: Color(0xFF8E9BB0), letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyUpcomingEventCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: const Column(
        children: [
          Icon(Icons.event_busy, size: 40, color: Color(0xFF8E9BB0)),
          SizedBox(height: 10),
          Text(
            'No hay próximos eventos',
            style: TextStyle(color: Color(0xFF8E9BB0)),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventCard(UpcomingEventInfo eventInfo) {

    String formattedDate;
    try {
      formattedDate = DateFormat("EEEE, d 'de' MMMM", 'es_ES').format(eventInfo.date);
    } catch (e) {
      formattedDate = 'Viernes, 24 de Noviembre'; // Fallback just in case
    }
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: Column(
        children: [
          // Circular Progress
          SizedBox(
            width: 130,
            height: 130,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: eventInfo.daysRemaining < 30 ? (30 - eventInfo.daysRemaining) / 30 : 0.1, // Visual representation
                  strokeWidth: 8,
                  backgroundColor: const Color(0xFF2A3650),
                  color: const Color(0xFF00E676), // Accent Teal
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('FALTAN', style: TextStyle(fontSize: 10, color: Color(0xFF8E9BB0))),
                    Text(
                      '${eventInfo.daysRemaining}',
                      style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const Text('DÍAS', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Text(
            eventInfo.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF8E9BB0),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Tarjeta: ${eventInfo.card.alias}',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8E9BB0),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: OutlinedButton(
              onPressed: () {
                context.push('/cards/detail', extra: {'card': eventInfo.card});
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2A3650), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'VER DETALLES',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItalikaBanner(BuildContext context, AsyncValue<List<SavingsGoal>> savingsGoalsAsync) {
    final currencyFormatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: savingsGoalsAsync.when(
        data: (goals) {
          if (goals.isEmpty) return const SizedBox.shrink();
          SavingsGoal goal = goals.first;
          for (final g in goals) {
            if (g.title.toLowerCase().contains('italika') || g.iconName == 'two_wheeler') {
              goal = g;
              break;
            }
          }
          final progress = goal.targetAmount > 0 ? (goal.currentSaved / goal.targetAmount) : 0.0;
          final percentage = (progress * 100).clamp(0.0, 100.0);
          final remaining = (goal.targetAmount - goal.currentSaved).clamp(0.0, goal.targetAmount);

          return InkWell(
            onTap: () => context.go('/savings'),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF161F33), Color(0xFF1C273B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF00E676).withOpacity(0.4), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00E676).withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.two_wheeler, color: Color(0xFF00E676), size: 20),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(goal.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              const Text('Meta de Ahorro', style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      backgroundColor: const Color(0xFF10141D),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00E676)),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ahorrado: ${currencyFormatter.format(goal.currentSaved)}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Faltan: ${currencyFormatter.format(remaining)}',
                        style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildDashboardLoansCard(BuildContext context, AsyncValue<LoansSummary> loansSummaryAsync) {
    final currencyFormatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: loansSummaryAsync.when(
        data: (summary) {
          return InkWell(
            onTap: () => context.go('/loans'),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF161F33),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF2A3650)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B0FF).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.handshake_outlined, color: Color(0xFF00B0FF), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cuentas Claras & Préstamos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('Me deben: ${currencyFormatter.format(summary.totalToReceive)}', style: const TextStyle(color: Color(0xFF00E676), fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(width: 12),
                            Text('Debo: ${currencyFormatter.format(summary.totalToPay)}', style: const TextStyle(color: Color(0xFFE94057), fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFF8E9BB0), size: 14),
                ],
              ),
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

