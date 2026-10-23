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
import '../../features/loans/domain/loan_record.dart';
import '../../features/loans/domain/loan_payment.dart';
import '../../features/savings/domain/savings_goal.dart';
import '../../features/savings/domain/savings_contribution.dart';
import '../../features/savings/domain/budget_profile.dart';

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

      final loans = await _isar.loanRecords.where().exportJson();
      final loanPayments = await _isar.loanPayments.where().exportJson();
      final allPayments = await _isar.loanPayments.where().findAll();
      for (int i = 0; i < loanPayments.length; i++) {
        loanPayments[i]['loanId'] = allPayments[i].loan.value?.id;
      }

      final savingsGoals = await _isar.savingsGoals.where().exportJson();
      final savingsContributions = await _isar.savingsContributions.where().exportJson();
      final allContribs = await _isar.savingsContributions.where().findAll();
      for (int i = 0; i < savingsContributions.length; i++) {
        savingsContributions[i]['goalId'] = allContribs[i].goal.value?.id;
      }

      final budgetProfiles = await _isar.budgetProfiles.where().exportJson();

      final backupData = {
        'version': 1,
        'timestamp': DateTime.now().toIso8601String(),
        'creditCards': cards,
        'cardTransactions': transactions,
        'cardSubscriptions': subscriptions,
        'loveNotes': loveNotes,
        'personalNotes': personalNotes,
        'loanRecords': loans,
        'loanPayments': loanPayments,
        'savingsGoals': savingsGoals,
        'savingsContributions': savingsContributions,
        'budgetProfiles': budgetProfiles,
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
        final loans = List<Map<String, dynamic>>.from(backupData['loanRecords'] ?? []);
        final loanPayments = List<Map<String, dynamic>>.from(backupData['loanPayments'] ?? []);
        final savingsGoals = List<Map<String, dynamic>>.from(backupData['savingsGoals'] ?? []);
        final savingsContributions = List<Map<String, dynamic>>.from(backupData['savingsContributions'] ?? []);
        final budgetProfiles = List<Map<String, dynamic>>.from(backupData['budgetProfiles'] ?? []);

        await _isar.writeTxn(() async {
          await _isar.clear(); // Clear existing data

          await _isar.creditCards.importJson(cards);
          await _isar.cardTransactions.importJson(transactions);
          await _isar.cardSubscriptions.importJson(subscriptions);
          await _isar.loveNotes.importJson(loveNotes);
          await _isar.personalNotes.importJson(personalNotes);
          await _isar.loanRecords.importJson(loans);
          await _isar.loanPayments.importJson(loanPayments);
          await _isar.savingsGoals.importJson(savingsGoals);
          await _isar.savingsContributions.importJson(savingsContributions);
          await _isar.budgetProfiles.importJson(budgetProfiles);

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

          for (final pJson in loanPayments) {
            final loanId = pJson['loanId'] as int?;
            if (loanId != null) {
              final pId = pJson['id'] as int;
              final payment = await _isar.loanPayments.get(pId);
              final loan = await _isar.loanRecords.get(loanId);
              if (payment != null && loan != null) {
                payment.loan.value = loan;
                await payment.loan.save();
              }
            }
          }

          for (final cJson in savingsContributions) {
            final goalId = cJson['goalId'] as int?;
            if (goalId != null) {
              final cId = cJson['id'] as int;
              final contrib = await _isar.savingsContributions.get(cId);
              final goal = await _isar.savingsGoals.get(goalId);
              if (contrib != null && goal != null) {
                contrib.goal.value = goal;
                await contrib.goal.save();
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
