import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/backup/backup_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLoading = false;

  Future<void> _handleExport() async {
    setState(() => _isLoading = true);
    try {
      final backupService = ref.read(backupServiceProvider);
      await backupService.exportData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleImport() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any, // Android and iOS are picky with JSON sometimes
      );

      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        if (!path.endsWith('.json')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El archivo debe ser un .json de respaldo'), backgroundColor: Colors.red),
          );
          return;
        }

        setState(() => _isLoading = true);
        final backupService = ref.read(backupServiceProvider);
        await backupService.importData(path);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Datos restaurados correctamente'), backgroundColor: Colors.green),
          );
          // Restart app navigation or pop
          context.go('/dashboard');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al importar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              const Text(
                'Migración de Datos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                'Genera un archivo de respaldo con toda tu información para pasarlo a otro teléfono.',
                style: TextStyle(color: Color(0xFF8E9BB0), fontSize: 14),
              ),
              const SizedBox(height: 30),
              
              _buildSettingItem(
                icon: Icons.upload_file,
                iconColor: const Color(0xFF00E676),
                title: 'Exportar Información',
                subtitle: 'Crear archivo de respaldo (.json)',
                onTap: _handleExport,
              ),
              
              const SizedBox(height: 20),
              
              _buildSettingItem(
                icon: Icons.download_rounded,
                iconColor: const Color(0xFFE94057),
                title: 'Importar Información',
                subtitle: 'Restaurar desde un archivo (.json)',
                onTap: _handleImport,
              ),
            ],
          ),
          
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF00E676)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF161F33),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A3650)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF8E9BB0))),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF8E9BB0)),
          ],
        ),
      ),
    );
  }
}
