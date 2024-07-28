import 'package:flutter/material.dart';
import '../services/gift_suggestion_service.dart';

class GiftSuggestionPage extends StatefulWidget {
  final String recipientName;
  final String relationship;

  const GiftSuggestionPage({
    Key? key, 
    required this.recipientName, 
    required this.relationship
  }) : super(key: key);

  @override
  GiftSuggestionPageState createState() => GiftSuggestionPageState();
}

class GiftSuggestionPageState extends State<GiftSuggestionPage> {
  final GiftSuggestionService _suggestionService = GiftSuggestionService();
  List<String> _suggestions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final suggestions = await _suggestionService.getSuggestions(widget.recipientName, widget.relationship);
      if (!mounted) return;
      setState(() {
        _suggestions = suggestions;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load suggestions')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gift Suggestions for ${widget.recipientName}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_suggestions[index]),
                  trailing: const Icon(Icons.favorite_border),
                  onTap: () {
                    // TODO: Implement saving favorite gifts
                  },
                );
              },
            ),
    );
  }
}