import 'package:isar/isar.dart';
import 'loan_payment.dart';

part 'loan_record.g.dart';

enum LoanType { lent, borrowed }

@collection
class LoanRecord {
  Id id = Isar.autoIncrement;

  late String personName; // Ej: "Mamá", "Carlos"
  late double originalAmount; // Monto inicial
  late double remainingAmount; // Saldo pendiente
  late DateTime date; // Fecha en que se realizó el préstamo
  DateTime? dueDate; // Fecha acordada de pago (opcional)
  late String concept; // Ej: "Para la despensa", "Pago de internet"

  @Enumerated(EnumType.name)
  late LoanType type; // lent (yo presté -> me deben) o borrowed (me prestaron -> yo debo)

  bool isSettled = false; // Liquidado por completo
  bool isDeleted = false; // Papelera de reciclaje

  final payments = IsarLinks<LoanPayment>();
}
