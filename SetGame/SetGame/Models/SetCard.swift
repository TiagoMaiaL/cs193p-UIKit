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
  
  /// The combined features that makes this card unique.
  private(set) var combination: FeatureCombination
  
  /// Indicates if the card is selected.
  var isSelected = false
  
  /// Indicates if the card is matched.
  var isMatched = false
  
  init(combination: FeatureCombination) {
    self.combination = combination
  }
}

extension SetCard: Hashable {
  
  /// An Int based on each feature from the combination.
  var hashValue: Int {
    return Int("\(combination.number!.rawValue)\(combination.color!.rawValue)\(combination.symbol!.rawValue)\(combination.shading!.rawValue)")!
  }
  
  /// A card is equals to another if they have the same combination.
  static func ==(lhs: SetCard, rhs: SetCard) -> Bool {
    return lhs.combination == rhs.combination
  }
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

extension FeatureCombination: Equatable {
  
  /// A combination is equals to another if it's features are identical.
  static func ==(lhs: FeatureCombination, rhs: FeatureCombination) -> Bool {
    return lhs.number == rhs.number &&
      lhs.color == rhs.color &&
      lhs.symbol == rhs.symbol &&
      lhs.shading == rhs.shading
  }
}

/// A card's feature.
protocol Feature {
  
  /// The possible values of the current feature.
  static var values: [Feature] { get }
}

/// The enum representing the possible
/// Number feature values of a card in a set game.
enum Number: Int, Feature {
  case one
  case two
  case three
  
  static var values: [Feature] {
    return [Number.one, Number.two, Number.three]
  }
}

/// The enum representing the possible
/// Color feature values of a card in a set game.
enum Color: Int, Feature {
  case red
  case green
  case purple
  
  static var values: [Feature] {
    return [Color.red, Color.green, Color.purple]
  }
}

/// The enum representing the possible
/// Symbol feature values of a card in a set game.
enum Symbol: Int, Feature {
  case squiggle
  case diamond
  case oval
  
  static var values: [Feature] {
    return [Symbol.squiggle, Symbol.diamond, Symbol.oval]
  }
}

/// The enum representing the possible
/// Shading feature values of a card in a set game.
enum Shading: Int, Feature {
  case solid
  case striped
  case outlined
  
  static var values: [Feature] {
    return [Shading.solid, Shading.striped, Shading.outlined]
  }
}
