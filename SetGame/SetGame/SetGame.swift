//
//  SetGame.swift
//  SetGame
//
//  Created by Tiago Maia Lopes on 1/23/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation

typealias SetDeck = [SetCard]

/// The main class responsible for the set game's logic.
class SetGame {
  
  /// The game's deck.
  /// It represents all cards still available for dealing.
  private(set) var deck = SetDeck()
  
  /// The method responsible for selecting the chosen card.
  /// If three cards are selected, it should check for a match.
  func selectCard(_ card: SetCard) {
    
  }
  
  /// Method in charge of dealing the game's cards.
  /// - Parameter forAmount: The number of cards to be dealt.
  func dealCards(forAmount amount: Int = 3) -> [SetCard] {

  }
  
  /// Factory in charge of generating a valid Set deck.
  private func makeDeck() -> SetDeck {
    
  }
}
