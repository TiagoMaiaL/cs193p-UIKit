//
//  Concentration.swift
//  Concentration
//
//  Created by Tiago Maia Lopes on 1/17/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation
import GameplayKit

/// The concentration's delegate
protocol ConcentrationDelegate {
  
  /// Called after a match happens.
  func didMatch(cards: [Card])
}

class Concentration {
  
  // MARK: Properties
  
  /// The cards used in the game.
  private(set) var cards = [Card]()
  
  /// The only flipped card index. Used to track
  /// the first chosen card of a pair.
  ///
  /// This variable is used to verify if
  /// it's time to check for a match or not.
  private var oneAndOnlyFlippedCardIndex: Int? {
    get {
      return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
    }
    set {
      // Turns down any faced up pair.
      setCurrentPairToFaceDown()
      
      // Starts to compute the time the player is
      // taking to flip the next card.
      scoringDate = Date()
    }
  }
  
  /// The number of times the player flipped a card.
  private(set) var flipsCount = 0
  
  /// The date used to give a higher score to the player.
  /// It's set when the first card is flipped, and depending on the
  /// time taken for a match, we give a higher score or not.
  private var scoringDate: Date?
  
  /// The player's score.
  private(set) var score = 0
  
  /// The game's delegate
  var delegate: ConcentrationDelegate?
  
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
    // it means that we now have two faced up cards.
    // Thus we need to check for a match.
    if let firstCardIndex = oneAndOnlyFlippedCardIndex, firstCardIndex != index {
      
      var firstCard = cards[firstCardIndex]
      
      // Do we have a match?
      if firstCard == selectedCard {
        firstCard.isMatched = true
        selectedCard.isMatched = true
        increaseScore()
        
        delegate?.didMatch(cards: [firstCard, selectedCard])
        removeMatchedPair()
      }
      
      cards[firstCardIndex] = firstCard
    } else {
      // We don't have a single flipped card, it's time to set one.
      oneAndOnlyFlippedCardIndex = index
    }
    
    selectedCard.flipCard()
    
    flipsCount += 1
    cards[index] = selectedCard
  }
  
  /// Removes the matched pair out of the cards array.
  private func removeMatchedPair() {
    let matchedCards = cards.filter { $0.isMatched }
    
    guard !matchedCards.isEmpty else { return }
    
    for card in matchedCards {
      if let index = cards.index(of: card) {
        cards.remove(at: index)
      }
    }
  }
  
  /// Flips back the previous chosen pair,
  /// If the chosen cards were already seen,
  /// we should apply a penalization.
  private func setCurrentPairToFaceDown() {
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
  
  /// Increases the player's score.
  /// The incrememnt is also based on the time
  /// taken between two flips.
  private func increaseScore() {
    
    // The following Theme code is part of one of the extra credit tasks.
    // MARK: Extra credit 2
    // -------------------------
    if let scoringDate = scoringDate {
      let secondsBetweenFlips = Int(Date().timeIntervalSince(scoringDate))
      
      if secondsBetweenFlips < 2 {
        score += 3
      } else {
        score += 2
      }
      self.scoringDate = nil
    } else {
      score += 2
    }
    // -------------------------
  }
  
  /// Penalizes the player by one point.
  private func penalize() {
    score -= 1
  }
}

extension Collection {
  
  /// The only object in the collection,
  /// if only one is present.
  var oneAndOnly: Element? {
    return count == 1 ? first : nil
  }
  
}
