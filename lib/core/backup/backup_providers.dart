import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart'; // accesses the global isar instance
import 'backup_service.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(isar);
});
