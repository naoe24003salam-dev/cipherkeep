import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/models/secure_note.dart';
import '../../../logic/providers/vault_provider.dart';
import '../../widgets/animated_card.dart';

class SecureNotesScreen extends ConsumerStatefulWidget {
  const SecureNotesScreen({super.key});

  @override
  ConsumerState<SecureNotesScreen> createState() => _SecureNotesScreenState();
}

class _SecureNotesScreenState extends ConsumerState<SecureNotesScreen> {
  bool _grid = false;
  String _search = '';

  void _showNoteDialog({SecureNote? note}) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note == null ? 'New Note' : 'Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              maxLength: 100,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
              maxLength: 5000,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final content = contentController.text.trim();
              if (title.isEmpty || content.isEmpty) return;
              if (note == null) {
                await ref.read(vaultProvider.notifier).addNote(title, content);
              } else {
                await ref.read(vaultProvider.notifier).updateNote(
                      note.id,
                      title,
                      content,
                    );
              }
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(
    BuildContext context,
    SecureNote note,
    int index,
    VoidCallback onEdit,
    VoidCallback onDelete,
  ) {
    final theme = Theme.of(context);
    return AnimatedCard(
      staggerIndex: index,
      onTap: onEdit,
      onLongPress: onDelete,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  note.title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showMenu(context, onEdit, onDelete),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            'Modified: ${DateFormat('MMM dd, yyyy').format(note.lastModified)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(
      BuildContext context, VoidCallback onEdit, VoidCallback onDelete) async {
    final selection = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );

    if (selection == 'edit') {
      onEdit();
    } else if (selection == 'delete') {
      onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(vaultProvider).notes.where((n) {
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return n.title.toLowerCase().contains(q) ||
          n.content.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Notes'),
        actions: [
          IconButton(
            icon: Icon(_grid ? Icons.view_agenda : Icons.grid_view),
            onPressed: () => setState(() => _grid = !_grid),
            tooltip: 'Toggle layout',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        child: const Icon(Icons.add),
      ),
      body: notes.isEmpty
          ? const Center(child: Text('No notes yet'))
          : _grid
              ? GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return _buildNoteCard(
                      context,
                      note,
                      index,
                      () => _showNoteDialog(note: note),
                      () =>
                          ref.read(vaultProvider.notifier).deleteNote(note.id),
                    );
                  },
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildNoteCard(
                        context,
                        note,
                        index,
                        () => _showNoteDialog(note: note),
                        () => ref
                            .read(vaultProvider.notifier)
                            .deleteNote(note.id),
                      ),
                    );
                  },
                ),
    );
  }
}
