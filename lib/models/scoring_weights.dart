class ScoringWeights {
  // Card values
  double ace = 1.00;
  double king = 0.75;
  double queen = 0.50;
  double jack = 0.25;
  double ten = 0.10;

  // Suit length bonuses
  double fiveCardBonus = 0.50;
  double sixCardBonus = 1.00;
  double sevenCardBonus = 1.50;

  // Card combination bonuses
  double akBonus = 0.50;
  double aqBonus = 0.30;
  double kqBonus = 0.20;

  // Reset everything to default values
  void reset() {
    ace = 1.00;
    king = 0.75;
    queen = 0.50;
    jack = 0.25;
    ten = 0.10;

    fiveCardBonus = 0.50;
    sixCardBonus = 1.00;
    sevenCardBonus = 1.50;

    akBonus = 0.50;
    aqBonus = 0.30;
    kqBonus = 0.20;
  }
}
