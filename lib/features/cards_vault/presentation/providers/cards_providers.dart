import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../../data/repository/cards_repository.dart';
import '../../domain/credit_card.dart';
import '../../domain/card_transaction.dart';
import '../../domain/card_subscription.dart';

// Repository provider
final cardsRepositoryProvider = Provider<CardsRepository>((ref) {
  return CardsRepository(isar);
});

// All cards
final cardsProvider = FutureProvider<List<CreditCard>>((ref) async {
  final repo = ref.watch(cardsRepositoryProvider);
  return await repo.getCards();
});

// Transactions for a specific card
final cardTransactionsProvider = FutureProvider.family<List<CardTransaction>, int>((ref, cardId) async {
  final repo = ref.watch(cardsRepositoryProvider);
  return await repo.getTransactionsForCard(cardId);
});

// Subscriptions for a specific card
final cardSubscriptionsProvider = FutureProvider.family<List<CardSubscription>, int>((ref, cardId) async {
  final repo = ref.watch(cardsRepositoryProvider);
  return await repo.getSubscriptionsForCard(cardId);
});
