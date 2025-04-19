import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class NoteAddPage extends StatefulWidget {
  final DateTime dateline;
  const NoteAddPage({super.key, required this.dateline}); // ✅ มี required

  @override
  State<NoteAddPage> createState() => _NoteAddPageState();
}

class _NoteAddPageState extends State<NoteAddPage> {
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

  // ตัวแปรสำหรับสถานะ
  String _status = 'Normal'; // ใช้สำหรับสถานะงาน (ด่วน / ปกติ)

  // ตัวแปรสำหรับเลือกบริษัท
  String _company = 'บริษัทA'; // Default คือ บริษัทA

  // ตัวแปรสำหรับเลือกประเภทของงาน
  String _category = 'ติดตั้งเครื่อง'; // Default คือ ติดตั้งเครื่อง

  @override
  void initState() {
    super.initState();
    _lastModifiedDate = DateTime.now(); // กำหนดเป็นวันที่ปัจจุบัน
    _datelineDate = widget.dateline; // ใช้ค่าที่ส่งมา
  }

  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill in the title")));
      return;
    }

    // ตั้งค่า last_modified เป็นวันที่ปัจจุบัน (ไม่ต้องเลือกวันที่เอง)
    DateTime lastModified = DateTime.now(); // วันที่ที่กดบันทึก

    final url = Uri.parse("http://172.20.10.6:3000/notes");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': _titleController.text,
          'created_by': _createdByController.text,
          'last_modified': lastModified.toIso8601String(), // ส่งวันที่ปัจจุบัน
          'dateline': _datelineDate.toIso8601String(), // วันกำหนดที่เลือก
          'sent_for': _sentForController.text,
          'contact': _contactController.text,
          'link_map': _linkMapController.text,
          'address': _addressController.text,
          'tel': _telController.text,
          'description': _descriptionController.text,
          'status': _status, // ส่งสถานะไปด้วย
          'company': _company, // ส่งชื่อบริษัทไปด้วย
          'category': _category, // ส่งประเภทงานไปด้วย
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Saved successfully")));
        Navigator.pop(context);
      } else {
        print('Failed response: ${response.body}');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to save")));
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("An error occurred")));
    }
  }

  void _cancelInput() {
    Navigator.pop(context);
  }

  // ฟังก์ชันสำหรับเลือกวันที่สำหรับ dateline
  Future<void> _pickDateline() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _datelineDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _datelineDate = pickedDate;
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
              // แสดงวันที่ปัจจุบันสำหรับ last_modified (ไม่ให้เลือก)
              _buildDateRow("Last Modified", _lastModifiedDate, () {}),
              // ฟังก์ชันให้เลือกวันสำหรับ dateline
              _buildDateRow("Dateline", _datelineDate, _pickDateline),
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
              const SizedBox(height: 24),

              // ฟังก์ชันเลือกสถานะ
              DropdownButton<String>(
                value: _status,
                items:
                    ['Normal', 'Do Now!'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),

              // ฟังก์ชันเลือกบริษัท
              DropdownButton<String>(
                value: _company,
                items:
                    ['บริษัทA', 'บริษัทB'].map((String company) {
                      return DropdownMenuItem<String>(
                        value: company,
                        child: Text(company),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _company = value!;
                  });
                },
              ),

              // ฟังก์ชันเลือกประเภทงาน
              DropdownButton<String>(
                value: _category,
                items:
                    [
                      'ติดตั้งเครื่อง',
                      'ซ่อมเครื่อง',
                      'ส่งของ',
                      'ตรวจงาน',
                      'ซ่อมรถ',
                    ].map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Row(
                          children: [
                            Icon(
                              _getCategoryIcon(category),
                            ), // แสดงไอคอนตามประเภทงาน
                            const SizedBox(width: 8),
                            Text(category),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveNote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text("Save"),
                  ),
                  ElevatedButton(
                    onPressed: _cancelInput,
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
  }) {
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

  // ฟังก์ชันเพื่อเลือกไอคอนตามประเภทงาน
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'ติดตั้งเครื่อง':
        return Icons.build; // ไอคอนเครื่องมือ
      case 'ซ่อมเครื่อง':
        return Icons.build_circle; // ไอคอนเครื่องมือ
      case 'ส่งของ':
        return Icons.local_shipping; // ไอคอนส่งของ
      case 'ตรวจงาน':
        return Icons.check_circle_outline; // ไอคอนตรวจ
      case 'ซ่อมรถ':
        return Icons.car_repair; // ไอคอนซ่อมรถ
      default:
        return Icons.help_outline; // ไอคอนอื่น ๆ
    }
  }
}
