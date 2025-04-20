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

  late DateTime _datelineDate;

  bool _isEditing = false;

  // สถานะที่สามารถเลือกได้
  List<String> _statusOptions = ['Normal', 'Do Now!'];
  List<String> _companyOptions = ['Xray2hand', 'ThaiDR','บริษัทA', 'บริษัทB'];
  List<String> _categoryOptions = ['งานติดตั้ง', 'ซ่อมบำรุง','ส่งของ','ตรวจเช็ค', 'อื่นๆ'];

  String _status = 'Normal';
  String _company = 'บริษัทA';
  String _category = 'งานติดตั้ง';

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
    _status = _statusOptions.contains(widget.note['status']) ? widget.note['status'] : _statusOptions[0];
    _company = _companyOptions.contains(widget.note['company']) ? widget.note['company'] : _companyOptions[0];
    _category = _categoryOptions.contains(widget.note['category']) ? widget.note['category'] : _categoryOptions[0];
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
          'last_modified': DateTime.now().toIso8601String(), // ใช้เวลาปัจจุบันอัตโนมัติ
          'dateline': _datelineDate.toIso8601String(), // ใช้วันที่ที่เลือก + เวลา 23:59
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Updated successfully")));
        setState(() {
          _isEditing = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to update")));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An error occurred")));
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
      _datelineDate = DateTime.tryParse(widget.note['dateline'] ?? '') ?? DateTime.now();
      _status = widget.note['status'] ?? 'Normal';
      _company = widget.note['company'] ?? 'บริษัทA';
      _category = widget.note['category'] ?? 'ติดตั้งเครื่อง';
    });
  }

  Future<void> _pickDate({required bool isDateline}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isDateline ? _datelineDate : DateTime.now(), // เปลี่ยนให้เลือกวันที่ได้ตามที่ต้องการ
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isDateline) {
          _datelineDate = pickedDate.add(Duration(days: 1)); // เพิ่ม 1 วันให้กับ dateline
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
              _buildTextField("Title", _titleController, readOnly: !_isEditing),
              _buildTextField("Created By", _createdByController, readOnly: !_isEditing),
              // ลบ last_modified ออกไป
              _buildTextField("Last Modified", TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now())), readOnly: true), // ปิดการแก้ไข
              _buildDateRow("Dateline", _datelineDate, () {
                if (_isEditing) _pickDate(isDateline: true);
              }),
              _buildTextField("Sent For", _sentForController, readOnly: !_isEditing),
              _buildTextField("Contact", _contactController, readOnly: !_isEditing),
              _buildTextField("Link Map", _linkMapController, readOnly: !_isEditing),
              _buildTextField("Address", _addressController, readOnly: !_isEditing),
              _buildTextField("Tel", _telController, readOnly: !_isEditing),
              _buildTextField("Description / Remark", _descriptionController, maxLines: 4, readOnly: !_isEditing),

              // สถานะ
              _isEditing
                  ? _buildDropdown("Status", _status, _statusOptions, (value) {
                      setState(() {
                        _status = value!;
                      });
                    })
                  : _buildTextField("Status", TextEditingController(text: _status), readOnly: true),

              // บริษัท
              _isEditing
                  ? _buildDropdown("Company", _company, _companyOptions, (value) {
                      setState(() {
                        _company = value!;
                      });
                    })
                  : _buildTextField("Company", TextEditingController(text: _company), readOnly: true),

              // หมวดหมู่
              _isEditing
                  ? _buildDropdown("Category", _category, _categoryOptions, (value) {
                      setState(() {
                        _category = value!;
                      });
                    })
                  : _buildTextField("Category", TextEditingController(text: _category), readOnly: true),

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
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: onPressed,
            ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value, // ค่าที่ได้รับจากการ PUT ข้อมูล
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: _isEditing ? onChanged : null, // เมื่อไม่อยู่ในโหมดแก้ไขจะไม่สามารถเลือกได้
      ),
    );
  }
}
