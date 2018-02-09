//
//  SetCardView.swift
//  GraphicalSetGamee
//
//  Created by Tiago Maia Lopes on 09/02/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

/// The view responsible for displaying a single card.
class SetCardView: UIView {

  // MARK: Properties

  /// The symbol shape (diamong, squiggle or oval) for this card view.
  var symbolShape = 0
  
  /// The number of symbols (one, two or three) for this card view.
  var numberOfSymbols = 0
  
  /// The symbol color (red, green or purple) for this card view.
  var color: UIColor!
  
  /// The symbol shading (solid, striped or open) for this card view.
  var symbolShading = 0
  
  // MARK: Life cycle
  
  override func draw(_ rect: CGRect) {
    // TODO: Drawing code
  }

}
