import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class NoteADetailPage extends StatelessWidget {
  const NoteADetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("All Notes"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // กลับไปหน้าก่อนหน้า
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                "Discuss budget",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Gap(10),

              // Created by, Last Modified, Deadline
              _buildInfoRow("Created by:", "Ploy Saipipun"),
              _buildInfoRow("Last Modified:", "25 April 2025, 19.35 PM"),
              _buildInfoRow("Deadline:", "26 April 2025, 21.00 PM"),
              _buildInfoRow("Customer name:", "Nutt Handsome"),
              _buildInfoRow("Address:", "179, 9 Soi Chao Koh, Tambon Ao Nang"),
              _buildInfoRow("Tel:", "074-427-9985"),
              const Gap(10),

              // Contact (with icons)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.facebook),
                    onPressed: () {
                      // Handle Facebook link
                    },
                  ),
                ],
              ),
              const Gap(10),

              // Map link
              _buildInfoRow("Link Map:", "https://maps.app.goo.gl/snSQ8"),
              const Gap(20),

              // Description text
              const Text(
                "The Design of Everyday Things is required reading for anyone who is interested in the user experience. I personally like to reread it every year or two.\n\n"
                "Norman is aware of the durability of his work and the applicability of his principles to multiple disciplines.\n\n"
                "If you know the basics of design better than anyone else, you can apply them flawlessly anywhere.",
                style: TextStyle(fontSize: 16),
              ),
              const Gap(20),

              // Remark/notes section
              const Text(
                "หมายเหตุ:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter your remark",
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Save action
                    },
                    child: const Text("Save"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors
                              .green, // เปลี่ยนจาก primary เป็น backgroundColor
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Cancel action
                    },
                    child: const Text("Cancel"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text("$label ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
