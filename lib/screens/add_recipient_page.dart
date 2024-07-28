import 'package:flutter/material.dart';
import '../services/database_service.dart';

class AddRecipientPage extends StatefulWidget {
  const AddRecipientPage({Key? key}) : super(key: key);

  @override
  AddRecipientPageState createState() => AddRecipientPageState();
}

class AddRecipientPageState extends State<AddRecipientPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _db = DatabaseService();
  String name = '';
  String relationship = '';
  DateTime? birthday;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _db.addRecipient(name, relationship, birthday);
      if (!mounted) return; // Check if the widget is still in the tree
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Gift Recipient'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) => name = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Relationship'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the relationship';
                    }
                    return null;
                  },
                  onSaved: (value) => relationship = value!,
                ),
                ListTile(
                  title: const Text('Birthday'),
                  subtitle: Text(birthday == null ? 'Not set' : '${birthday!.toLocal()}'.split(' ')[0]),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: birthday ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != birthday) {
                      setState(() {
                        birthday = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Recipient'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}