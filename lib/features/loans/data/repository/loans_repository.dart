import 'package:isar/isar.dart';
import '../../domain/loan_record.dart';
import '../../domain/loan_payment.dart';

class LoansRepository {
  final Isar isar;

  LoansRepository(this.isar);

  // Obtener préstamos activos (no eliminados)
  Future<List<LoanRecord>> getLoans() async {
    final allLoans = await isar.loanRecords.where().findAll();
    final active = allLoans.where((l) => !l.isDeleted).toList();
    // Cargar pagos relacionados
    for (var loan in active) {
      await loan.payments.load();
    }
    // Ordenar: primero los no liquidados, luego los más recientes
    active.sort((a, b) {
      if (a.isSettled != b.isSettled) {
        return a.isSettled ? 1 : -1;
      }
      return b.date.compareTo(a.date);
    });
    return active;
  }

  // Agregar nuevo préstamo
  Future<void> addLoan(LoanRecord loan) async {
    await isar.writeTxn(() async {
      await isar.loanRecords.put(loan);
    });
  }

  // Registrar un abono a un préstamo
  Future<void> recordPayment(int loanId, double paymentAmount, {String? notes}) async {
    final loan = await isar.loanRecords.get(loanId);
    if (loan == null) return;

    await isar.writeTxn(() async {
      final payment = LoanPayment()
        ..amount = paymentAmount
        ..date = DateTime.now()
        ..notes = notes;

      await isar.loanPayments.put(payment);
      loan.payments.add(payment);
      await loan.payments.save();

      loan.remainingAmount = (loan.remainingAmount - paymentAmount);
      if (loan.remainingAmount <= 0.01) {
        loan.remainingAmount = 0;
        loan.isSettled = true;
      }
      await isar.loanRecords.put(loan);
    });
  }

  // Marcar como liquidado totalmente
  Future<void> settleLoanFully(int loanId) async {
    final loan = await isar.loanRecords.get(loanId);
    if (loan == null) return;

    await isar.writeTxn(() async {
      final remaining = loan.remainingAmount;
      if (remaining > 0) {
        final payment = LoanPayment()
          ..amount = remaining
          ..date = DateTime.now()
          ..notes = 'Liquidación total';
        await isar.loanPayments.put(payment);
        loan.payments.add(payment);
        await loan.payments.save();
      }
      loan.remainingAmount = 0;
      loan.isSettled = true;
      await isar.loanRecords.put(loan);
    });
  }

  // Enviar a papelera
  Future<void> softDeleteLoan(int loanId) async {
    final loan = await isar.loanRecords.get(loanId);
    if (loan != null) {
      await isar.writeTxn(() async {
        loan.isDeleted = true;
        await isar.loanRecords.put(loan);
      });
    }
  }

  // Restaurar desde papelera
  Future<void> restoreLoan(int loanId) async {
    final loan = await isar.loanRecords.get(loanId);
    if (loan != null) {
      await isar.writeTxn(() async {
        loan.isDeleted = false;
        await isar.loanRecords.put(loan);
      });
    }
  }

  // Obtener préstamos en papelera
  Future<List<LoanRecord>> getDeletedLoans() async {
    return await isar.loanRecords.where().filter().isDeletedEqualTo(true).findAll();
  }
}
