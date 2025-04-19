import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class NoteADetailPage extends StatefulWidget {
  final Map<String, dynamic> note;
  const NoteADetailPage({super.key, required this.note});

  @override
  State<NoteADetailPage> createState() => _NoteADetailPageState();
}

class _NoteADetailPageState extends State<NoteADetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _createdByController;
  late TextEditingController _sentForController;
  late TextEditingController _contactController;
  late TextEditingController _linkMapController;
  late TextEditingController _addressController;
  late TextEditingController _telController;
  late TextEditingController _descriptionController;

  late DateTime _lastModifiedDate;
  late DateTime _datelineDate;

  bool _isEditing = false;

  String _status = 'Normal';
  String _company = 'บริษัทA';
  String _category = 'ติดตั้งเครื่อง';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note['title'] ?? '');
    _createdByController = TextEditingController(text: widget.note['created_by'] ?? '');
    _sentForController = TextEditingController(text: widget.note['sent_for'] ?? '');
    _contactController = TextEditingController(text: widget.note['contact'] ?? '');
    _linkMapController = TextEditingController(text: widget.note['link_map'] ?? '');
    _addressController = TextEditingController(text: widget.note['address'] ?? '');
    _telController = TextEditingController(text: widget.note['tel'] ?? '');
    _descriptionController = TextEditingController(text: widget.note['description'] ?? '');

    _lastModifiedDate = DateTime.tryParse(widget.note['last_modified'] ?? '') ?? DateTime.now();
    _datelineDate = DateTime.tryParse(widget.note['dateline'] ?? '') ?? DateTime.now();

    // กำหนดค่าเริ่มต้นสำหรับสถานะ, บริษัท, และหมวดหมู่จากข้อมูลที่ได้รับ
    _status = widget.note['status'] ?? 'Normal';
    _company = widget.note['company'] ?? 'บริษัทA';
    _category = widget.note['category'] ?? 'ติดตั้งเครื่อง';
  }

  Future<void> _updateNote() async {
    final url = Uri.parse("http://172.20.10.6:3000/notes/${widget.note['id']}");

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': _titleController.text,
          'created_by': _createdByController.text,
          'last_modified': _lastModifiedDate.toIso8601String(),
          'dateline': _datelineDate.toIso8601String(),
          'sent_for': _sentForController.text,
          'contact': _contactController.text,
          'link_map': _linkMapController.text,
          'address': _addressController.text,
          'tel': _telController.text,
          'description': _descriptionController.text,
          'status': _status,
          'company': _company,
          'category': _category,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Updated successfully")));
        setState(() {
          _isEditing = false;
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to update")));
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("An error occurred")));
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _titleController.text = widget.note['title'] ?? '';
      _createdByController.text = widget.note['created_by'] ?? '';
      _sentForController.text = widget.note['sent_for'] ?? '';
      _contactController.text = widget.note['contact'] ?? '';
      _linkMapController.text = widget.note['link_map'] ?? '';
      _addressController.text = widget.note['address'] ?? '';
      _telController.text = widget.note['tel'] ?? '';
      _descriptionController.text = widget.note['description'] ?? '';
      _lastModifiedDate = DateTime.tryParse(widget.note['last_modified'] ?? '') ?? DateTime.now();
      _datelineDate = DateTime.tryParse(widget.note['dateline'] ?? '') ?? DateTime.now();
      _status = widget.note['status'] ?? 'Normal';
      _company = widget.note['company'] ?? 'บริษัทA';
      _category = widget.note['category'] ?? 'ติดตั้งเครื่อง';
    });
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
        title: const Text("Note Detail"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
            tooltip: 'Edit Note',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField("Title", _titleController),
              _buildTextField("Created By", _createdByController),
              _buildDateRow("Last Modified", _lastModifiedDate, () {
                if (_isEditing) _pickDate(isDateline: false);
              }),
              _buildDateRow("Dateline", _datelineDate, () {
                if (_isEditing) _pickDate(isDateline: true);
              }),
              _buildTextField("Sent For", _sentForController),
              _buildTextField("Contact", _contactController),
              _buildTextField("Link Map", _linkMapController),
              _buildTextField("Address", _addressController),
              _buildTextField("Tel", _telController),
              _buildTextField(
                "Description / Remark",
                _descriptionController,
                maxLines: 4,
              ),

              // การแสดงสถานะ
              _buildTextField("Status", TextEditingController(text: _status), readOnly: true),
              _buildTextField("Company", TextEditingController(text: _company), readOnly: true),
              _buildTextField("Category", TextEditingController(text: _category), readOnly: true),

              const SizedBox(height: 24),
              if (_isEditing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _updateNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text("Save"),
                    ),
                    ElevatedButton(
                      onPressed: _cancelEdit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
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

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly, // ปรับให้เป็นอ่านได้เมื่อไม่อยู่ในโหมดแก้ไข
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
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: onPressed,
            ),
        ],
      ),
    );
  }
}
