import 'package:isar/isar.dart';
import 'loan_record.dart';

part 'loan_payment.g.dart';

@collection
class LoanPayment {
  Id id = Isar.autoIncrement;

  late double amount;
  late DateTime date;
  String? notes;

  @Backlink(to: 'payments')
  final loan = IsarLink<LoanRecord>();
}
