//
//  Card.swift
//  Concentration
//
//  Created by Tiago Maia Lopes on 1/17/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation

struct Card {
  
  // MARK: Properties
  
  let identifier: Int
  var isMatched = false
  var wasFlipped = false
  var isFaceUp = false
  var wasSeen: Bool {
    get {
      return wasFlipped && !isMatched
    }
  }
  
  // MARK: Initializer
  
  init() {
    identifier = Card.makeIdentifier()
  }
  
  // MARK: Static properties and methods
  
  private static var identifiersCount = -1
  
  static func resetIdentifiersCount() {
    identifiersCount = -1
  }
  
  static func makeIdentifier() -> Int {
    identifiersCount += 1
    return identifiersCount
  }
  
  mutating func flipCard() {
    isFaceUp = !isFaceUp
  }
  
  mutating func setFaceDown() {
    if isFaceUp {
      isFaceUp = false
    }
  }

}
