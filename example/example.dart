import 'package:heart/heart.dart';

/// Small sample of package features
void main() {
  List<String> cardValues =
      ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'] * 4;

  List<String> cardSuits =
      ['spades'] * 13 + ['hearts'] * 13 + ['diamonds'] * 13 + ['clubs'] * 13;

  List deckOfCards = zip([cardValues, cardSuits]);
  List shuffledDeck = deckOfCards.shuffled();

  print('Sorted deck: \n$deckOfCards\n');

  print('Shuffled deck: \n$shuffledDeck\n');

  List redCards = shuffledDeck
      .filter((card) => card.contains('hearts') || card.contains('diamonds'));

  print('Red cards:\n$redCards\n');
  // ----------

  String countdown = inclusive(10, 1).toStringList().intercalate('-');
  print('$countdown HAPPY NEW YEAR!');
}
