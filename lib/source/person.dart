import 'card.dart';
import 'dart:io';

abstract class Person {

  /// Кол-во побед в сессии
  int wins = 0;

  /// Рука
  List<Card> hand = [];

  /// Логика решения (Взять карту / Пас)
  void decide();

  /// Делегат класса
  PersonDelegate? delegate;

  /// Список карт через запятую
  String cardsString() => hand.join(', ');

  /// Вес всех открытых карт в руке
  int handWeight() {
    var result = 0;

    for (final card in hand) {
      final cardWeight =
          card.isOpened ? card.cardWeight(currentSum: result) : 0;
      result += cardWeight;
    }

    return result;
  }
}

class Dealer extends Person {
  @override
  void decide() {
    if (handWeight() >= 17) {
        print('Ход Дилера');
        delegate?.getStatus();
        return;
    }

    while (handWeight() < 17) {
        print('Ход Дилера');
        delegate?.getNewCard(this);
        delegate?.getStatus();
    }
  }

  /// Открыть карты. [isRequired] - обязательность выполнения.
  void openCards({required bool isRequired}) {
    if (isRequired) {
      _openCards();
      return;
    }

    if (handWeight() >= 10) {
      _openCards();
      delegate?.getStatus();
    }
  }

  void _openCards() {
    for (final card in hand) {
      card.isOpened = true;
    }
  }
}

class Player extends Person {
  @override
  void decide() {
    print('Ход игрока (1-Взять, 2-Пас)');

    final input = stdin.readLineSync();

    if (input == '1') {
      delegate?.getNewCard(this);

      print('----');
      delegate?.getStatus();

      if (handWeight() > 21) {
        return;
      }

      decide();
    } else if (input == '2') {
      print('----');
    }
  }
}

mixin PersonDelegate {
  /// Получить новую карту
  void getNewCard(Person person);
  
  /// Вывести текущий статус игры
  void getStatus();
}
