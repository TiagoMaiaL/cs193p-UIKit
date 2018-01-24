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
  
  /// The number feature of the card.
  let number: NumberCardFeature
  
  /// The color feature of the card.
  let color: ColorCardFeature
  
  /// The symbol feature of the card.
  let symbol: SymbolCardFeature
  
  /// The shading feature of the card.
  let shading: ShadingCardFeature
  
}

enum NumberCardFeature {
  case one
  case two
  case three
}

enum ColorCardFeature {
  case red
  case green
  case purple
}

enum SymbolCardFeature {
  case squiggle
  case diamong
  case oval
}

enum ShadingCardFeature {
  case solid
  case striped
  case outlined
}
