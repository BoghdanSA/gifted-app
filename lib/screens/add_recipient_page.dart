import 'package:flutter/material.dart';

class AddRecipientPage extends StatefulWidget {
  const AddRecipientPage({Key? key}) : super(key: key);

  @override
  AddRecipientPageState createState() => AddRecipientPageState();
}

class AddRecipientPageState extends State<AddRecipientPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String relationship = '';
  DateTime? birthday;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Gift Recipient'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
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
                  return 'Please enter a relationship';
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // TODO: Save the recipient to the database
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recipient added successfully')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Recipient'),
            ),
          ],
        ),
      ),
    );
  }
}