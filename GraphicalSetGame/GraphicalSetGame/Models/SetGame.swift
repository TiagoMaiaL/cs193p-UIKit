//
//  SetGame.swift
//  SetGame
//
//  Created by Tiago Maia Lopes on 1/23/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation

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
  
  /// The current displaying cards.
  ///
  /// - Note: Since a card can be matched and removed from the table,
  /// the type of each card is optional.
  private(set) var tableCards = [SetCard?]()
  
  /// The currently selected cards.
  private(set) var selectedCards = [SetCard]()
  
  /// The currently matched cards.
  private(set) var matchedCards = [SetCard]() {
    didSet {
      if matchedCards.count == 3 {
        matchedDeck.append(matchedCards)
      }
    }
  }
  
  /// The player's score.
  /// If the player has just made a match, increase it's score by 4,
  /// if the player has made a mismatch, decrease it by 2.
  /// The score can't be lower than zero.
  private(set) var score = 0 {
    didSet {
      if score < 0 {
        score = 0
      }
    }
  }
  
  // MARK: Initializers
  
  init() {
    deck = makeDeck()
  }
  
  // MARK: Imperatives
  
  /// The method responsible for selecting the chosen card.
  /// If three cards are selected, it should check for a match.
  func selectCard(at index: Int) {
    guard let card = tableCards[index] else { return }
    guard !matchedCards.contains(card) else { return }
   
    // Removes any matched cards from the table.
    if matchedCards.count > 0 {
      removeMatchedCardsFromTable()
      _ = dealCards()
    }
    
    // If the trio selected before wasn't a match,
    // Deselect it and penalize the player.
    if selectedCards.count == 3 {
      // The player shouldn't be able to deselect when three cards are selected.
      guard !selectedCards.contains(card) else { return }
      
      if !currentSelectionMatches() {
        score -= 2
      }
      
      selectedCards = []
    }
    
    // The selected card is added or removed.
    if let index = selectedCards.index(of: card) {
      selectedCards.remove(at: index)
    } else {
      selectedCards.append(card)
    }
    
    // If the new selected card makes a match,
    // increase the player's score, mark the current selection as matched
    // and deselect the current selection.
    if selectedCards.count == 3, currentSelectionMatches() {
      matchedCards = selectedCards
      selectedCards = []
      score += 4
    }
  }
  
  /// Removes any matched cards from the table cards.
  func removeMatchedCardsFromTable() {
    guard matchedCards.count == 3 else { return }
    
    for index in tableCards.indices {
      if let card = tableCards[index], matchedCards.contains(card) {
        tableCards[index] = nil
      }
    }
    
    matchedCards = []
  }
  
  /// Returns if the current selection is a match or not.
  private func currentSelectionMatches() -> Bool {
    guard selectedCards.count == 3 else { return false }
    return matches(selectedCards)
  }
  
  /// Checks if the given trio of cards performs a match.
  ///
  /// - Parameter cards: the cards to be checked for a match, as per the rules of Set.
  private func matches(_ cards: SetTrio) -> Bool {
    let first = cards[0]
    let second = cards[1]
    let third = cards[2]
    
    // A Set is used because of it's unique value constraint.
    // Since we have to compare each feature for equality or inequality,
    // using a Set and checking it's count can give the result.
    let numbersFeatures = Set([first.combination.number, second.combination.number, third.combination.number])
    let colorsFeatures = Set([first.combination.color, second.combination.color, third.combination.color])
    let symbolsFeatures = Set([first.combination.symbol, second.combination.symbol, third.combination.symbol])
    let shadingsFeatures = Set([first.combination.shading, second.combination.shading, third.combination.shading])
    
    // All features must be either equal (with the set count of 1)
    // or all different (with the count of 3)
    return (numbersFeatures.count == 1 || numbersFeatures.count == 3) &&
           (colorsFeatures.count == 1 || colorsFeatures.count == 3) &&
           (symbolsFeatures.count == 1 || symbolsFeatures.count == 3) &&
           (shadingsFeatures.count == 1 || shadingsFeatures.count == 3)
  }
  
  /// Method in charge of dealing the game's cards.
  ///
  /// - Parameter forAmount: The number of cards to be dealt.
  func dealCards(forAmount amount: Int = 3) -> [SetCard] {
    guard amount > 0 else { return [] }
    guard deck.count >= amount else { return [] }
    
    var cardsToDeal = [SetCard]()
    
    for _ in 0..<amount {
      cardsToDeal.append(deck.removeFirst())
    }
    
    for (index, card) in tableCards.enumerated() {
      if card == nil {
        tableCards[index] = cardsToDeal.removeFirst()
      }
    }
    
    if !cardsToDeal.isEmpty {
      tableCards += cardsToDeal as [SetCard?]
    }
    
    return cardsToDeal
  }
  
  /// Finishes the current running game and starts a fresh new one.
  func reset() {
    deck = makeDeck()
    matchedCards = []
    selectedCards = []
    matchedDeck = []
    tableCards = []
    score = 0
  }
  
  /// Factory in charge of generating a valid Set deck with 81 cards.
  /// This method uses a recursive approach to generate each card from the four possible features.
  /// It starts with the Number feature and
  /// goes all the way through the Shading feature, the last one.
  ///
  /// - Parameter features: the features to be iterated and added to the cards in each call.
  /// - Parameter currentCombination: the combination model that's going to receive the new feature.
  /// - Parameter deck: the deck in which the generated cards are going to be added.
  private func makeDeck(features: [Feature] = Number.values,
                        currentCombination: FeatureCombination = FeatureCombination(),
                        deck: SetDeck = SetDeck()) -> SetDeck {
    var deck = deck
    var currentCombination = currentCombination
    // Gets the next features that should be added to the combination.
    let nextFeatures = type(of: features[0]).getNextFeatures()
    
    for feature in features {
      currentCombination.add(feature: feature)
      
      // Does it have more features to be added?
      if let nextFeatures = nextFeatures {
        // Add the next features to the combinations.
        deck = makeDeck(features: nextFeatures, currentCombination: currentCombination, deck: deck)
      } else {
        // The current features are the last ones.
        // The combination is now complete, so a new card is created and added to the deck.
        deck.append(SetCard(combination: currentCombination))
      }
    }
    
    return deck.shuffled()
  }
}

import GameKit

extension Array {
  /// Returns the current instance with all
  /// of it's elements in a random order.
  func shuffled() -> [Element] {
    return GKRandomSource.sharedRandom().arrayByShufflingObjects(in: self) as! [Element]
  }
}
