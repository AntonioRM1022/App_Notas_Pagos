import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/loan_record.dart';
import '../providers/loans_providers.dart';

class LoansScreen extends ConsumerStatefulWidget {
  const LoansScreen({super.key});

  @override
  ConsumerState<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends ConsumerState<LoansScreen> {
  String _selectedFilter = 'Todos'; // 'Todos', 'Me deben', 'Debo', 'Liquidados'
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final loansAsync = ref.watch(loansListProvider);
    final summaryAsync = ref.watch(loansSummaryProvider);
    final currencyFormatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    return Scaffold(
      backgroundColor: const Color(0xFF10141D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF10141D),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cuentas Claras', style: TextStyle(fontSize: 12, color: Color(0xFF8E9BB0))),
            Text('Préstamos & Deudas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Color(0xFF00E676), size: 28),
            onPressed: () => _showAddLoanModal(context),
            tooltip: 'Nuevo Préstamo',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(loansListProvider);
          ref.invalidate(loansSummaryProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resumen financiero superior
              summaryAsync.when(
                data: (summary) => _buildSummaryHeader(summary, currencyFormatter),
                loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 20),

              // Barra de búsqueda y filtros
              _buildSearchBar(),
              const SizedBox(height: 14),
              _buildFilterChips(),
              const SizedBox(height: 16),

              // Lista de préstamos
              loansAsync.when(
                data: (loans) {
                  final filtered = loans.where((loan) {
                    // Filtro de categoría
                    if (_selectedFilter == 'Me deben' && (loan.type != LoanType.lent || loan.isSettled)) return false;
                    if (_selectedFilter == 'Debo' && (loan.type != LoanType.borrowed || loan.isSettled)) return false;
                    if (_selectedFilter == 'Liquidados' && !loan.isSettled) return false;
                    if (_selectedFilter == 'Todos' && loan.isSettled) return false; // Por defecto no mezclar los ya pagados en "Todos"

                    // Filtro de búsqueda
                    if (_searchQuery.isNotEmpty) {
                      final q = _searchQuery.toLowerCase();
                      final matchesPerson = loan.personName.toLowerCase().contains(q);
                      final matchesConcept = loan.concept.toLowerCase().contains(q);
                      if (!matchesPerson && !matchesConcept) return false;
                    }
                    return true;
                  }).toList();

                  if (filtered.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildLoanCard(filtered[index], currencyFormatter);
                    },
                  );
                },
                loading: () => const Center(child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                )),
                error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white70))),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddLoanModal(context),
        backgroundColor: const Color(0xFF00E676),
        icon: const Icon(Icons.add, color: Color(0xFF10141D)),
        label: const Text('REGISTRAR PRÉSTAMO', style: TextStyle(color: Color(0xFF10141D), fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSummaryHeader(LoansSummary summary, NumberFormat formatter) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A3650), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  title: 'Me Deben',
                  amount: summary.totalToReceive,
                  color: const Color(0xFF00E676),
                  icon: Icons.south_west_rounded,
                  formatter: formatter,
                ),
              ),
              Container(width: 1, height: 45, color: const Color(0xFF2A3650)),
              Expanded(
                child: _buildSummaryItem(
                  title: 'Yo Debo',
                  amount: summary.totalToPay,
                  color: const Color(0xFFE94057),
                  icon: Icons.north_east_rounded,
                  formatter: formatter,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF10141D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.account_balance_wallet_outlined, size: 16, color: Color(0xFF00B0FF)),
                    SizedBox(width: 8),
                    Text('Balance Neto a Favor:', style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 12)),
                  ],
                ),
                Text(
                  formatter.format(summary.netBalance),
                  style: TextStyle(
                    color: summary.netBalance >= 0 ? const Color(0xFF00E676) : const Color(0xFFE94057),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
    required NumberFormat formatter,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF8E9BB0), fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            formatter.format(amount),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A3650)),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar por persona o concepto...',
          hintStyle: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF8E9BB0), size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Color(0xFF8E9BB0), size: 18),
                  onPressed: () => setState(() => _searchQuery = ''),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (val) => setState(() => _searchQuery = val),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Todos', 'Me deben', 'Debo', 'Liquidados'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(f),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedFilter = f),
              selectedColor: const Color(0xFF00E676),
              backgroundColor: const Color(0xFF161F33),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF10141D) : const Color(0xFF8E9BB0),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              side: BorderSide(
                color: isSelected ? const Color(0xFF00E676) : const Color(0xFF2A3650),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLoanCard(LoanRecord loan, NumberFormat formatter) {
    final isLent = loan.type == LoanType.lent;
    final primaryColor = isLent ? const Color(0xFF00E676) : const Color(0xFFE94057);
    final dateStr = DateFormat('dd MMM yyyy', 'es_ES').format(loan.date);
    final paidAmount = loan.originalAmount - loan.remainingAmount;
    final progress = loan.originalAmount > 0 ? (paidAmount / loan.originalAmount) : 0.0;

    return InkWell(
      onTap: () => _showLoanDetailModal(context, loan, formatter),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF161F33),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: loan.isSettled ? const Color(0xFF2A3650) : primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar con inicial
                CircleAvatar(
                  radius: 22,
                  backgroundColor: primaryColor.withOpacity(0.15),
                  child: Text(
                    loan.personName.isNotEmpty ? loan.personName[0].toUpperCase() : '?',
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loan.personName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        loan.concept,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF8E9BB0)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: primaryColor.withOpacity(0.8)),
                          const SizedBox(width: 4),
                          Text(
                            dateStr,
                            style: TextStyle(fontSize: 11, color: primaryColor.withOpacity(0.8), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      loan.isSettled ? formatter.format(loan.originalAmount) : formatter.format(loan.remainingAmount),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: loan.isSettled ? const Color(0xFF8E9BB0) : primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: loan.isSettled
                            ? const Color(0xFF2A3650)
                            : (isLent ? const Color(0xFF00E676).withOpacity(0.15) : const Color(0xFFE94057).withOpacity(0.15)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        loan.isSettled
                            ? 'LIQUIDADO'
                            : (isLent ? 'ME DEBE' : 'DEBO'),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: loan.isSettled
                              ? const Color(0xFF8E9BB0)
                              : primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Barra de abonos si se ha pagado una parte
            if (!loan.isSettled && paidAmount > 0) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: const Color(0xFF10141D),
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Abonado: ${formatter.format(paidAmount)}', style: const TextStyle(fontSize: 11, color: Color(0xFF8E9BB0))),
                  Text('Total: ${formatter.format(loan.originalAmount)}', style: const TextStyle(fontSize: 11, color: Color(0xFF8E9BB0))),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.handshake_outlined, size: 64, color: const Color(0xFF2A3650)),
            const SizedBox(height: 16),
            const Text(
              'No hay registros que coincidan',
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              'Registra a quién le prestas o quién te prestó para no perder la pista.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF8E9BB0)),
            ),
          ],
        ),
      ),
    );
  }

  // Modal para agregar nuevo préstamo
  void _showAddLoanModal(BuildContext context) {
    final personController = TextEditingController();
    final amountController = TextEditingController();
    final conceptController = TextEditingController();
    LoanType selectedType = LoanType.lent; // Default: Yo presté (me deben)
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161F33),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20, right: 20, top: 20,
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
                    const SizedBox(height: 15),
                    const Text('Registrar Préstamo o Deuda', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 18),

                    // Selector de tipo
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10141D),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setStateModal(() => selectedType = LoanType.lent),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: selectedType == LoanType.lent ? const Color(0xFF00E676) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Yo Presté (Me deben)',
                                    style: TextStyle(
                                      color: selectedType == LoanType.lent ? const Color(0xFF10141D) : const Color(0xFF8E9BB0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setStateModal(() => selectedType = LoanType.borrowed),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: selectedType == LoanType.borrowed ? const Color(0xFFE94057) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Me Prestaron (Debo)',
                                    style: TextStyle(
                                      color: selectedType == LoanType.borrowed ? Colors.white : const Color(0xFF8E9BB0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Nombre de la persona
                    TextField(
                      controller: personController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Persona (ej. Mamá, Hermano, Carlos)',
                        labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                        prefixIcon: Icon(Icons.person_outline, color: Color(0xFF8E9BB0)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Monto
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Monto (\$)',
                        labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                        prefixIcon: Icon(Icons.attach_money, color: Color(0xFF8E9BB0)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Fecha del préstamo
                    TextField(
                      readOnly: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Fecha del Préstamo',
                        labelStyle: const TextStyle(color: Color(0xFF8E9BB0)),
                        prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF8E9BB0)),
                        hintText: DateFormat('dd MMM yyyy', 'es_ES').format(selectedDate),
                        hintStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: Color(0xFF00E676),
                                  onPrimary: Color(0xFF10141D),
                                  surface: Color(0xFF161F33),
                                  onSurface: Colors.white,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setStateModal(() => selectedDate = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // Concepto / Motivo
                    TextField(
                      controller: conceptController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Concepto / Motivo (ej. Para la luz, Salida al cine)',
                        labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                        prefixIcon: Icon(Icons.notes, color: Color(0xFF8E9BB0)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                      ),
                    ),
                    const SizedBox(height: 26),

                    // Botón Guardar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedType == LoanType.lent ? const Color(0xFF00E676) : const Color(0xFFE94057),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () async {
                          final name = personController.text.trim();
                          final amount = double.tryParse(amountController.text) ?? 0.0;
                          final concept = conceptController.text.trim();

                          if (name.isEmpty || amount <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Por favor completa el nombre y un monto válido')),
                            );
                            return;
                          }

                          final loan = LoanRecord()
                            ..personName = name
                            ..originalAmount = amount
                            ..remainingAmount = amount
                            ..date = selectedDate
                            ..concept = concept.isEmpty ? 'Préstamo' : concept
                            ..type = selectedType;

                          final repo = ref.read(loansRepositoryProvider);
                          await repo.addLoan(loan);

                          if (context.mounted) {
                            Navigator.pop(ctx);
                            ref.invalidate(loansListProvider);
                            ref.invalidate(loansSummaryProvider);
                          }
                        },
                        child: Text(
                          selectedType == LoanType.lent ? 'GUARDAR COMO ME DEBEN' : 'GUARDAR COMO YO DEBO',
                          style: TextStyle(
                            color: selectedType == LoanType.lent ? const Color(0xFF10141D) : Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Modal para ver detalle, registrar abonos y liquidar
  void _showLoanDetailModal(BuildContext context, LoanRecord loan, NumberFormat formatter) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161F33),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        final isLent = loan.type == LoanType.lent;
        final primaryColor = isLent ? const Color(0xFF00E676) : const Color(0xFFE94057);

        return Padding(
          padding: const EdgeInsets.all(22.0),
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
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loan.personName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(loan.concept, style: const TextStyle(fontSize: 14, color: Color(0xFF8E9BB0))),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      isLent ? 'Yo Presté' : 'Me Prestaron',
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Detalles numéricos
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF10141D),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Monto Original:', style: TextStyle(color: Color(0xFF8E9BB0))),
                        Text(formatter.format(loan.originalAmount), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Saldo Restante:', style: TextStyle(color: Color(0xFF8E9BB0))),
                        Text(
                          formatter.format(loan.remainingAmount),
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Fecha del Préstamo:', style: TextStyle(color: Color(0xFF8E9BB0))),
                        Text(DateFormat('dd MMMM yyyy', 'es_ES').format(loan.date), style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),

              // Historial de abonos
              if (loan.payments.isNotEmpty) ...[
                const SizedBox(height: 18),
                const Text('Historial de Abonos / Pagos', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                ...loan.payments.map((p) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${DateFormat('dd MMM yyyy', 'es_ES').format(p.date)}${p.notes != null ? ' - ${p.notes}' : ''}',
                        style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 12),
                      ),
                      Text(formatter.format(p.amount), style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                )),
              ],

              const SizedBox(height: 24),

              // Botones de acción
              if (!loan.isSettled) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF00E676)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showAddPaymentDialog(context, loan, formatter);
                        },
                        icon: const Icon(Icons.payments_outlined, color: Color(0xFF00E676)),
                        label: const Text('ABONAR', style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00E676),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          final repo = ref.read(loansRepositoryProvider);
                          await repo.settleLoanFully(loan.id);
                          if (context.mounted) {
                            Navigator.pop(ctx);
                            ref.invalidate(loansListProvider);
                            ref.invalidate(loansSummaryProvider);
                          }
                        },
                        icon: const Icon(Icons.check_circle_outline, color: Color(0xFF10141D)),
                        label: const Text('LIQUIDAR TODO', style: TextStyle(color: Color(0xFF10141D), fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // Botón eliminar
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () async {
                    final repo = ref.read(loansRepositoryProvider);
                    await repo.softDeleteLoan(loan.id);
                    if (context.mounted) {
                      Navigator.pop(ctx);
                      ref.invalidate(loansListProvider);
                      ref.invalidate(loansSummaryProvider);
                    }
                  },
                  icon: const Icon(Icons.delete_outline, color: Color(0xFFE94057), size: 20),
                  label: const Text('Mover a Papelera de Reciclaje', style: TextStyle(color: Color(0xFFE94057))),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Diálogo para registrar un abono parcial
  void _showAddPaymentDialog(BuildContext context, LoanRecord loan, NumberFormat formatter) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF161F33),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Abonar a ${loan.personName}', style: const TextStyle(color: Colors.white, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Saldo pendiente: ${formatter.format(loan.remainingAmount)}',
                style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 13),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Monto del abono (\$)',
                  labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noteController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nota (opcional, ej. Transferencia)',
                  labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar', style: TextStyle(color: Color(0xFF8E9BB0))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
              onPressed: () async {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount <= 0) return;

                final repo = ref.read(loansRepositoryProvider);
                await repo.recordPayment(loan.id, amount, notes: noteController.text.trim());

                if (context.mounted) {
                  Navigator.pop(ctx);
                  ref.invalidate(loansListProvider);
                  ref.invalidate(loansSummaryProvider);
                }
              },
              child: const Text('GUARDAR ABONO', style: TextStyle(color: Color(0xFF10141D), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
