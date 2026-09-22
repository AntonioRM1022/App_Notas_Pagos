import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../features/cards_vault/domain/credit_card.dart';
import '../../features/cards_vault/domain/card_transaction.dart';
import '../../features/cards_vault/domain/card_subscription.dart';
import '../../features/important_dates/domain/love_note.dart';
import '../../features/important_dates/domain/personal_note.dart';

class BackupService {
  final Isar _isar;

  BackupService(this._isar);

  Future<void> exportData() async {
    try {
      final cards = await _isar.creditCards.where().exportJson();
      
      final transactions = await _isar.cardTransactions.where().exportJson();
      final allTransObjs = await _isar.cardTransactions.where().findAll();
      for (int i = 0; i < transactions.length; i++) {
        transactions[i]['cardId'] = allTransObjs[i].card.value?.id;
      }

      final subscriptions = await _isar.cardSubscriptions.where().exportJson();
      final allSubObjs = await _isar.cardSubscriptions.where().findAll();
      for (int i = 0; i < subscriptions.length; i++) {
        subscriptions[i]['cardId'] = allSubObjs[i].card.value?.id;
      }

      final loveNotes = await _isar.loveNotes.where().exportJson();
      final personalNotes = await _isar.personalNotes.where().exportJson();

      final backupData = {
        'version': 1,
        'timestamp': DateTime.now().toIso8601String(),
        'creditCards': cards,
        'cardTransactions': transactions,
        'cardSubscriptions': subscriptions,
        'loveNotes': loveNotes,
        'personalNotes': personalNotes,
      };

      final jsonString = jsonEncode(backupData);
      
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/nota_premium_backup.json');
      await file.writeAsString(jsonString);

      await Share.shareXFiles([XFile(file.path)], text: 'Respaldo de Nota Premium');
    } catch (e) {
      debugPrint('Error al exportar: $e');
      rethrow;
    }
  }

  Future<void> importData(String filePath) async {
    try {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final Map<String, dynamic> backupData = jsonDecode(jsonString);

      if (backupData['version'] == 1) {
        final cards = List<Map<String, dynamic>>.from(backupData['creditCards'] ?? []);
        final transactions = List<Map<String, dynamic>>.from(backupData['cardTransactions'] ?? []);
        final subscriptions = List<Map<String, dynamic>>.from(backupData['cardSubscriptions'] ?? []);
        final loveNotes = List<Map<String, dynamic>>.from(backupData['loveNotes'] ?? []);
        final personalNotes = List<Map<String, dynamic>>.from(backupData['personalNotes'] ?? []);

        await _isar.writeTxn(() async {
          await _isar.clear(); // Clear existing data

          await _isar.creditCards.importJson(cards);
          await _isar.cardTransactions.importJson(transactions);
          await _isar.cardSubscriptions.importJson(subscriptions);
          await _isar.loveNotes.importJson(loveNotes);
          await _isar.personalNotes.importJson(personalNotes);

          // Restore links
          for (final txJson in transactions) {
            final cardId = txJson['cardId'] as int?;
            if (cardId != null) {
              final txId = txJson['id'] as int;
              final tx = await _isar.cardTransactions.get(txId);
              final card = await _isar.creditCards.get(cardId);
              if (tx != null && card != null) {
                tx.card.value = card;
                await tx.card.save();
              }
            }
          }

          for (final subJson in subscriptions) {
            final cardId = subJson['cardId'] as int?;
            if (cardId != null) {
              final subId = subJson['id'] as int;
              final sub = await _isar.cardSubscriptions.get(subId);
              final card = await _isar.creditCards.get(cardId);
              if (sub != null && card != null) {
                sub.card.value = card;
                await sub.card.save();
              }
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error al importar: $e');
      rethrow;
    }
  }
}
