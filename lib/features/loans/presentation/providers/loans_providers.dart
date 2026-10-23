import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../../data/repository/loans_repository.dart';
import '../../domain/loan_record.dart';

final loansRepositoryProvider = Provider<LoansRepository>((ref) {
  return LoansRepository(isar);
});

final loansListProvider = FutureProvider<List<LoanRecord>>((ref) async {
  final repo = ref.watch(loansRepositoryProvider);
  return repo.getLoans();
});

class LoansSummary {
  final double totalToReceive; // Me deben (yo presté y está pendiente)
  final double totalToPay;     // Debo (me prestaron y está pendiente)
  final int activeLoansCount;
  final int settledLoansCount;

  LoansSummary({
    required this.totalToReceive,
    required this.totalToPay,
    required this.activeLoansCount,
    required this.settledLoansCount,
  });

  double get netBalance => totalToReceive - totalToPay;
}

final loansSummaryProvider = FutureProvider<LoansSummary>((ref) async {
  final loans = await ref.watch(loansListProvider.future);

  double toReceive = 0;
  double toPay = 0;
  int active = 0;
  int settled = 0;

  for (var loan in loans) {
    if (loan.isSettled) {
      settled++;
    } else {
      active++;
      if (loan.type == LoanType.lent) {
        toReceive += loan.remainingAmount;
      } else {
        toPay += loan.remainingAmount;
      }
    }
  }

  return LoansSummary(
    totalToReceive: toReceive,
    totalToPay: toPay,
    activeLoansCount: active,
    settledLoansCount: settled,
  );
});
