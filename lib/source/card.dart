enum Suit {
    spades,
    hearts,
    diamonds,
    clubs
}

extension SuitExtension on Suit {
  String symbol() {
    switch (this) {
      case Suit.spades:
        return '♠︎';
      case Suit.hearts:
        return '♥︎';
      case Suit.diamonds:
        return '♦︎';
      case Suit.clubs:
        return '♣︎';
    }
  }
}

enum CardValue {
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  valet,
  queen,
  king,
  ace
}

extension CardValueExtension on CardValue {
  String symbol() {
    switch (this) {
      case CardValue.valet:
        return 'V';
      case CardValue.queen:
        return 'Q';
      case CardValue.king:
        return 'K';
      case CardValue.ace:
        return 'A';
      default:
        return '${index + 2}';
    }
  }
}

class Card {
  /// Значение
  final CardValue value;

  /// Масть
  final Suit suit;

  /// Открыта ли карта
  bool isOpened = true;

  Card(this.value, this.suit);

  @override
  String toString() {
    if (isOpened) {
      return '${value.symbol()}${suit.symbol()}';
    } else {
      return '-';
    }
  }

  /// Вес карты. [currentSum] - сумма весов в руке.
  int cardWeight({required int currentSum}) {
    switch (value) {
      case CardValue.valet: 
      case CardValue.queen:
      case CardValue.king:
        return 10;
      case CardValue.ace:
        return currentSum >= 21 ? 1 : 11;
      default:
        return value.index + 2;
    }
  }
}