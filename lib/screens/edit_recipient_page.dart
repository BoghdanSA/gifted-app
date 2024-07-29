import 'package:flutter/material.dart';
import '../services/database_service.dart';

class EditRecipientPage extends StatefulWidget {
  final String recipientId;
  final Map<String, dynamic> recipientData;

  const EditRecipientPage({Key? key, required this.recipientId, required this.recipientData}) : super(key: key);

  @override
  EditRecipientPageState createState() => EditRecipientPageState();
}

class EditRecipientPageState extends State<EditRecipientPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _db = DatabaseService();
  late String name;
  late String relationship;
  late DateTime? birthday;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    name = widget.recipientData['name'];
    relationship = widget.recipientData['relationship'];
    birthday = widget.recipientData['birthday']?.toDate();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      try {
        await _db.updateRecipient(widget.recipientId, {
          'name': name,
          'relationship': relationship,
          'birthday': birthday,
        });
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipient updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating recipient: $e')),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Gift Recipient')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: name,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                        onSaved: (value) => name = value!,
                      ),
                      TextFormField(
                        initialValue: relationship,
                        decoration: const InputDecoration(labelText: 'Relationship'),
                        validator: (value) => value!.isEmpty ? 'Please enter the relationship' : null,
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
                            setState(() => birthday = picked);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Update Recipient'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}