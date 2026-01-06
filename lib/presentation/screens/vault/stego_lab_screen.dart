import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../logic/providers/vault_provider.dart';
import '../../widgets/animated_card.dart';

class StegoLabScreen extends ConsumerStatefulWidget {
  const StegoLabScreen({super.key});

  @override
  ConsumerState<StegoLabScreen> createState() => _StegoLabScreenState();
}

class _StegoLabScreenState extends ConsumerState<StegoLabScreen>
    with SingleTickerProviderStateMixin {
  final _secretController = TextEditingController();
  Uint8List? _selectedImage;
  bool _encoding = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() => _selectedImage = bytes);
    }
  }

  Future<void> _encode() async {
    if (_selectedImage == null || _secretController.text.isEmpty) return;
    setState(() => _encoding = true);
    try {
      await ref
          .read(vaultProvider.notifier)
          .encodeImage(_selectedImage!, _secretController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message encoded and saved')),
        );
        setState(() {
          _secretController.clear();
          _selectedImage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _encoding = false);
    }
  }

  Future<void> _viewImage(Uint8List imageBytes) async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Encoded Image'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () async {
                    await _shareImage(imageBytes);
                  },
                ),
              ],
            ),
            Expanded(
              child: InteractiveViewer(
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareImage(Uint8List imageBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File(
          '${tempDir.path}/cypherkeep_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Encoded Image from CypherKeep',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image shared successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(vaultProvider).encodedImages;
    return Scaffold(
      appBar: AppBar(title: const Text('Stego Lab')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pick Image'),
              ),
              const SizedBox(width: 12),
              if (_selectedImage != null)
                const Chip(
                  label: Text('Image selected'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _secretController,
            decoration: const InputDecoration(
              labelText: 'Secret message',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _encoding ? null : _encode,
            icon: const Icon(Icons.lock),
            label: _encoding
                ? const Text('Encoding...')
                : const Text('Encode & Save'),
          ),
          const SizedBox(height: 24),
          Text('History', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...List.generate(images.length, (index) {
            final img = images[index];
            final imageBytes = Uint8List.fromList(img.imageData);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnimatedCard(
                staggerIndex: index,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      imageBytes,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text('Encoded on ${img.encodedAt.toLocal()}'),
                  subtitle: Text('Message length: ${img.messageLength} chars'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () => _viewImage(imageBytes),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => ref
                            .read(vaultProvider.notifier)
                            .deleteEncodedImage(img.id),
                      ),
                    ],
                  ),
                  onTap: () async {
                    try {
                      final message = await ref
                          .read(vaultProvider.notifier)
                          .decodeImage(img.id);
                      if (mounted) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Decoded Message'),
                            content: SelectableText(message),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Decode failed: $e')),
                        );
                      }
                    }
                  },
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
