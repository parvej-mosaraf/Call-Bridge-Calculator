import 'package:flutter/material.dart';

import '../models/hand_data.dart';
import '../models/scoring_weights.dart';
import '../services/bridge_analyzer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSuit = 0;

  final suits = ['♠', '♥', '♦', '♣'];

  final hand = {
    '♠': <String>[],
    '♥': <String>[],
    '♦': <String>[],
    '♣': <String>[],
  };

  final ranks = [
    'A',
    'K',
    'Q',
    'J',
    '10',
    '9',
    '8',
    '7',
    '6',
    '5',
    '4',
    '3',
    '2',
  ];

  final ScoringWeights weights = ScoringWeights();

  late BridgeAnalyzer analyzer;

  double? strength;
  Map<String, int>? calls;

  @override
  void initState() {
    super.initState();
    analyzer = BridgeAnalyzer(weights);
  }

  void addCard(String card) {
    final suit = suits[currentSuit];

    if (hand[suit]!.length >= 13) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This suit already has 13 cards.')),
      );
      return;
    }

    if (hand[suit]!.contains(card)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$card is already entered.')));
      return;
    }

    setState(() {
      hand[suit]!.add(card);
      strength = null;
      calls = null;
    });
  }

  void deleteCard() {
    final suit = suits[currentSuit];

    if (hand[suit]!.isNotEmpty) {
      setState(() {
        hand[suit]!.removeLast();
        strength = null;
        calls = null;
      });
    }
  }

  void nextSuit() {
    if (currentSuit < 3) {
      setState(() {
        currentSuit++;
      });
    } else {
      final totalCards = hand.values.fold(
        0,
        (sum, cards) => sum + cards.length,
      );

      if (totalCards != 13) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You entered $totalCards cards. A hand must contain exactly 13 cards.',
            ),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All 13 cards entered. Press RESULT.')),
      );
    }
  }

  void showResult() {
    final totalCards = hand.values.fold(0, (sum, cards) => sum + cards.length);

    if (totalCards != 13) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You entered $totalCards cards. Please enter exactly 13 cards.',
          ),
        ),
      );
      return;
    }

    final handData = HandData()
      ..spades = List<String>.from(hand['♠']!)
      ..hearts = List<String>.from(hand['♥']!)
      ..diamonds = List<String>.from(hand['♦']!)
      ..clubs = List<String>.from(hand['♣']!);

    final calculatedStrength = analyzer.calculateStrength(handData);

    final calculatedCalls = analyzer.calculateCalls(calculatedStrength);

    setState(() {
      strength = calculatedStrength;
      calls = calculatedCalls;
    });
  }

  void resetHand() {
    setState(() {
      currentSuit = 0;

      for (final suit in suits) {
        hand[suit]!.clear();
      }

      strength = null;
      calls = null;
    });
  }

  int get totalCards {
    return hand.values.fold(0, (sum, cards) => sum + cards.length);
  }

  @override
  Widget build(BuildContext context) {
    final currentSuitSymbol = suits[currentSuit];
    final currentCards = hand[currentSuitSymbol]!;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1B1B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Bridge Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 22,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ================= DISPLAY =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF202020),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'SUIT ${currentSuit + 1} OF 4',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              letterSpacing: 1.4,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            currentSuitSymbol,
                            style: TextStyle(
                              color:
                                  currentSuitSymbol == '♥' ||
                                      currentSuitSymbol == '♦'
                                  ? Colors.redAccent
                                  : Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 2),

                          SizedBox(
                            height: 30,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                currentCards.isEmpty
                                    ? 'No cards entered'
                                    : currentCards.join('  '),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            '${currentCards.length} cards  •  Total: $totalCards / 13',
                            style: TextStyle(
                              color: totalCards == 13
                                  ? Colors.greenAccent
                                  : Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ================= RESULT =================
                    if (calls != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF202020),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'CALL ESTIMATION',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              'Strength: ${strength!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _resultBox('SAFE', calls!['safe']!),
                                _resultBox('MEDIUM', calls!['medium']!),
                                _resultBox('HIGH', calls!['highRisk']!),
                              ],
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 8),

                    // ================= SUITS =================
                    Row(
                      children: List.generate(suits.length, (index) {
                        final suit = suits[index];
                        final selected = currentSuit == index;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                currentSuit = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                right: index == 3 ? 0 : 5,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.white12
                                    : const Color(0xFF1B1B1B),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selected
                                      ? Colors.white38
                                      : Colors.white10,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    suit,
                                    style: TextStyle(
                                      color: suit == '♥' || suit == '♦'
                                          ? Colors.redAccent
                                          : Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),

                                  const SizedBox(width: 4),

                                  Text(
                                    '${hand[suit]!.length}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 8),

                    // ================= KEYPAD =================
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ranks.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: 7,
                            childAspectRatio: 1.9,
                          ),
                      itemBuilder: (context, index) {
                        final rank = ranks[index];

                        return _keyButton(
                          text: rank,
                          onPressed: () => addCard(rank),
                        );
                      },
                    ),

                    const SizedBox(height: 7),

                    // ================= DEL / DONE =================
                    Row(
                      children: [
                        Expanded(
                          child: _actionButton(
                            text: 'DEL',
                            icon: Icons.backspace_outlined,
                            onPressed: deleteCard,
                          ),
                        ),

                        const SizedBox(width: 7),

                        Expanded(
                          child: _actionButton(
                            text: currentSuit == 3 ? 'FINISH' : 'DONE',
                            icon: Icons.arrow_forward,
                            onPressed: nextSuit,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // ================= RESULT / RESET =================
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: showResult,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'RESULT',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 7),

                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: resetHand,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'RESET',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // =========================================================
  // KEY BUTTON
  // =========================================================

  Widget _keyButton({required String text, required VoidCallback onPressed}) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF292929),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: Colors.white10),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // =========================================================
  // ACTION BUTTON
  // =========================================================

  Widget _actionButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 19),
        label: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF252525),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: Colors.white12),
        ),
      ),
    );
  }

  // =========================================================
  // RESULT BOX
  // =========================================================

  Widget _resultBox(String title, int value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          '$value',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
