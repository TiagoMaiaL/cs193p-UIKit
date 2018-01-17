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
  
  var cards: [Card] = []
  
  private var flippedCard: Card?
  
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
    // It's going to take care of which card is flipped.
    // And Check if there's a match.
    
    cards[index].flipped = !cards[index].flipped
  }
  
}
