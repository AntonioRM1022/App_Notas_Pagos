import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:go_router/go_router.dart';
import '../providers/dashboard_providers.dart';
import '../../../cards_vault/presentation/providers/cards_providers.dart';

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: _buildQuickActionButton(Icons.add_shopping_cart, 'Nueva Compra', const Color(0xFF00E676), () => _showQuickActionModal(context, 'compra'))),
                  const SizedBox(width: 15),
                  Expanded(child: _buildQuickActionButton(Icons.payment, 'Pagar Tarjeta', const Color(0xFFE94057), () => _showQuickActionModal(context, 'pago'))),
                  const SizedBox(width: 15),
                  Expanded(child: _buildQuickActionButton(Icons.edit_note, 'Nueva Nota', const Color(0xFF00B0FF), () => _showQuickActionNoteModal(context))),
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
}

