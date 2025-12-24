import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'map_page.dart';

class FieldVerificationPage extends StatefulWidget {
  final String locationName;
  const FieldVerificationPage({super.key, required this.locationName});

  @override
  State<FieldVerificationPage> createState() => _FieldVerificationPageState();
}

class _FieldVerificationPageState extends State<FieldVerificationPage> {
  File? _photo;
  final TextEditingController _commentsController = TextEditingController();
  DateTime? _visitDate;

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _photo = File(picked.path);
      });
    }
  }

  Future<void> _handleResult(bool confirmed) async {
    // simulate sending to database
    debugPrint(confirmed
        ? 'Change confirmed for ${widget.locationName} — sending to DB...'
        : 'Change rejected for ${widget.locationName} — sending to DB...');

    final title = confirmed ? 'Change Confirmed' : 'Change Rejected';
    final content = confirmed
        ? 'Change confirmed. Information sent to database.'
        : 'Change rejected. Information sent to database.';

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              // Back to map and clear stack so user returns to map
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MapPage()),
                (route) => false,
              );
            },
            child: const Text('Back to Map'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Verification Details'),
        backgroundColor: Colors.green[600],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            Text('Review and reject or confirm the change.', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Text('Current Status', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Location:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text(widget.locationName),
              ],
            ),
            const SizedBox(height: 24),
            Text('Upload Geotagged Photo', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _photo == null
                ? ElevatedButton.icon(
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload Photo'),
                    onPressed: _pickPhoto,
                  )
                : Column(
                    children: [
                      Image.file(_photo!, height: 180),
                      TextButton.icon(
                        icon: const Icon(Icons.remove_red_eye),
                        label: const Text('View Photo'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(child: Image.file(_photo!, fit: BoxFit.contain)),
                          );
                        },
                      ),
                    ],
                  ),
            const SizedBox(height: 8),
            Text(
              'Add photo to verify the change. Make sure the photo is clear and shows updated location.',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _commentsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Add comments or description of findings',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Date of Visit', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(_visitDate == null ? 'Select date' : '${_visitDate!.day}/${_visitDate!.month}/${_visitDate!.year}'),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Pick Date'),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _visitDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  onPressed: () => _handleResult(true),
                  child: const Text('Confirm Change', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  onPressed: () => _handleResult(false),
                  child: const Text('Reject Change', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}