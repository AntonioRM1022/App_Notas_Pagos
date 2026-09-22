import 'package:isar/isar.dart';
import '../../domain/credit_card.dart';
import '../../domain/card_transaction.dart';
import '../../domain/card_subscription.dart';

class CardsRepository {
  final Isar isar;

  CardsRepository(this.isar);

  // === Credit Cards ===

  Future<List<CreditCard>> getCards() async {
    return await isar.creditCards.where().findAll();
  }

  Future<CreditCard?> getCardById(int id) async {
    return await isar.creditCards.get(id);
  }

  Future<void> addCard(CreditCard card) async {
    await isar.writeTxn(() async {
      await isar.creditCards.put(card);
    });
  }

  Future<void> deleteCard(int id) async {
    final card = await getCardById(id);
    if (card != null) {
      await isar.writeTxn(() async {
        await card.transactions.load();
        await card.subscriptions.load();
        
        for (var tx in card.transactions) {
          await isar.cardTransactions.delete(tx.id);
        }
        for (var sub in card.subscriptions) {
          await isar.cardSubscriptions.delete(sub.id);
        }
        
        await isar.creditCards.delete(id);
      });
    }
  }

  // === Transactions ===

  Future<List<CardTransaction>> getTransactionsForCard(int cardId) async {
    final card = await getCardById(cardId);
    if (card == null) return [];
    
    // As IsarLinks are loaded synchronously when fetched, but to be sure we load them
    await card.transactions.load();
    return card.transactions.where((tx) => !tx.isDeleted).toList();
  }

  Future<void> softDeleteTransaction(int txId) async {
    final tx = await isar.cardTransactions.get(txId);
    if (tx != null) {
      await isar.writeTxn(() async {
        tx.isDeleted = true;
        await isar.cardTransactions.put(tx);
      });
    }
  }

  Future<List<CardTransaction>> getDeletedTransactions() async {
    return await isar.cardTransactions.where().filter().isDeletedEqualTo(true).findAll();
  }

  Future<void> restoreTransaction(int txId) async {
    final tx = await isar.cardTransactions.get(txId);
    if (tx != null) {
      await isar.writeTxn(() async {
        tx.isDeleted = false;
        await isar.cardTransactions.put(tx);
      });
    }
  }

  Future<void> addTransaction(int cardId, CardTransaction transaction) async {
    final card = await getCardById(cardId);
    if (card != null) {
      await isar.writeTxn(() async {
        await isar.cardTransactions.put(transaction);
        card.transactions.add(transaction);
        await card.transactions.save();
      });
    }
  }

  Future<void> deferTransactions(List<int> txIds, int cycles) async {
    await isar.writeTxn(() async {
      for (var id in txIds) {
        final tx = await isar.cardTransactions.get(id);
        if (tx != null) {
          tx.deferredCycles += cycles;
          await isar.cardTransactions.put(tx);
        }
      }
    });
  }

  // === Subscriptions ===

  Future<List<CardSubscription>> getSubscriptionsForCard(int cardId) async {
    final card = await getCardById(cardId);
    if (card == null) return [];
    
    await card.subscriptions.load();
    return card.subscriptions.where((sub) => !sub.isDeleted).toList();
  }

  Future<void> softDeleteSubscription(int subId) async {
    final sub = await isar.cardSubscriptions.get(subId);
    if (sub != null) {
      await isar.writeTxn(() async {
        sub.isDeleted = true;
        await isar.cardSubscriptions.put(sub);
      });
    }
  }

  Future<List<CardSubscription>> getDeletedSubscriptions() async {
    return await isar.cardSubscriptions.where().filter().isDeletedEqualTo(true).findAll();
  }

  Future<void> restoreSubscription(int subId) async {
    final sub = await isar.cardSubscriptions.get(subId);
    if (sub != null) {
      await isar.writeTxn(() async {
        sub.isDeleted = false;
        await isar.cardSubscriptions.put(sub);
      });
    }
  }

  Future<void> addSubscription(int cardId, CardSubscription subscription) async {
    final card = await getCardById(cardId);
    if (card != null) {
      await isar.writeTxn(() async {
        await isar.cardSubscriptions.put(subscription);
        card.subscriptions.add(subscription);
        await card.subscriptions.save();
      });
    }
  }

  Future<void> syncSubscriptionsToTransactions() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final cards = await getCards();
    
    for (var card in cards) {
      await card.subscriptions.load();
      for (var sub in card.subscriptions) {
        if (!sub.isActive || sub.isDeleted) continue;
        
        if (sub.lastProcessedDate == null) {
          // Legacy subscription, initialize to today to avoid retroactive charges
          await isar.writeTxn(() async {
            sub.lastProcessedDate = today;
            await isar.cardSubscriptions.put(sub);
          });
          continue;
        }

        DateTime processFrom = sub.lastProcessedDate!;
        DateTime checkDate = DateTime(processFrom.year, processFrom.month, sub.billingDay);
        
        if (processFrom.isAfter(checkDate) || processFrom.isAtSameMomentAs(checkDate)) {
          int nextMonth = checkDate.month == 12 ? 1 : checkDate.month + 1;
          int nextYear = checkDate.month == 12 ? checkDate.year + 1 : checkDate.year;
          checkDate = DateTime(nextYear, nextMonth, sub.billingDay);
        }

        bool madeChanges = false;
        
        while (checkDate.isBefore(today) || checkDate.isAtSameMomentAs(today)) {
          final tx = CardTransaction()
            ..concept = sub.serviceName
            ..amount = sub.amount
            ..date = checkDate
            ..type = TransactionType.subscriptionCharge
            ..installments = 1;
            
          await addTransaction(card.id, tx);
          
          sub.lastProcessedDate = checkDate;
          madeChanges = true;
          
          int nextMonth = checkDate.month == 12 ? 1 : checkDate.month + 1;
          int nextYear = checkDate.month == 12 ? checkDate.year + 1 : checkDate.year;
          checkDate = DateTime(nextYear, nextMonth, sub.billingDay);
        }
        
        if (madeChanges) {
          await isar.writeTxn(() async {
            await isar.cardSubscriptions.put(sub);
          });
        }
      }
    }
  }
}
