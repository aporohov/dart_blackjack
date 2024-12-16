import 'person.dart';
import 'card.dart';
import 'dart:io';

class Game with PersonDelegate {
  /// Игрок
  final player = Player();

  /// Дилер
  final dealer = Dealer();

  /// Колода карт
  List<Card> cardsDeck = [];

  Game() {
    dealer.delegate = this;
    player.delegate = this;
  }

  /// Начать игру
  void newGame() {
    print('----');
    print('Новая игра');
    print('----');

    _clearHands();
    _shuffleDeck();

    _gameCycle();
  }

  /// Игровой цикл
  void _gameCycle() {
    _distributeCards();

    _checkPlayerStatus();

    dealer.openCards(isRequired: false);

    _checkDealerStatus();

    player.decide();

    _checkPlayerStatus();

    dealer.openCards(isRequired: true);

    dealer.decide();
    
    _checkFinalResults();
  }

  /// Раздать карты
  void _distributeCards() {
    print('Раздача:');

    dealer.hand.addAll([getCardFromDeck(), getCardFromDeck(isOpened: false)]);
    player.hand.addAll([getCardFromDeck(), getCardFromDeck()]);

    _printStatus();
  }

  /// Проверка весов игрока
  void _checkPlayerStatus() {
    if (player.handWeight() > 21) {
      _endOfTheGame(winner: dealer);
    }
  }

  /// Проверка весов дилера
  void _checkDealerStatus() {
    final dealerWeight = dealer.handWeight();

    if (dealerWeight == 21) {
      _endOfTheGame(winner: dealer);
    } else if (dealerWeight > 21) {
      _endOfTheGame(winner: player);
    }
  }

  /// Финальная проверка весов игрока и дилера
  void _checkFinalResults() {
    final dealerWeight = dealer.handWeight();
    final playerWeight = player.handWeight();

    if (dealerWeight > 21) {
      _endOfTheGame(winner: player);
    } else if (dealerWeight < playerWeight) {
      _endOfTheGame(winner: player);
    } else if (dealerWeight == playerWeight) {
      _endOfTheGame(winner: null);
    } else {
      _endOfTheGame(winner: dealer);
    }
  }

  /// Подведение итогов игры
  void _endOfTheGame({required Person? winner}) {
    winner?.wins += 1;

    if (winner == dealer) {
      print('Игрок проиграл');
    } else if (winner == player) {
      print('Игрок выиграл');
    } else {
      print('Ничья');
    }

    print('Счёт: И ${player.wins}:${dealer.wins} Д');

    print('----');
    
    print('Сыграть ещё раз? (1-Да, 2-Нет)');

    final input = stdin.readLineSync();

    if (input == '1') {
      newGame();
    } else {
      exit(0);
    }
  }

  /// Вывести статус игры
  void _printStatus() {
    print('Д: ${dealer.cardsString()} (${dealer.handWeight()})');
    print('И: ${player.cardsString()} (${player.handWeight()})');
    print('----');
  }

  /// Забрать у всех карты с рук
  void _clearHands() {
    dealer.hand = [];
    player.hand = [];
  }

  /// Перемешать колоду
  void _shuffleDeck() {
    cardsDeck = [];

    for (final suit in Suit.values) {
      for (final value in CardValue.values) {
        cardsDeck.add(Card(value, suit));
      }
    }

    cardsDeck.shuffle();
  }

  /// Вытащить карту из колоды. [isOpened] - рубашкой вверх или вниз.
  Card getCardFromDeck({bool isOpened = true}) {
    final randomCard = cardsDeck.last;
    randomCard.isOpened = isOpened;
    cardsDeck.removeLast();
    return randomCard;
  }

  @override
  void getNewCard(Person person) {
    final card = getCardFromDeck();
    person.hand.add(card);
  }

  @override
  void getStatus() => _printStatus();
}
