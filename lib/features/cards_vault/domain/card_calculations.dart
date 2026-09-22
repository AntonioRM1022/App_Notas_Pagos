import 'credit_card.dart';
import 'card_transaction.dart';

int getCutoffsPassed(DateTime txDate, DateTime now, int cutoffDay, {int deferredCycles = 0}) {
  int passed = 0;
  DateTime current = getCycleEndDate(txDate, cutoffDay, deferredCycles: deferredCycles);
  
  while (current.isBefore(now) || current.isAtSameMomentAs(now)) {
    passed++;
    int nextMonth = current.month == 12 ? 1 : current.month + 1;
    int nextYear = current.month == 12 ? current.year + 1 : current.year;
    current = DateTime(nextYear, nextMonth, cutoffDay);
  }
  return passed < 0 ? 0 : passed;
}

DateTime getCycleEndDate(DateTime txDate, int cutoffDay, {int deferredCycles = 0}) {
  DateTime result;
  if (txDate.day <= cutoffDay) {
    result = DateTime(txDate.year, txDate.month, cutoffDay);
  } else {
    int nextMonth = txDate.month == 12 ? 1 : txDate.month + 1;
    int nextYear = txDate.month == 12 ? txDate.year + 1 : txDate.year;
    result = DateTime(nextYear, nextMonth, cutoffDay);
  }
  
  if (deferredCycles > 0) {
    for (int i = 0; i < deferredCycles; i++) {
      int nextMonth = result.month == 12 ? 1 : result.month + 1;
      int nextYear = result.month == 12 ? result.year + 1 : result.year;
      result = DateTime(nextYear, nextMonth, cutoffDay);
    }
  }
  return result;
}

class CardStatement {
  final double totalDebt;
  final double previousCutoffDue;
  final double currentCutoffAccumulated;

  CardStatement({
    required this.totalDebt,
    required this.previousCutoffDue,
    required this.currentCutoffAccumulated,
  });
}

CardStatement calculateCardStatement(CreditCard card, List<CardTransaction> transactions) {
  final now = DateTime.now();
  final currentCycleEnd = getCycleEndDate(now, card.cutoffDay);

  double previousPurchases = 0.0;
  double currentPurchases = 0.0;
  double totalPayments = 0.0;
  double totalDebtCalculated = 0.0;

  for (var tx in transactions) {
    if (tx.type == TransactionType.payment) {
      totalPayments += tx.amount;
    } else {
      if (tx.installments <= 1) {
        DateTime cycleEnd = getCycleEndDate(tx.date, card.cutoffDay, deferredCycles: tx.deferredCycles);
        if (cycleEnd.isBefore(currentCycleEnd)) {
          previousPurchases += tx.amount;
        } else if (cycleEnd.isAtSameMomentAs(currentCycleEnd)) {
          currentPurchases += tx.amount;
        }
        totalDebtCalculated += tx.amount;
      } else {
        DateTime cycle = getCycleEndDate(tx.date, card.cutoffDay, deferredCycles: tx.deferredCycles);
        for (int i = 0; i < tx.installments; i++) {
          if (cycle.isBefore(currentCycleEnd)) {
            previousPurchases += tx.amount / tx.installments;
          } else if (cycle.isAtSameMomentAs(currentCycleEnd)) {
            currentPurchases += tx.amount / tx.installments;
          }
          
          int nextMonth = cycle.month == 12 ? 1 : cycle.month + 1;
          int nextYear = cycle.month == 12 ? cycle.year + 1 : cycle.year;
          cycle = DateTime(nextYear, nextMonth, card.cutoffDay);
        }
        totalDebtCalculated += tx.amount;
      }
    }
  }

  double previousDue = previousPurchases - totalPayments;
  double currentDue = currentPurchases;

  if (previousDue < 0) {
    currentDue += previousDue; 
    previousDue = 0.0;
  }
  if (currentDue < 0) currentDue = 0.0;

  double totalDebt = totalDebtCalculated - totalPayments;
  if (totalDebt < 0) totalDebt = 0.0;

  return CardStatement(
    totalDebt: totalDebt,
    previousCutoffDue: previousDue,
    currentCutoffAccumulated: currentDue,
  );
}
