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
//    guard let context = UIGraphicsGetCurrentContext() else { return }
    // TODO: Drawing code
    // TODO: Ovals
    // TODO: Diamonds
    // TODO: Squiggles - Complex shape -> bezier curves.
    
    drawSquiggles()
  }

  // MARK: Imperatives
  
  private func drawSquiggles() {
    // Basic code to draw squiggles
    
    let path = UIBezierPath()
    let centerX = frame.size.width / 2
    let beginY: CGFloat = 100
    
    
    path.move(to: CGPoint(x: centerX - 2, y: beginY))
    
    path.addQuadCurve(to: CGPoint(x: centerX - 5, y: beginY + 55),
                      controlPoint: CGPoint(x: centerX + 10, y: beginY + 25))
    
    path.addCurve(to: CGPoint(x: centerX + 35, y: beginY + 70),
                  controlPoint1: CGPoint(x: centerX - 20, y: beginY + 105),
                  controlPoint2: CGPoint(x: centerX + 60, y: beginY + 90))
    
    path.addCurve(to: CGPoint(x: centerX + 25, y: beginY),
                  controlPoint1: CGPoint(x: centerX + 8, y: beginY + 60),
                  controlPoint2: CGPoint(x: centerX + 25, y: beginY + 10))
    
    path.addCurve(to: CGPoint(x: centerX - 2, y: beginY),
                  controlPoint1: CGPoint(x: centerX + 45, y: beginY - 50),
                  controlPoint2: CGPoint(x: centerX - 55, y: beginY - 25))
    
    UIColor.green.setStroke()
    path.lineWidth = 1
    path.stroke()
    
  }
  
  private func drawOvals() {
    // Basic code to draw ovals
    //    let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 50, height: 100), cornerRadius: 50)
    //    UIColor.green.setStroke()
    //    path.lineWidth = 10
    //    path.stroke()
  }
  
  private func drawDiamonds() {
    // Basic code for creating a diamond shape.
    //    let path = UIBezierPath()
    //    path.move(to: CGPoint(x: frame.size.width / 2, y: 0))
    //    path.addLine(to: CGPoint(x: 0, y: frame.size.height / 2))
    //    path.addLine(to: CGPoint(x: frame.size.width / 2, y: frame.size.height))
    //    path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height / 2))
    //    path.close()
    //
    //    UIColor.orange.setFill()
    //    path.fill()
    //
    //    UIColor.green.setStroke()
    //    path.lineWidth = 10
    //    path.stroke()
  }
  
}
