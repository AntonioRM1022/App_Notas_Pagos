import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/credit_card.dart';
import '../../domain/card_transaction.dart';
import '../../domain/card_subscription.dart';
import '../../domain/card_calculations.dart';
import '../providers/cards_providers.dart';
import '../../../dashboard/presentation/providers/dashboard_providers.dart';
import 'package:intl/intl.dart';

class CardDetailScreen extends ConsumerStatefulWidget {
  final CreditCard card;
  final String? initialAction;

  const CardDetailScreen({super.key, required this.card, this.initialAction});

  @override
  ConsumerState<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends ConsumerState<CardDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  bool _isMultiSelectMode = false;
  Set<int> _selectedTxIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    
    if (widget.initialAction != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.initialAction == 'compra') {
          _showAddTransactionModal(true);
        } else if (widget.initialAction == 'pago') {
          _handlePayAction();
        }
      });
    }
  }

  void _handlePayAction() {
    final now = DateTime.now();
    DateTime nextLimitDate;
    if (now.day <= widget.card.paymentLimitDay) {
      nextLimitDate = DateTime(now.year, now.month, widget.card.paymentLimitDay);
    } else {
      int nextMonth = now.month == 12 ? 1 : now.month + 1;
      int nextYear = now.month == 12 ? now.year + 1 : now.year;
      nextLimitDate = DateTime(nextYear, nextMonth, widget.card.paymentLimitDay);
    }

    int daysLeft = nextLimitDate.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (daysLeft > 1) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1C273B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Text('😅 ', style: TextStyle(fontSize: 24)),
              Expanded(child: Text('¡Hey, tranquilo!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
            ],
          ),
          content: const Text(
            'Antonio calma tus problemas, todavía tienes tiempo. Tranquilo, te aviso un día antes para que pagues tus deudas.',
            style: TextStyle(color: Color(0xFF8E9BB0), height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar alerta
                _showAddTransactionModal(false); // Pagar de todos modos
              },
              child: const Text('Pagar ya', style: TextStyle(color: Color(0xFFE94057))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E676),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Me espero', style: TextStyle(color: Color(0xFF161F33), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      _showAddTransactionModal(false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddTransactionModal(bool isPurchase) {
    final conceptController = TextEditingController();
    final amountController = TextEditingController();
    final installmentsController = TextEditingController(text: '1');
    final currentMonthController = TextEditingController(text: '1');
    
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161F33),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20, right: 20, top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isPurchase ? 'Agregar Compra' : 'Agregar Pago', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 20),
                    if (isPurchase) ...[
                      TextField(
                        controller: conceptController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Concepto (Tienda / Producto)',
                          labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Color(0xFF8E9BB0), size: 20),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (_) => Container(
                                height: 300,
                                color: const Color(0xFF161F33),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 220,
                                      child: CupertinoTheme(
                                        data: const CupertinoThemeData(
                                          brightness: Brightness.dark,
                                        ),
                                        child: CupertinoDatePicker(
                                          initialDateTime: selectedDate,
                                          mode: CupertinoDatePickerMode.date,
                                          minimumDate: DateTime(2010),
                                          maximumDate: DateTime.now().add(const Duration(days: 365)),
                                          onDateTimeChanged: (val) {
                                            setStateModal(() {
                                              selectedDate = val;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    CupertinoButton(
                                      child: const Text('OK', style: TextStyle(color: Color(0xFF00E676))),
                                      onPressed: () => Navigator.of(context).pop(),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            DateFormat('dd MMMM yyyy', 'es_ES').format(selectedDate),
                            style: const TextStyle(color: Color(0xFF00E676), fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Monto (\$)',
                            labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                          ),
                        ),
                      ),
                      if (isPurchase) ...[
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: installmentsController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            onChanged: (val) {
                              setStateModal(() {});
                            },
                            decoration: const InputDecoration(
                              labelText: 'Meses',
                              labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (isPurchase && (int.tryParse(installmentsController.text) ?? 1) > 1) ...[
                    const SizedBox(height: 15),
                    TextField(
                      controller: currentMonthController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Mes actual (ej. 3 si ya pagaste 2)',
                        labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E676),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        if (amountController.text.isNotEmpty) {
                          final amount = double.tryParse(amountController.text) ?? 0.0;
                          final installments = int.tryParse(installmentsController.text) ?? 1;
                          final currentMonth = int.tryParse(currentMonthController.text) ?? 1;
                          
                          DateTime txDate = selectedDate;
                          // If user manually set currentMonth > 1 but didn't change the date,
                          // we shift the date backwards. If they changed the date, it should naturally calculate.
                          // But to avoid double shifting, we only shift if the date is today.
                          final today = DateTime.now();
                          if (installments > 1 && currentMonth > 1 && 
                              txDate.year == today.year && txDate.month == today.month && txDate.day == today.day) {
                            int targetCutoffs = currentMonth - 1;
                            txDate = DateTime(txDate.year, txDate.month - targetCutoffs, txDate.day);
                          }
                          
                          final newTx = CardTransaction()
                            ..concept = isPurchase ? conceptController.text : 'Pago a Tarjeta'
                            ..amount = amount
                            ..date = txDate
                            ..type = isPurchase ? TransactionType.purchase : TransactionType.payment
                            ..installments = isPurchase ? installments : 1;

                          final repo = ref.read(cardsRepositoryProvider);
                          await repo.addTransaction(widget.card.id, newTx);
                          
                          if (mounted) {
                            Navigator.pop(context);
                            ref.invalidate(cardTransactionsProvider(widget.card.id));
                          }
                        }
                      },
                      child: Text(isPurchase ? 'GUARDAR COMPRA' : 'GUARDAR PAGO', style: const TextStyle(color: Color(0xFF161F33), fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        );
      },
    );
  }

  void _showAddSubscriptionModal() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final dayController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161F33),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Agregar Suscripción', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Servicio (ej. Netflix, Gym)',
                  labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Costo (\$)',
                        labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: dayController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Día de Cobro (1-31)',
                        labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    if (nameController.text.isNotEmpty && amountController.text.isNotEmpty && dayController.text.isNotEmpty) {
                      final newSub = CardSubscription()
                        ..serviceName = nameController.text
                        ..amount = double.tryParse(amountController.text) ?? 0.0
                        ..billingDay = int.tryParse(dayController.text) ?? 1
                        ..lastProcessedDate = DateTime.now()
                        ..isActive = true;

                      final repo = ref.read(cardsRepositoryProvider);
                      await repo.addSubscription(widget.card.id, newSub);
                      
                      if (mounted) {
                        Navigator.pop(context);
                        ref.invalidate(cardSubscriptionsProvider(widget.card.id));
                      }
                    }
                  },
                  child: const Text('GUARDAR SUSCRIPCIÓN', style: TextStyle(color: Color(0xFF161F33), fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _handleQuickPayCycle(double amount, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C273B),
        title: const Text('¿Saldar este corte?', style: TextStyle(color: Colors.white)),
        content: Text('Se registrará un pago por la cantidad exacta de \$$amount correspondiente al $title.', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Color(0xFF8E9BB0))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
            onPressed: () async {
              Navigator.pop(ctx);
              final newTx = CardTransaction()
                ..concept = 'Pago a Tarjeta ($title)'
                ..amount = amount
                ..date = DateTime.now()
                ..type = TransactionType.payment;
                
              final repo = ref.read(cardsRepositoryProvider);
              await repo.addTransaction(widget.card.id, newTx);
              if (mounted) {
                ref.invalidate(cardTransactionsProvider(widget.card.id));
                ref.invalidate(cardSummariesProvider);
              }
            },
            child: const Text('Saldar', style: TextStyle(color: Color(0xFF161F33), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Removed _calculateTotalDue logic to use from card_calculations.dart

  @override
  Widget build(BuildContext context) {
    final txAsync = ref.watch(cardTransactionsProvider(widget.card.id));
    
    Widget? bottomBar;
    if (_tabController.index == 0) {
      bottomBar = txAsync.maybeWhen(
        data: (transactions) {
          if (transactions.isEmpty) return const SizedBox.shrink();
          final statement = calculateCardStatement(widget.card, transactions);
          return Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: MediaQuery.of(context).padding.bottom > 0 ? MediaQuery.of(context).padding.bottom : 20),
            decoration: const BoxDecoration(
              color: Color(0xFF1C273B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('A Pagar (Corte Anterior)', style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 11)),
                      const SizedBox(height: 4),
                      Text('\$${statement.previousCutoffDue.toStringAsFixed(2)}', style: TextStyle(color: statement.previousCutoffDue > 0 ? const Color(0xFFE94057) : const Color(0xFF00E676), fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Acumulado (Mes Actual)', style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 11)),
                      const SizedBox(height: 4),
                      Text('\$${statement.currentCutoffAccumulated.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        orElse: () => const SizedBox.shrink(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card.alias),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFE94057)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: const Color(0xFF1C273B),
                  title: const Text('¿Eliminar tarjeta?', style: TextStyle(color: Colors.white)),
                  content: const Text('Se eliminarán también todos sus movimientos y suscripciones. Esta acción no se puede deshacer.', style: TextStyle(color: Colors.white70)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
                    ),
                    TextButton(
                      onPressed: () async {
                        final repo = ref.read(cardsRepositoryProvider);
                        await repo.deleteCard(widget.card.id);
                        if (mounted) {
                          Navigator.pop(ctx); // pop dialog
                          Navigator.pop(context); // pop detail screen
                          ref.invalidate(cardsProvider);
                          ref.invalidate(cardSummariesProvider);
                          ref.invalidate(upcomingEventsProvider);
                        }
                      },
                      child: const Text('Eliminar', style: TextStyle(color: Color(0xFFE94057))),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00E676),
          labelColor: const Color(0xFF00E676),
          unselectedLabelColor: const Color(0xFF8E9BB0),
          tabs: const [
            Tab(text: 'Movimientos'),
            Tab(text: 'Suscripciones'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTransactionsTab(),
          _buildSubscriptionsTab(),
        ],
      ),
      bottomNavigationBar: bottomBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            showModalBottomSheet(
              context: context,
              backgroundColor: const Color(0xFF161F33),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              builder: (ctx) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined, color: Color(0xFFE94057)),
                    title: const Text('Agregar Compra', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(ctx);
                      _showAddTransactionModal(true);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.payments_outlined, color: Color(0xFF00E676)),
                    title: const Text('Agregar Pago', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(ctx);
                      _handlePayAction();
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          } else {
            _showAddSubscriptionModal();
          }
        },
        backgroundColor: const Color(0xFFD6E4FF),
        child: const Icon(Icons.add, color: Color(0xFF161F33)),
      ),
    );
  }

  // Removed _getCutoffsPassed to use from card_calculations.dart

  void _showTransactionDetailsModal(CardTransaction tx) {
    final isPurchase = tx.type == TransactionType.purchase;
    final now = DateTime.now();
    int monthsPassed = 0;
    if (isPurchase && tx.installments > 1) {
      monthsPassed = getCutoffsPassed(tx.date, now, widget.card.cutoffDay);
    }
    int currentMonth = monthsPassed + 1;
    if (currentMonth > tx.installments) currentMonth = tx.installments;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161F33),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (isPurchase ? const Color(0xFFE94057) : const Color(0xFF00E676)).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPurchase ? Icons.shopping_bag_outlined : Icons.payments_outlined,
                      color: isPurchase ? const Color(0xFFE94057) : const Color(0xFF00E676),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tx.concept, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(DateFormat('dd MMMM yyyy', 'es_ES').format(tx.date), style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildDetailRow('Tipo', isPurchase ? 'Compra' : 'Pago'),
              const SizedBox(height: 15),
              _buildDetailRow('Monto Total', '\$${tx.amount.toStringAsFixed(2)}'),
              if (isPurchase && tx.installments > 1) ...[
                const SizedBox(height: 15),
                _buildDetailRow('Meses Sin Intereses', '${tx.installments} meses'),
                const SizedBox(height: 15),
                _buildDetailRow('Progreso', 'Mes $currentMonth de ${tx.installments}'),
                const SizedBox(height: 15),
                _buildDetailRow('Pago Mensual', '\$${(tx.amount / tx.installments).toStringAsFixed(2)}', valueColor: const Color(0xFFE94057)),
              ],
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE94057)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () async {
                        final repo = ref.read(cardsRepositoryProvider);
                        await repo.softDeleteTransaction(tx.id);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ref.invalidate(cardTransactionsProvider(widget.card.id));
                          ref.invalidate(cardSummariesProvider); // To refresh dashboard
                        }
                      },
                      child: const Text('Eliminar', style: TextStyle(color: Color(0xFFE94057), fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E676),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar', style: TextStyle(color: Color(0xFF161F33), fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {Color valueColor = Colors.white}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 14)),
        Text(value, style: TextStyle(color: valueColor, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTransactionsTab() {
    final txAsync = ref.watch(cardTransactionsProvider(widget.card.id));
    
    return txAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return Center(
            child: Text('Aún no hay movimientos', style: TextStyle(color: const Color(0xFF8E9BB0).withOpacity(0.5))),
          );
        }

        final now = DateTime.now();
        
        // Sort transactions descending by date
        final sortedTx = List<CardTransaction>.from(transactions)
          ..sort((a, b) => b.date.compareTo(a.date));

        // Group by cycle end date
        final Map<DateTime, List<Map<String, dynamic>>> groupedTx = {};
        for (var tx in sortedTx) {
          final isPurchase = tx.type == TransactionType.purchase;
          
          if (isPurchase && tx.installments > 1) {
            DateTime currentCycle = getCycleEndDate(tx.date, widget.card.cutoffDay, deferredCycles: tx.deferredCycles);
            
            for (int i = 0; i < tx.installments; i++) {
              if (!groupedTx.containsKey(currentCycle)) {
                groupedTx[currentCycle] = [];
              }
              groupedTx[currentCycle]!.add({
                'tx': tx,
                'displayMonth': i + 1,
              });
              
              int nextMonth = currentCycle.month == 12 ? 1 : currentCycle.month + 1;
              int nextYear = currentCycle.month == 12 ? currentCycle.year + 1 : currentCycle.year;
              currentCycle = DateTime(nextYear, nextMonth, widget.card.cutoffDay);
            }
          } else {
            final cycleDate = getCycleEndDate(tx.date, widget.card.cutoffDay, deferredCycles: tx.deferredCycles);
            if (!groupedTx.containsKey(cycleDate)) {
              groupedTx[cycleDate] = [];
            }
            groupedTx[cycleDate]!.add({
              'tx': tx,
              'displayMonth': 1,
            });
          }
        }

        // Flatten for ListView
        final List<dynamic> listItems = [];
        final currentGlobalCycle = getCycleEndDate(now, widget.card.cutoffDay);
        
        final sortedCycleDates = groupedTx.keys
          .where((date) => date.isBefore(currentGlobalCycle) || date.isAtSameMomentAs(currentGlobalCycle))
          .toList()
          ..sort((a, b) => b.compareTo(a));

        for (var cycleDate in sortedCycleDates) {
          // Only show cycles up to the current one, plus maybe future ones if they have MSI
          // Actually, showing future cycles is correct because they will have future MSI payments!
          listItems.add(cycleDate); // Header
          listItems.addAll(groupedTx[cycleDate]!);
        }

        return Column(
          children: [
            if (transactions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isMultiSelectMode = !_isMultiSelectMode;
                          _selectedTxIds.clear();
                        });
                      },
                      icon: Icon(_isMultiSelectMode ? Icons.close : Icons.checklist, color: const Color(0xFF00B0FF)),
                      label: Text(_isMultiSelectMode ? 'Cancelar' : 'Seleccionar', style: const TextStyle(color: Color(0xFF00B0FF))),
                    ),
                    if (_isMultiSelectMode)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE94057),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _selectedTxIds.isEmpty ? null : () async {
                           final repo = ref.read(cardsRepositoryProvider);
                           await repo.deferTransactions(_selectedTxIds.toList(), 1); // 1 = jump 1 cycle forward
                           if (mounted) {
                             setState(() {
                               _isMultiSelectMode = false;
                               _selectedTxIds.clear();
                             });
                             ref.invalidate(cardTransactionsProvider(widget.card.id));
                             ref.invalidate(cardSummariesProvider);
                           }
                        },
                        icon: const Icon(Icons.skip_next, color: Colors.white, size: 16),
                        label: Text('Posponer (${_selectedTxIds.length})', style: const TextStyle(color: Colors.white)),
                      ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 80),
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  final item = listItems[index];

                  if (item is DateTime) {
                    // Header
                    final cycleTxs = groupedTx[item]!;
                    double cycleTotal = 0;
                    for (var mapItem in cycleTxs) {
                      final tx = mapItem['tx'] as CardTransaction;
                      if (tx.type != TransactionType.payment) {
                         if (tx.installments > 1) {
                           cycleTotal += tx.amount / tx.installments;
                         } else {
                           cycleTotal += tx.amount;
                         }
                      }
                    }
                    final isCurrentCycle = getCycleEndDate(now, widget.card.cutoffDay) == item;
                    final headerTitle = isCurrentCycle 
                      ? 'Corte Actual (cierra el ${DateFormat('dd MMM', 'es_ES').format(item)})' 
                      : 'Corte: ${DateFormat('dd MMM yyyy', 'es_ES').format(item)}';

                    return Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A3650),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(headerTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                          if (!isCurrentCycle && cycleTotal > 0)
                            GestureDetector(
                              onTap: () {
                                _handleQuickPayCycle(cycleTotal, headerTitle);
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 12.0),
                                child: Icon(Icons.check_circle_outline, color: Color(0xFF00E676), size: 20),
                              ),
                            ),
                          Text('\$${cycleTotal.toStringAsFixed(2)}', style: TextStyle(color: cycleTotal > 0 ? const Color(0xFFE94057) : const Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    );
                  }

                  final mapItem = item as Map<String, dynamic>;
                  final tx = mapItem['tx'] as CardTransaction;
                  final currentMonth = mapItem['displayMonth'] as int;
                  
                  final isPurchase = tx.type == TransactionType.purchase || tx.type == TransactionType.subscriptionCharge;
                  final isSubscription = tx.type == TransactionType.subscriptionCharge;

                  return ListTile(
                    onTap: _isMultiSelectMode 
                        ? () {
                            setState(() {
                              if (_selectedTxIds.contains(tx.id)) {
                                _selectedTxIds.remove(tx.id);
                              } else {
                                _selectedTxIds.add(tx.id);
                              }
                            });
                          }
                        : () => _showTransactionDetailsModal(tx),
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isMultiSelectMode)
                          Checkbox(
                            value: _selectedTxIds.contains(tx.id),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) _selectedTxIds.add(tx.id);
                                else _selectedTxIds.remove(tx.id);
                              });
                            },
                            activeColor: const Color(0xFF00E676),
                          ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (isPurchase ? const Color(0xFFE94057) : const Color(0xFF00E676)).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isSubscription ? Icons.autorenew : (isPurchase ? Icons.shopping_bag_outlined : Icons.payments_outlined),
                            color: isPurchase ? const Color(0xFFE94057) : const Color(0xFF00E676),
                          ),
                        ),
                      ],
                    ),
                    title: Text(tx.concept, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Fecha: ${DateFormat('dd MMM yyyy', 'es_ES').format(tx.date)}${tx.installments > 1 ? ' • Compra a ${tx.installments} MSI' : (isSubscription ? ' • Suscripción' : '')}',
                          style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 12),
                        ),
                        if (isPurchase && tx.installments > 1) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Pago Mensual: \$${(tx.amount / tx.installments).toStringAsFixed(2)} (Mes $currentMonth de ${tx.installments})',
                            style: const TextStyle(color: Color(0xFFE94057), fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                        if (tx.deferredCycles > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              'Pospuesto ${tx.deferredCycles} corte(s)',
                              style: const TextStyle(color: Color(0xFF00B0FF), fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    trailing: Text(
                      '${isPurchase ? '-' : '+'}\$${tx.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isPurchase ? Colors.white70 : const Color(0xFF00E676),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildSubscriptionsTab() {
    final subAsync = ref.watch(cardSubscriptionsProvider(widget.card.id));
    
    return subAsync.when(
      data: (subscriptions) {
        if (subscriptions.isEmpty) {
          return Center(
            child: Text('Aún no hay suscripciones', style: TextStyle(color: const Color(0xFF8E9BB0).withOpacity(0.5))),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: subscriptions.length,
          separatorBuilder: (c, i) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            final sub = subscriptions[index];
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color(0xFF161F33),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                  builder: (ctx) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Text(sub.serviceName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      ListTile(
                        leading: const Icon(Icons.delete_outline, color: Color(0xFFE94057)),
                        title: const Text('Eliminar Suscripción', style: TextStyle(color: Color(0xFFE94057))),
                        onTap: () async {
                          final repo = ref.read(cardsRepositoryProvider);
                          await repo.softDeleteSubscription(sub.id);
                          if (mounted) {
                            Navigator.pop(ctx);
                            ref.invalidate(cardSubscriptionsProvider(widget.card.id));
                            ref.invalidate(upcomingEventsProvider); // To refresh dashboard
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF161F33),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B8BFF).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.subscriptions_outlined, color: Color(0xFF6B8BFF)),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sub.serviceName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text('Día de cobro: ${sub.billingDay}', style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(
                      '\$${sub.amount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }
}
