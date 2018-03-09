//
//  ConcentrationCardButton.swift
//  AnimatedSetGamee
//
//  Created by Tiago Maia Lopes on 08/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class ConcentrationCardButton: CardButton {
  
  typealias Emoji = String

  // MARK: Properties
  
  /// The concentration text emoji.
  var buttonText: Emoji? {
    didSet {
      if isFaceUp {
        setNeedsDisplay()
      }
    }
  }
  
  /// The color of the back of the card when flipped down.
  var backColor: CGColor? {
    didSet {
      if !isFaceUp {
        setNeedsDisplay()
      }
    }
  }
  
  // MARK: Imperatives
  
  override func drawFront() {
    layer.backgroundColor = UIColor.white.cgColor
    titleLabel?.font = UIFont.systemFont(ofSize: 50)
    
    if let buttonText = buttonText {
      setTitle(buttonText, for: .normal)
    }
  }
  
  override func drawBack() {
    layer.backgroundColor = backColor ?? UIColor.gray.cgColor
    setTitle(nil, for: .normal)
  }

}
