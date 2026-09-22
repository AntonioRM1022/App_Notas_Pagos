import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cards_providers.dart';
import '../../domain/credit_card.dart';

class CardsScreen extends ConsumerStatefulWidget {
  const CardsScreen({super.key});

  @override
  ConsumerState<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends ConsumerState<CardsScreen> {
  final _aliasController = TextEditingController();
  final _cutoffController = TextEditingController();
  final _paymentDayController = TextEditingController();

  @override
  void dispose() {
    _aliasController.dispose();
    _cutoffController.dispose();
    _paymentDayController.dispose();
    super.dispose();
  }

  void _showAddCardModal() {
    _aliasController.clear();
    _cutoffController.clear();
    _paymentDayController.clear();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161F33),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
              const Text('Agregar Tarjeta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),
              TextField(
                controller: _aliasController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nombre de la tarjeta (Alias)',
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
                      controller: _cutoffController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Día de Corte (1-31)',
                        labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: _paymentDayController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Día de Pago (1-31)',
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
                    if (_aliasController.text.isNotEmpty && 
                        _cutoffController.text.isNotEmpty && 
                        _paymentDayController.text.isNotEmpty) {
                      final newCard = CreditCard()
                        ..alias = _aliasController.text
                        ..cutoffDay = int.tryParse(_cutoffController.text) ?? 1
                        ..paymentLimitDay = int.tryParse(_paymentDayController.text) ?? 1;

                      final repo = ref.read(cardsRepositoryProvider);
                      await repo.addCard(newCard);
                      
                      if (mounted) {
                        Navigator.pop(context);
                        ref.invalidate(cardsProvider);
                      }
                    }
                  },
                  child: const Text('GUARDAR TARJETA', style: TextStyle(color: Color(0xFF161F33), fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(cardsProvider);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
          child: CircleAvatar(
            backgroundColor: Colors.grey[800],
            backgroundImage: const AssetImage('assets/images/profile.jpg'),
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
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Virtual Cards',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Manage your digital credit securely.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8E9BB0),
                  ),
                ),
                const SizedBox(height: 30),
                
                cardsAsync.when(
                  data: (cards) {
                    if (cards.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            Icon(Icons.credit_card_off_outlined, size: 50, color: const Color(0xFF8E9BB0).withOpacity(0.5)),
                            const SizedBox(height: 15),
                            const Text(
                              'Aún no hay tarjetas',
                              style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Usa el botón + para agregar una',
                              style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cards.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        return GestureDetector(
                          onTap: () => context.push('/cards/detail', extra: card),
                          child: _buildCardItem(
                            title: card.alias,
                            number: '**** **** **** 1234', // Dummy number since we don't store it
                            isActive: true,
                            statementClose: 'Día ${card.cutoffDay}',
                            paymentDue: 'Día ${card.paymentLimitDay}',
                            icon: Icons.credit_card,
                            iconColor: const Color(0xFF6B8BFF),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
                
                const SizedBox(height: 80), // Padding for FAB
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _showAddCardModal,
              backgroundColor: const Color(0xFFD6E4FF),
              child: const Icon(Icons.add, color: Color(0xFF161F33)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem({
    required String title,
    required String number,
    required bool isActive,
    required String statementClose,
    required String paymentDue,
    required IconData icon,
    required Color iconColor,
  }) {
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF00E676).withOpacity(0.1) : const Color(0xFFE94057).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF00E676) : const Color(0xFFE94057),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isActive ? 'Active' : 'Locked',
                      style: TextStyle(
                        fontSize: 10,
                        color: isActive ? const Color(0xFF00E676) : const Color(0xFFE94057),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            number,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('STATEMENT CLOSE', style: TextStyle(fontSize: 9, color: Color(0xFF8E9BB0), letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(statementClose, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('PAYMENT DUE', style: TextStyle(fontSize: 9, color: Color(0xFF8E9BB0), letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(
                    paymentDue,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF00E676), // Teal for due date
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
