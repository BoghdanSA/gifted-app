import 'dart:math';

class GiftSuggestionService {
  // This is a mock service. In a real app, you'd want to use an API or more sophisticated logic.
  Future<List<String>> getSuggestions(String recipientName, String relationship) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock gift suggestions
    const List<String> suggestions = [
      'Customized photo album',
      'Personalized jewelry',
      'Hobby-related gift set',
      'Experience gift (e.g., concert tickets, cooking class)',
      'Tech gadget',
      'Handmade craft',
      'Book by their favorite author',
      'Gourmet food basket',
      'Fitness tracker',
      'Subscription box related to their interests',
    ];

    // Randomly select 5 suggestions
    final random = Random();
    return List.generate(5, (_) => suggestions[random.nextInt(suggestions.length)]);
  }
}