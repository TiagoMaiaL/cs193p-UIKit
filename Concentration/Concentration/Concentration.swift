//
//  Concentration.swift
//  Concentration
//
//  Created by Tiago Maia Lopes on 1/17/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation

class Concentration {
  
  // MARK: Properties
  
  var cards = [Card]()
  
  private var previousFlippedCardIndex: Int?
  
  private(set) var flipsCount = 0
  
  // MARK: Initialization
  
  init(numberOfPairs: Int) {
    for _ in 0..<numberOfPairs {
      let currentCard = Card()

      cards.append(currentCard)
      cards.append(currentCard)
    }
    
    // TODO: Shuffle cards.
  }
  
  // MARK: Imperatives
  
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
