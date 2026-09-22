import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../cards_vault/presentation/providers/cards_providers.dart';
import '../../../cards_vault/domain/card_transaction.dart';
import '../../../cards_vault/domain/card_subscription.dart';
import '../../../important_dates/domain/love_note.dart';
import '../../../important_dates/domain/personal_note.dart';
import '../../../important_dates/presentation/providers/notes_providers.dart';
import '../../presentation/providers/dashboard_providers.dart';

// Providers specifically for recycle bin items
final deletedTransactionsProvider = FutureProvider<List<CardTransaction>>((ref) async {
  final repo = ref.watch(cardsRepositoryProvider);
  return repo.getDeletedTransactions();
});

final deletedSubscriptionsProvider = FutureProvider<List<CardSubscription>>((ref) async {
  final repo = ref.watch(cardsRepositoryProvider);
  return repo.getDeletedSubscriptions();
});

final deletedLoveNotesProvider = FutureProvider<List<LoveNote>>((ref) async {
  final repo = ref.watch(notesRepositoryProvider);
  return repo.getDeletedLoveNotes();
});

final deletedPersonalNotesProvider = FutureProvider<List<PersonalNote>>((ref) async {
  final repo = ref.watch(notesRepositoryProvider);
  return repo.getDeletedPersonalNotes();
});

class RecycleBinScreen extends ConsumerWidget {
  const RecycleBinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletedTxsAsync = ref.watch(deletedTransactionsProvider);
    final deletedSubsAsync = ref.watch(deletedSubscriptionsProvider);
    final deletedLoveNotesAsync = ref.watch(deletedLoveNotesProvider);
    final deletedPersonalNotesAsync = ref.watch(deletedPersonalNotesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Papelera de Reciclaje'),
        backgroundColor: const Color(0xFF1C273B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Movimientos Eliminados', Icons.delete_outline, const Color(0xFFE94057)),
            deletedTxsAsync.when(
              data: (txs) {
                if (txs.isEmpty) return _buildEmptyState('No hay movimientos eliminados');
                return Column(
                  children: txs.map((tx) => _buildTransactionItem(context, ref, tx)).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text('Error: $e', style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),
            
            _buildSectionTitle('Suscripciones Eliminadas', Icons.subscriptions_outlined, const Color(0xFF6B8BFF)),
            deletedSubsAsync.when(
              data: (subs) {
                if (subs.isEmpty) return _buildEmptyState('No hay suscripciones eliminadas');
                return Column(
                  children: subs.map((sub) => _buildSubscriptionItem(context, ref, sub)).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text('Error: $e', style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),

            _buildSectionTitle('Notas de Amor Eliminadas', Icons.favorite_border, const Color(0xFFE94057)),
            deletedLoveNotesAsync.when(
              data: (notes) {
                if (notes.isEmpty) return _buildEmptyState('No hay notas de amor eliminadas');
                return Column(
                  children: notes.map((note) => _buildLoveNoteItem(context, ref, note)).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text('Error: $e', style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),

            _buildSectionTitle('Notas Personales Eliminadas', Icons.event_note_outlined, const Color(0xFF00E676)),
            deletedPersonalNotesAsync.when(
              data: (notes) {
                if (notes.isEmpty) return _buildEmptyState('No hay notas personales eliminadas');
                return Column(
                  children: notes.map((note) => _buildPersonalNoteItem(context, ref, note)).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text('Error: $e', style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(color: const Color(0xFF8E9BB0).withOpacity(0.5)),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildRestoreRow(Widget child, VoidCallback onRestore) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(child: child),
          IconButton(
            icon: const Icon(Icons.restore, color: Color(0xFF00E676)),
            onPressed: onRestore,
            tooltip: 'Restaurar',
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, WidgetRef ref, CardTransaction tx) {
    return _buildRestoreRow(
      ListTile(
        title: Text(tx.concept, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(DateFormat('dd MMM yyyy', 'es_ES').format(tx.date), style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 12)),
        trailing: Text('\$${tx.amount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70)),
      ),
      () async {
        final repo = ref.read(cardsRepositoryProvider);
        await repo.restoreTransaction(tx.id);
        ref.invalidate(deletedTransactionsProvider);
        ref.invalidate(cardTransactionsProvider);
        ref.invalidate(cardSummariesProvider);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Movimiento restaurado')));
      }
    );
  }

  Widget _buildSubscriptionItem(BuildContext context, WidgetRef ref, CardSubscription sub) {
    return _buildRestoreRow(
      ListTile(
        title: Text(sub.serviceName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('Día de cobro: ${sub.billingDay}', style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 12)),
        trailing: Text('\$${sub.amount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70)),
      ),
      () async {
        final repo = ref.read(cardsRepositoryProvider);
        await repo.restoreSubscription(sub.id);
        ref.invalidate(deletedSubscriptionsProvider);
        ref.invalidate(cardSubscriptionsProvider);
        ref.invalidate(upcomingEventsProvider);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Suscripción restaurada')));
      }
    );
  }

  Widget _buildLoveNoteItem(BuildContext context, WidgetRef ref, LoveNote note) {
    return _buildRestoreRow(
      ListTile(
        title: Text(note.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(DateFormat('dd MMM yyyy', 'es_ES').format(note.date), style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 12)),
      ),
      () async {
        final repo = ref.read(notesRepositoryProvider);
        await repo.restoreLoveNote(note.id);
        ref.invalidate(deletedLoveNotesProvider);
        ref.invalidate(loveNotesProvider);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nota de amor restaurada')));
      }
    );
  }

  Widget _buildPersonalNoteItem(BuildContext context, WidgetRef ref, PersonalNote note) {
    return _buildRestoreRow(
      ListTile(
        title: Text(note.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(note.category, style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 12)),
      ),
      () async {
        final repo = ref.read(notesRepositoryProvider);
        await repo.restorePersonalNote(note.id);
        ref.invalidate(deletedPersonalNotesProvider);
        ref.invalidate(personalNotesProvider);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nota personal restaurada')));
      }
    );
  }
}
