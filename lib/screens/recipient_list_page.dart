import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database_service.dart';
import 'gift_suggestion_page.dart';

class RecipientListPage extends StatelessWidget {
  RecipientListPage({Key? key}) : super(key: key);

  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift Recipients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/add_recipient'),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.getRecipients(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No recipients added yet'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text(data['relationship']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/edit_recipient',
                        arguments: {
                          'id': document.id,
                          'data': data,
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _showDeleteConfirmation(context, document.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.card_giftcard),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/gift_ideas',
                        arguments: {
                          'id': document.id,
                          'name': data['name'],
                        },
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiftSuggestionPage(
                      recipientName: data['name'],
                      relationship: data['relationship'],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String recipientId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this recipient?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteRecipient(context, recipientId);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteRecipient(BuildContext context, String recipientId) {
    _db.deleteRecipient(recipientId).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipient deleted successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting recipient: $error')),
      );
    });
  }
}