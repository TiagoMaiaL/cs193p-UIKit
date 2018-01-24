//
//  SetGame.swift
//  SetGame
//
//  Created by Tiago Maia Lopes on 1/23/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation

// TODO: Consider changing the decks to be a real set.
typealias SetDeck = Set<SetCard>
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
  
  /// The current displaying cards.
  private(set) var tableCards = [SetCard?]()
  
  // MARK: Initializers
  
  init() {
    _ = makeDeck()
  }
  
  // MARK: Imperatives
  
  /// The method responsible for selecting the chosen card.
  /// If three cards are selected, it should check for a match.
  func selectCard(_ card: SetCard) {
    // TODO:
  }
  
  /// Method in charge of dealing the game's cards.
  ///
  /// - Parameter forAmount: The number of cards to be dealt.
  func dealCards(forAmount amount: Int = 3) -> [SetCard] {
    guard deck.count >= amount else { return [] }
    
    var cardsToDeal = [SetCard]()
    
    for _ in 0..<amount {
      cardsToDeal.append(deck.removeFirst())
    }
    
    return cardsToDeal
  }
  
  /// Factory in charge of generating a valid Set deck with 81 cards.
  /// This method uses a recursive approach to generate each card from the four possible features.
  /// It starts with the Number feature and
  /// goes all the way through the Shading feature, the last one.
  ///
  /// - Parameter features: the features to be iterated and added to the cards in each call.
  /// - Parameter currentCombination: the combination model that's going to receive the new feature.
  private func makeDeck(features: [Feature] = Number.values,
                        currentCombination: FeatureCombination = FeatureCombination()) -> SetDeck {
    var currentCombination = currentCombination
    let nextFeatures: [Feature]?
    
    // TODO: Think of a better way to get the next features.
    // Gets the next features that should be added to the combination.
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
      
      // Does it have more features to be added?
      if let nextFeatures = nextFeatures {
        // Add the next features to the combinations.
        _ = makeDeck(features: nextFeatures, currentCombination: currentCombination)
      } else {
        // The current features are the last ones.
        // The combination is now complete, so a new card is created and added to the deck.
        deck.insert(SetCard(combination: currentCombination))
      }
    }
    
    return deck
  }
}
