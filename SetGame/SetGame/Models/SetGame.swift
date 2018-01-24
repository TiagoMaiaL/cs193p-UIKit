//
//  SetGame.swift
//  SetGame
//
//  Created by Tiago Maia Lopes on 1/23/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation

// TODO: Consider changing the decks to be a real set.
typealias SetDeck = [SetCard]
typealias SetTrio = [SetCard]

/// The main class responsible for the set game's logic.
class SetGame {
  
  // MARK: Properties
  
  /// The game's deck.
  /// It represents all cards still available for dealing.
  private(set) var deck = SetDeck()
  
  /// The matched trios of cards.
  /// Every time the player makes a match,
  /// the matched trio is added to this deck.
  private(set) var matchedDeck = [SetTrio]()
  
  // MARK: Initializers
  
  init() {
    deck = makeDeck()
    
  }
  
  // MARK: Imperatives
  
  /// The method responsible for selecting the chosen card.
  /// If three cards are selected, it should check for a match.
  func selectCard(_ card: SetCard) {
    // TODO:
  }
  
  /// Method in charge of dealing the game's cards.
  /// - Parameter forAmount: The number of cards to be dealt.
  func dealCards(forAmount amount: Int = 3) -> [SetCard] {
    // TODO:
    return []
  }
  
  /// Factory in charge of generating a valid Set deck with 81 cards.
  // TODO: Add proper documentation
  private func makeDeck(features: [Feature] = Number.values, currentCombination: FeatureCombination = FeatureCombination()) -> SetDeck {
    var currentCombination = currentCombination
    let nextFeatures: [Feature]?
    
    if features.first is Number {
      nextFeatures = Color.values
    } else if features.first is Color {
      nextFeatures = Symbol.values
    } else if features.first is Symbol {
      nextFeatures = Shading.values
    } else {
      nextFeatures = nil
    }
    
    for feature in features {
      currentCombination.add(feature: feature)
      
      if let nextFeatures = nextFeatures {
        _ = makeDeck(features: nextFeatures, currentCombination: currentCombination)
      } else {
        deck.append(SetCard(combination: currentCombination))
      }
    }
    
    return deck
  }
}
