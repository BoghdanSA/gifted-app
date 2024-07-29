import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database_service.dart';

class GiftIdeasPage extends StatefulWidget {
  final String recipientId;
  final String recipientName;

  const GiftIdeasPage({Key? key, required this.recipientId, required this.recipientName}) : super(key: key);

  @override
  GiftIdeasPageState createState() => GiftIdeasPageState();
}

class GiftIdeasPageState extends State<GiftIdeasPage> {
  final DatabaseService _db = DatabaseService();
  final TextEditingController _ideaController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gift Ideas for ${widget.recipientName}')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ideaController,
                    decoration: const InputDecoration(labelText: 'New Gift Idea'),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addGiftIdea,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _db.getGiftIdeas(widget.recipientId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No gift ideas added yet'));
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['idea']),
                      subtitle: Text('Price: \$${data['price'] ?? 'N/A'}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editGiftIdea(document.id, data),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteGiftIdea(document.id),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

Future<void> _addGiftIdea() async {
    if (_ideaController.text.isNotEmpty) {
      try {
        await _db.addGiftIdea(
          widget.recipientId,
          _ideaController.text,
          double.tryParse(_priceController.text),
        );
        _ideaController.clear();
        _priceController.clear();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gift idea added successfully')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding gift idea: $e')),
        );
      }
    }
  }

  Future<void> _editGiftIdea(String giftIdeaId, Map<String, dynamic> data) async {
    _ideaController.text = data['idea'];
    _priceController.text = data['price']?.toString() ?? '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Gift Idea'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _ideaController,
              decoration: const InputDecoration(labelText: 'Gift Idea'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () async {
              try {
                await _db.updateGiftIdea(widget.recipientId, giftIdeaId, {
                  'idea': _ideaController.text,
                  'price': double.tryParse(_priceController.text),
                });
                if (!mounted) return;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gift idea updated successfully')),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating gift idea: $e')),
                );
              }
            },
          ),
        ],
      ),
    );

    _ideaController.clear();
    _priceController.clear();
  }

  Future<void> _deleteGiftIdea(String giftIdeaId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this gift idea?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _db.deleteGiftIdea(widget.recipientId, giftIdeaId);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gift idea deleted successfully')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting gift idea: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _ideaController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}