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
  late TextEditingController _officeCheckController; // เพิ่ม TextEditingController สำหรับ Office Check

  late DateTime _datelineDate;

  String _status = 'Normal';  
  String _company = 'บริษัทA';  
  String _category = 'งานติดตั้ง';  

  bool _isEditable = false;  // ตัวแปรสำหรับตรวจสอบว่าแก้ไขได้หรือไม่

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
    _officeCheckController = TextEditingController(text: widget.note['office_check'] ?? ''); // เริ่มต้นค่าของ Office Check

    _datelineDate = DateTime.tryParse(widget.note['dateline'] ?? '') ?? DateTime.now();

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
              _buildTextField("Last Modified", TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now())), readOnly: true),
              _buildDateRow("Dateline", _datelineDate, () {}),
              _buildTextField("Sent For", _sentForController, readOnly: true),
              _buildTextField("Contact", _contactController, readOnly: true),
              _buildTextField("Link Map", _linkMapController, readOnly: true),
              _buildTextField("Address", _addressController, readOnly: true),
              _buildTextField("Tel", _telController, readOnly: true),
              _buildDescriptionField(),  // ช่องหมายเหตุที่สามารถแก้ไขได้

              const SizedBox(height: 24),

              _buildTextField("Status", TextEditingController(text: _status), readOnly: true),
              _buildTextField("Company", TextEditingController(text: _company), readOnly: true),
              _buildTextField("Category", TextEditingController(text: _category), readOnly: true),

              // ช่องใหม่: Office Check
              _buildOfficeCheckField(),  // เพิ่มช่องนี้

              // ปุ่ม Save และ Cancel
              if (_isEditable) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _saveNote,
                      child: const Text("Save"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _cancelEdit,
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ช่องหมายเหตุที่สามารถแก้ไขได้
  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _descriptionController,
              maxLines: 4,
              readOnly: true,  // ช่อง Description ไม่สามารถแก้ไขได้
              decoration: InputDecoration(
                labelText: "Description / Remark",
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ช่องใหม่: Office Check ที่สามารถแก้ไขได้
  Widget _buildOfficeCheckField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _officeCheckController,
              maxLines: 1,
              readOnly: !_isEditable,  // เมื่อไม่ใช่โหมดแก้ไขจะไม่สามารถแก้ไขได้
              decoration: InputDecoration(
                labelText: "Office Check",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _toggleEdit,  // เปิดโหมดแก้ไขเมื่อกด
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันสำหรับเปลี่ยนสถานะการแก้ไข
  void _toggleEdit() {
    setState(() {
      _isEditable = !_isEditable;
    });
  }

  // ฟังก์ชันสำหรับบันทึกโน้ต
  void _saveNote() {
    setState(() {
      widget.note['office_check'] = _officeCheckController.text;
      _isEditable = false;  // ปิดโหมดแก้ไขหลังจากบันทึก
    });

    // คุณอาจจะทำการบันทึกข้อมูลไปยังฐานข้อมูลหรือ API ที่นี่
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Note saved successfully!')),
    );
  }

  // ฟังก์ชันยกเลิกการแก้ไข
  void _cancelEdit() {
    setState(() {
      _isEditable = false;  // ยกเลิกการแก้ไขและกลับไปที่ข้อมูลเดิม
      _officeCheckController.text = widget.note['office_check'] ?? '';
    });
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,  
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

