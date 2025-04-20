import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class NoteUDetailPage extends StatefulWidget {
  final Map<String, dynamic> note;
  const NoteUDetailPage({super.key, required this.note});

  @override
  State<NoteUDetailPage> createState() => _NoteUDetailPageState();
}

class _NoteUDetailPageState extends State<NoteUDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _createdByController;
  late TextEditingController _sentForController;
  late TextEditingController _contactController;
  late TextEditingController _linkMapController;
  late TextEditingController _addressController;
  late TextEditingController _telController;
  late TextEditingController _descriptionController;

  late DateTime _datelineDate;

  String _status = 'Normal';  // ค่าดั้งเดิมสำหรับสถานะ
  String _company = 'บริษัทA';  // ค่าดั้งเดิมสำหรับบริษัท
  String _category = 'งานติดตั้ง';  // ค่าดั้งเดิมสำหรับหมวดหมู่

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

    _datelineDate = DateTime.tryParse(widget.note['dateline'] ?? '') ?? DateTime.now();

    // กำหนดค่าเริ่มต้นสำหรับสถานะ, บริษัท, และหมวดหมู่จากข้อมูลที่ได้รับ
    _status = widget.note['status'] ?? 'Normal';
    _company = widget.note['company'] ?? 'บริษัทA';
    _category = widget.note['category'] ?? 'งานติดตั้ง';
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField("Title", _titleController, readOnly: true),
              _buildTextField("Created By", _createdByController, readOnly: true),
              _buildTextField("Last Modified", TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now())), readOnly: true), // ปิดการแก้ไข
              _buildDateRow("Dateline", _datelineDate, () {}), // ไม่ให้เลือกวันที่ได้
              _buildTextField("Sent For", _sentForController, readOnly: true),
              _buildTextField("Contact", _contactController, readOnly: true),
              _buildTextField("Link Map", _linkMapController, readOnly: true),
              _buildTextField("Address", _addressController, readOnly: true),
              _buildTextField("Tel", _telController, readOnly: true),
              _buildTextField("Description / Remark", _descriptionController, maxLines: 4, readOnly: true),

              const SizedBox(height: 24),

              // สถานะ (ไม่สามารถแก้ไขได้)
              _buildTextField("Status", TextEditingController(text: _status), readOnly: true),
              _buildTextField("Company", TextEditingController(text: _company), readOnly: true),
              _buildTextField("Category", TextEditingController(text: _category), readOnly: true),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,  // ปิดการแก้ไข
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
        ],
      ),
    );
  }
}
