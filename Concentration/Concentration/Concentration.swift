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
  
  var cards = [Card]()
  
  private var previousFlippedCardIndex: Int?
  
  private(set) var flipsCount = 0
  
  // MARK: Initialization
  
  init(numberOfPairs: Int) {
    setPairs(withCount: numberOfPairs)
  }
  
  // MARK: Imperatives
  
  func resetGame() {
    Card.resetIdentifiersCount()
    let pairsCount = cards.count / 2
    cards = []
    setPairs(withCount: pairsCount)
  }
  
  private func setPairs(withCount numberOfPairs: Int) {
    for _ in 0..<numberOfPairs {
      let currentCard = Card()
      
      cards.append(currentCard)
      cards.append(currentCard)
    }
    
    cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! [Card]
  }
  
  func flipCard(with index: Int) {
    var selectedCard = cards[index]
    
    guard !selectedCard.isMatched else { return }
    
    if let flippedIndex = previousFlippedCardIndex {
      var flippedCard = cards[flippedIndex]
      
      if flippedCard.identifier == selectedCard.identifier {
        flippedCard.isMatched = true
        selectedCard.isMatched = true
      }

      self.previousFlippedCardIndex = nil
      
      cards[flippedIndex] = flippedCard
    } else {
      for index in cards.indices {
        cards[index].setFaceDown()
      }
      
      previousFlippedCardIndex = index
    }
    
    selectedCard.flipCard()
    flipsCount += 1
    cards[index] = selectedCard
  }
  
}
