import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/security/biometric_auth_service.dart';
import '../../domain/love_note.dart';
import '../../domain/personal_note.dart';
import '../providers/notes_providers.dart';

class PersonalSpaceScreen extends ConsumerStatefulWidget {
  final String? initialAction;
  const PersonalSpaceScreen({super.key, this.initialAction});

  @override
  ConsumerState<PersonalSpaceScreen> createState() => _PersonalSpaceScreenState();
}

class _PersonalSpaceScreenState extends ConsumerState<PersonalSpaceScreen> {
  final _biometricAuth = BiometricAuthService();

  @override
  void initState() {
    super.initState();
    if (widget.initialAction != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.initialAction == 'amor') {
          _showAddLoveNoteModal();
        } else if (widget.initialAction == 'personal') {
          _showAddPersonalNoteModal();
        }
      });
    }
  }

  void _showAddLoveNoteModal() {
    final titleController = TextEditingController();
    final conceptController = TextEditingController();
    final dateController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    dateController.text = DateFormat('dd MMM yyyy', 'es_ES').format(selectedDate);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161F33),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20, right: 20, top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nueva Nota de Amor', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Nombre / Título',
                      labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: dateController,
                    style: const TextStyle(color: Colors.white),
                    readOnly: true,
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Color(0xFFE94057),
                                onPrimary: Colors.white,
                                surface: Color(0xFF161F33),
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        setStateModal(() {
                          selectedDate = pickedDate;
                          dateController.text = DateFormat('dd MMM yyyy', 'es_ES').format(pickedDate);
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Día Marcado',
                      labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: conceptController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Concepto / Nota',
                      labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE94057), // Pink for love note
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        if (titleController.text.isNotEmpty && conceptController.text.isNotEmpty) {
                          final newNote = LoveNote()
                            ..title = titleController.text
                            ..concept = conceptController.text
                            ..date = selectedDate;

                          final repo = ref.read(notesRepositoryProvider);
                          await repo.addLoveNote(newNote);
                          
                          if (mounted) {
                            Navigator.pop(context);
                            ref.invalidate(loveNotesProvider);
                          }
                        }
                      },
                      child: const Text('GUARDAR NOTA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        );
      },
    );
  }

  void _showAddPersonalNoteModal() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedCategory = 'Citas'; // Default

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161F33),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20, right: 20, top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nueva Nota Personal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    dropdownColor: const Color(0xFF161F33),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                    ),
                    items: ['Citas', 'Contraseñas', 'Ideas', 'Otros']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setStateModal(() => selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: contentController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Datos / Contenido',
                      labelStyle: TextStyle(color: Color(0xFF8E9BB0)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2A3650))),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E676))),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E676),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                          final newNote = PersonalNote()
                            ..category = selectedCategory
                            ..title = titleController.text
                            ..content = contentController.text
                            ..requiresAuth = (selectedCategory == 'Contraseñas');

                          final repo = ref.read(notesRepositoryProvider);
                          await repo.addPersonalNote(newNote);
                          
                          if (mounted) {
                            Navigator.pop(context);
                            ref.invalidate(personalNotesProvider);
                          }
                        }
                      },
                      child: const Text('GUARDAR NOTA', style: TextStyle(color: Color(0xFF161F33), fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        );
      },
    );
  }

  void _onPersonalNoteTap(PersonalNote note) async {
    if (note.requiresAuth) {
      final isAuthenticated = await _biometricAuth.authenticate();
      if (!isAuthenticated) return;
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF161F33),
          title: Text(note.title, style: const TextStyle(color: Colors.white)),
          content: Text(note.content, style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () async {
                final repo = ref.read(notesRepositoryProvider);
                await repo.softDeletePersonalNote(note.id);
                if (mounted) {
                  Navigator.pop(context);
                  ref.invalidate(personalNotesProvider);
                }
              },
              child: const Text('Eliminar', style: TextStyle(color: Color(0xFFE94057))),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar', style: TextStyle(color: Color(0xFF00E676))),
            ),
          ],
        ),
      );
    }
  }

  void _onLoveNoteTap(LoveNote note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161F33),
        title: Text(note.title, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Color(0xFFE94057)),
                const SizedBox(width: 6),
                Text(
                  'Fecha: ${DateFormat('dd MMM yyyy', 'es_ES').format(note.date)}',
                  style: const TextStyle(color: Color(0xFFE94057), fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(note.concept, style: const TextStyle(color: Colors.white70)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final repo = ref.read(notesRepositoryProvider);
              await repo.softDeleteLoveNote(note.id);
              if (mounted) {
                Navigator.pop(context);
                ref.invalidate(loveNotesProvider);
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Color(0xFFE94057))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar', style: TextStyle(color: Color(0xFF00E676))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
          child: CircleAvatar(
            backgroundColor: Colors.grey[800],
            backgroundImage: const AssetImage('assets/images/profile.jpg'),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hola,', style: TextStyle(fontSize: 12, color: Color(0xFF8E9BB0))),
            Text('Antonio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 30),
            _buildLoveNotesSection(),
            const SizedBox(height: 30),
            _buildPersonalNotesSection(),
            const SizedBox(height: 30),
            OutlinedButton.icon(
              onPressed: () => context.push('/recycle_bin'),
              icon: const Icon(Icons.delete_outline, color: Color(0xFF8E9BB0)),
              label: const Text('Papelera de Reciclaje', style: TextStyle(color: Color(0xFF8E9BB0))),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2A3650)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF00E676), width: 2), // Teal border
          ),
          child: const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'Antonio',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Personal Space & Preferences',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF8E9BB0),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard({
    required String title,
    required String date,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    Color subtitleColor = const Color(0xFFE94057),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF8E9BB0),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
        ],
      ),
    );
  }

  Widget _buildLoveNotesSection() {
    final loveAsync = ref.watch(loveNotesProvider);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Notas de mi amor',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Color(0xFFE94057)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: _showAddLoveNoteModal,
            ),
          ],
        ),
        const SizedBox(height: 15),
        loveAsync.when(
          data: (notes) {
            if (notes.isEmpty) {
              return _buildEmptyState('Sin notas de amor');
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.5, // Más pequeño en altura
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final dateFormatted = DateFormat('dd MMM', 'es_ES').format(note.date);
                return GestureDetector(
                  onTap: () => _onLoveNoteTap(note),
                  child: _buildNoteCard(
                    icon: Icons.favorite_border,
                    iconColor: const Color(0xFFE94057),
                    title: note.title,
                    content: note.concept,
                    dateText: dateFormatted,
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
      ],
    );
  }

  Widget _buildPersonalNotesSection() {
    final personalAsync = ref.watch(personalNotesProvider);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Personales',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Color(0xFF00E676)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: _showAddPersonalNoteModal,
            ),
          ],
        ),
        const SizedBox(height: 15),
        personalAsync.when(
          data: (notes) {
            if (notes.isEmpty) {
              return _buildEmptyState('Sin notas personales');
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.5, // Más pequeño en altura
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return GestureDetector(
                  onTap: () => _onPersonalNoteTap(note),
                  child: _buildNoteCard(
                    icon: note.requiresAuth ? Icons.lock_outline : Icons.event_note_outlined,
                    iconColor: const Color(0xFF00E676),
                    title: note.title,
                    content: note.requiresAuth ? '••••••••' : note.content,
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String text) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(text, style: TextStyle(color: const Color(0xFF8E9BB0).withOpacity(0.5))),
      ),
    );
  }

  Widget _buildNoteCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
    String? dateText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161F33),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 20),
              if (dateText != null)
                Text(
                  dateText,
                  style: const TextStyle(color: Color(0xFF8E9BB0), fontSize: 10),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(fontSize: 10, color: Colors.white70, height: 1.4),
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }
}
