//
//  SetCard.swift
//  SetGame
//
//  Created by Tiago Maia Lopes on 1/23/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation

/// A card of a Set game.
struct SetCard {
  
  /// The configured features that makes this card unique.
  private(set) var combination: FeatureCombination
  
}

/// A possible feature combination.
struct FeatureCombination {
  
  /// The number feature of the card.
  var number: Number?
  
  /// The color feature of the card.
  var color: Color?
  
  /// The symbol feature of the card.
  var symbol: Symbol?
  
  /// The shading feature of the card.
  var shading: Shading?
  
  /// Add a feature to the current combination instance.
  mutating func add(feature: Feature) {
    if feature is Number {
      
      number = feature as? Number
      
    } else if feature is Color {
      
      color = feature as? Color
      
    } else if feature is Symbol {
      
      symbol = feature as? Symbol
      
    } else if feature is Shading {
      
      shading = feature as? Shading
    }
  }
  
}

// TODO: Add proper documentation
protocol Feature {
  static var values: [Feature] { get }
}

enum Number: Int, Feature {
  
  case one
  case two
  case three
  
  static var values: [Feature] {
    return [Number.one, Number.two, Number.three]
  }
}

enum Color: Int, Feature {
  case red
  case green
  case purple
  
  static var values: [Feature] {
    return [Color.red, Color.green, Color.purple]
  }
}

enum Symbol: Int, Feature {
  case squiggle
  case diamond
  case oval
  
  static var values: [Feature] {
    return [Symbol.squiggle, Symbol.diamond, Symbol.oval]
  }
}

enum Shading: Int, Feature {
  case solid
  case striped
  case outlined
  
  static var values: [Feature] {
    return [Shading.solid, Shading.striped, Shading.outlined]
  }
}
