//
//  SetCardView.swift
//  GraphicalSetGamee
//
//  Created by Tiago Maia Lopes on 09/02/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

/// The view responsible for displaying a single card.
class SetCardButton: UIButton {

  // MARK: Internal types
  
  enum CardSymbolShape {
    case squiggle
    case diamong
    case oval
  }
  
  enum CardColor {
    case red
    case green
    case purple
    
    /// Returns the associated color.
    func get() -> UIColor {
      switch self {
      case .red:
        return #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
      case .green:
        return #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
      case .purple:
        return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
      }
    }
    
  }
  
  enum CardSymbolShading {
    case solid
    case striped
    case outlined
  }
  
  // MARK: Properties

  /// The symbol shape (diamong, squiggle or oval) for this card view.
  var symbolShape: CardSymbolShape?
  
  /// The number of symbols (one, two or three) for this card view.
  var numberOfSymbols = 0
  
  /// The symbol color (red, green or purple) for this card view.
  var color: CardColor?
  
  /// The symbol shading (solid, striped or open) for this card view.
  var symbolShading: CardSymbolShading?
  
  // MARK: Life cycle
  
  override func draw(_ rect: CGRect) {
    // TODO: Drawing code
  }

}
