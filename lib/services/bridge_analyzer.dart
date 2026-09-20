import '../models/hand_data.dart';
import '../models/scoring_weights.dart';

class BridgeAnalyzer {
  final ScoringWeights weights;

  BridgeAnalyzer(this.weights);

  // Calculate total strength of the complete hand
  double calculateStrength(HandData hand) {
    double score = 0;

    score += _scoreSuit(hand.spades);
    score += _scoreSuit(hand.hearts);
    score += _scoreSuit(hand.diamonds);
    score += _scoreSuit(hand.clubs);

    return score;
  }

  // Calculate strength of one suit
  double _scoreSuit(List<String> cards) {
    double score = 0;

    // -------------------------
    // Individual card values
    // -------------------------

    for (final card in cards) {
      switch (card) {
        case 'A':
          score += weights.ace;
          break;

        case 'K':
          score += weights.king;
          break;

        case 'Q':
          score += weights.queen;
          break;

        case 'J':
          score += weights.jack;
          break;

        case '10':
          score += weights.ten;
          break;
      }
    }

    // -------------------------
    // Suit length bonus
    // -------------------------

    if (cards.length == 5) {
      score += weights.fiveCardBonus;
    } else if (cards.length == 6) {
      score += weights.sixCardBonus;
    } else if (cards.length >= 7) {
      score += weights.sevenCardBonus;
    }

    // -------------------------
    // Combination bonuses
    // -------------------------

    if (cards.contains('A') && cards.contains('K')) {
      score += weights.akBonus;
    }

    if (cards.contains('A') && cards.contains('Q')) {
      score += weights.aqBonus;
    }

    if (cards.contains('K') && cards.contains('Q')) {
      score += weights.kqBonus;
    }

    return score;
  }

  // -------------------------
  // Estimate calls
  // -------------------------

  Map<String, int> calculateCalls(double strength) {
    final int medium = strength.round();

    final int safe = (strength - 0.5).floor().clamp(0, 13);

    final int highRisk = (strength + 1).ceil().clamp(0, 13);

    return {'safe': safe, 'medium': medium.clamp(0, 13), 'highRisk': highRisk};
  }
}
