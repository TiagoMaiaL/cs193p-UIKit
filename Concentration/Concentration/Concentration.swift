//
//  Concentration.swift
//  Concentration
//
//  Created by Tiago Maia Lopes on 1/17/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation
import GameplayKit

class Concentration {
  
  // MARK: Properties
  
  /// The cards used in the game.
  var cards = [Card]()
  
  /// The only flipped card index. Used to track
  /// the first chosen card of a pair.
  ///
  /// This variable is used to verify if
  /// it's time to check for match or not.
  private var oneAndOnlyFlippedCard: Int?
  
  /// The number of times the player flipped a card.
  private(set) var flipsCount = 0
  
  /// The player's score.
  private(set) var score = 0
  
  // MARK: Initialization
  
  /// Prepares all the needed cards based
  /// on the passed amount of pairs.
  init(numberOfPairs: Int) {
    setPairs(withCount: numberOfPairs)
  }
  
  // MARK: Imperatives
  
  /// Resets the current concentration game.
  func resetGame() {
    flipsCount = 0
    score = 0
    
    Card.resetIdentifiersCount()
    let pairsCount = cards.count / 2
    cards = []
    setPairs(withCount: pairsCount)
  }
  
  /// Populates the cards used in the game.
  /// The amount of cards is determined by the number of pairs.
  private func setPairs(withCount numberOfPairs: Int) {
    for _ in 0..<numberOfPairs {
      let currentCard = Card()
      
      cards.append(currentCard)
      cards.append(currentCard)
    }
    
    // Shuffles the cards array.
    cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! [Card]
  }
  
  /// Flips the card with the given index.
  /// This is where all the game's logic is applied.
  func flipCard(at index: Int) {
    var selectedCard = cards[index]
    
    // If the card was matched, ignore the flip request.
    guard !selectedCard.isMatched else { return }
    
    // If we already have one previously flipped card,
    // This also means that we now have two faced up cards.
    // Thus we need to check for a match.
    if let firstCardIndex = oneAndOnlyFlippedCard, firstCardIndex != index {
      
      var firstCard = cards[firstCardIndex]
      
      // Do we have a match?
      if firstCard.identifier == selectedCard.identifier {
        firstCard.isMatched = true
        selectedCard.isMatched = true
        score += 2
      }

      // No single card is faced up anymore.
      oneAndOnlyFlippedCard = nil
      
      cards[firstCardIndex] = firstCard
    } else {
      // We don't have a single flipped card, it's time to set one.
      // And the player missed the right cards,
      // in case it's not the first flip.
      setCurrentPairToFaceDown()

      oneAndOnlyFlippedCard = index
    }
    
    selectedCard.flipCard()
    
    
    flipsCount += 1
    cards[index] = selectedCard
  }
  
  /// Flips back the previous chosen pair,
  /// If the chosen cards were already seen,
  /// we should apply a penalization.
  func setCurrentPairToFaceDown() {
    /// Indicates if the penalty was already applied.
    var didPenalize = false
    
    // Loops through all cards to face them down,
    // and it also checks for missmatches penalty.
    for cardIndex in cards.indices {
      var currentCard = cards[cardIndex]
      
      if currentCard.isFaceUp {
        
        // We check if we should penalize the player,
        // in the case of an already seen card.
        if currentCard.hasBeenFlipped && !currentCard.isMatched && !didPenalize {
          penalize()
          // The penalization should be applied only once.
          didPenalize = true
        }
        
        // The flipped state is applied after the check for penalty is made.
        currentCard.hasBeenFlipped = true
        currentCard.setFaceDown()
      }
      
      cards[cardIndex] = currentCard
    }
  }
  
  /// Penalizes the player by one point.
  func penalize() {
    score -= 1
  }
  
}
