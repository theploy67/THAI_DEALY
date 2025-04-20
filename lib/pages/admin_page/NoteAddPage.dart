import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class NoteAddPage extends StatefulWidget {
  final DateTime dateline;
  const NoteAddPage({super.key, required this.dateline});

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
  String _status = 'Normal';

  // ตัวแปรสำหรับเลือกบริษัท
  String _company = 'บริษัทA';

  // ตัวแปรสำหรับเลือกประเภทของงาน
  String _category = 'งานติดตั้ง';

  @override
  void initState() {
    super.initState();
    _lastModifiedDate = DateTime.now();
    _datelineDate = widget.dateline;
  }

  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill in the title")));
      return;
    }

    DateTime lastModified = DateTime.now(); // วันที่ที่กดบันทึก

    final url = Uri.parse("http://172.20.10.6:3000/notes");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': _titleController.text,
          'created_by': _createdByController.text,
          'last_modified': lastModified.toIso8601String(),
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

Future<void> _pickDateline() async {
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: _datelineDate,
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    setState(() {
      // เพิ่มเวลาเป็น 23:59
      _datelineDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        23, 59, 0, 0, 0,
      );
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
              _buildDateRow("Last Modified", _lastModifiedDate, () {}),
              _buildDateRow("Dateline", _datelineDate, _pickDateline),
              _buildTextField("Sent For", _sentForController),
              _buildTextField("Contact", _contactController),
              _buildTextField("Link Map", _linkMapController),
              _buildTextField("Address", _addressController),
              _buildTextField("Tel", _telController),
              _buildTextField("Description / Remark", _descriptionController, maxLines: 4),
              const SizedBox(height: 24),

              // ฟังก์ชันเลือกสถานะ
              DropdownButton<String>(
                value: _status,
                items: ['Normal', 'Do Now!'].map((String value) {
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
                items: ['Xray2hand', 'ThaiDR','บริษัทA', 'บริษัทB'].map((String company) {
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
                items: [
                  'งานติดตั้ง',
                  'ซ่อมบำรุง',
                  'ส่งของ',
                  'ตรวจเช็ค',
                  'อื่นๆ',
                ].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Row(
                      children: [
                        Icon(
                          _getCategoryIcon(category), // แสดงไอคอนตามประเภทงาน
                          size: 20,
                          color: Colors.black,
                        ),
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'งานติดตั้ง':
        return Icons.build;
      case 'ซ่อมบำรุง':
        return Icons.build_circle;
      case 'ส่งของ':
        return Icons.local_shipping;
      case 'ตรวจดช็ค':
        return Icons.check_circle_outline;
      case 'อื่นๆ':
        return Icons.car_repair;
      default:
        return Icons.help_outline;
    }
  }
}
