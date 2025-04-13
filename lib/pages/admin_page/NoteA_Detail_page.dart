import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class NoteADetailPage extends StatefulWidget {
  final DateTime dateline;

  NoteADetailPage({super.key, required this.dateline});

  @override
  State<NoteADetailPage> createState() => _NoteADetailPageState();
}

class _NoteADetailPageState extends State<NoteADetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _createdByController = TextEditingController();
  final TextEditingController _sentForController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _linkMapController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late DateTime _lastModifiedDate;
  late DateTime _datelineDate;

  @override
  void initState() {
    super.initState();
    _lastModifiedDate = DateTime.now();
    _datelineDate = widget.dateline;
  }

  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in the title")),
      );
      return;
    }

    final url = Uri.parse("https://your-api-url.com/notes");

    try {
      final response = await http.post(
        url,
        body: {
          'title': _titleController.text,
          'Created By': _createdByController.text,
          'Last Modified': _lastModifiedDate.toIso8601String(),
          'Dateline': _datelineDate.toIso8601String(),
          'Sent For': _sentForController.text,
          'address': _addressController.text,
          'tel': _telController.text,
          'Contact': _contactController.text,
          'Link Map': _linkMapController.text,
          'description': _descriptionController.text,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Saved successfully")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred")),
      );
    }
  }

  void _cancelInput() {
    _titleController.clear();
    _createdByController.clear();
    _sentForController.clear();
    _contactController.clear();
    _linkMapController.clear();
    _addressController.clear();
    _telController.clear();
    _descriptionController.clear();
  }

  Future<void> _pickDate({required bool isDateline}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isDateline ? _datelineDate : _lastModifiedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isDateline) {
          _datelineDate = pickedDate;
        } else {
          _lastModifiedDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField("Title", _titleController),
              _buildTextField("Created By", _createdByController),
              _buildDateRow("Last Modified", _lastModifiedDate, () {
                _pickDate(isDateline: false);
              }),
              _buildDateRow("Dateline", _datelineDate, () {
                _pickDate(isDateline: true);
              }),
              _buildTextField("Sent For", _sentForController),
              _buildTextField("Contact", _contactController),
              _buildTextField("Link Map", _linkMapController),
              _buildTextField("Address", _addressController),
              _buildTextField("Tel", _telController),
              _buildTextField("Description / Remark", _descriptionController, maxLines: 4),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveNote,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Save"),
                  ),
                  ElevatedButton(
                    onPressed: _cancelInput,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDateRow(String label, DateTime date, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text("$label: ${DateFormat('yyyy-MM-dd').format(date)}"),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
