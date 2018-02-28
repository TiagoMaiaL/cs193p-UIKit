//
//  SetCardView.swift
//  GraphicalSetGamee
//
//  Created by Tiago Maia Lopes on 09/02/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

/// The view responsible for displaying a single card.
class SetCardButton: UIButton, NSCopying {
  
  // MARK: Internal types
  
  enum CardSymbolShape {
    case squiggle
    case diamond
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
        return #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
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
  var symbolShape: CardSymbolShape? {
    didSet {
      setNeedsDisplay()
    }
  }
  
  /// The number of symbols (one, two or three) for this card view.
  var numberOfSymbols = 0 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  /// The symbol color (red, green or purple) for this card view.
  var color: CardColor? {
    didSet {
      setNeedsDisplay()
    }
  }
  
  /// The symbol shading (solid, striped or open) for this card view.
  var symbolShading: CardSymbolShading? {
    didSet {
      setNeedsDisplay()
    }
  }
  
  var isFaceUp = true {
    didSet {
      setNeedsDisplay()
    }
  }
  
  /// The path containing all shapes of this view.
  private var path: UIBezierPath?
  
  /// The rect in which each path is drawn.
  private var drawableRect: CGRect {
    let drawableWidth = frame.size.width * 0.80
    let drawableHeight = frame.size.height * 0.90
    
    return CGRect(x: frame.size.width * 0.1,
                  y: frame.size.height * 0.05,
                  width: drawableWidth,
                  height: drawableHeight)
  }
  
  private var shapeHorizontalMargin: CGFloat {
    return drawableRect.width * 0.05
  }
  
  private var shapeVerticalMargin: CGFloat {
    return drawableRect.height * 0.05 + drawableRect.origin.y
  }
  
  private var shapeWidth: CGFloat {
    return (drawableRect.width - (2 * shapeHorizontalMargin)) / 3
  }
  
  private var shapeHeight: CGFloat {
    return drawableRect.size.height * 0.9
  }
  
  private var drawableCenter: CGPoint {
    return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
  }
  
  // MARK: Life cycle
  
  override func draw(_ rect: CGRect) {
    layer.cornerRadius = 10
    layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    layer.borderWidth = 0.5
    
    if isFaceUp {
      drawSetShapes()
    } else {
      drawBack()
    }
  }
  
  /// Draws the shapes configured within this card.
  private func drawSetShapes() {
    guard let shape = symbolShape else { return }
    guard let color = color?.get() else { return }
    guard let shading = symbolShading else { return }
    guard numberOfSymbols <= 3 || numberOfSymbols > 0 else { return }
    
    switch shape {
    case .squiggle:
      drawSquiggles(byAmount: numberOfSymbols)
      
    case .diamond:
      drawDiamonds(byAmount: numberOfSymbols)
      
    case .oval:
      drawOvals(byAmount: numberOfSymbols)
    }
    
    path!.lineCapStyle = .round
    
    switch shading {
    case .solid:
      color.setFill()
      path!.fill()
      
    case .outlined:
      color.setStroke()
      path!.lineWidth = 1 // TODO: Calculate the line width
      path!.stroke()
      
    case .striped:
      path!.lineWidth = 0.01 * frame.size.width
      color.setStroke()
      path!.stroke()
      path!.addClip()
      
      var currentX: CGFloat = 0
      
      let stripedPath = UIBezierPath()
      stripedPath.lineWidth = 0.005 * frame.size.width
      
      while currentX < frame.size.width {
        stripedPath.move(to: CGPoint(x: currentX, y: 0))
        stripedPath.addLine(to: CGPoint(x: currentX, y: frame.size.height))
        currentX += 0.03 * frame.size.width
      }
      
      color.setStroke()
      stripedPath.stroke()
      
      break
    }
  }
  
  /// Draws the back of the card.
  private func drawBack() {
    layer.backgroundColor = UIColor.red.cgColor
  }

  // MARK: Imperatives
  
  /// Flips the card with a flip transition from left to right.
  ///
  /// - Paramater withCompletion: completion block called after the end of the transition animation.
  func flipCard(withCompletion completion: Optional<(SetCardButton) -> ()> = nil) {
    UIView.transition(with: self,
                      duration: 0.2,
                      options: .transitionFlipFromLeft,
                      animations: {
                        self.isFaceUp = !self.isFaceUp
    }) { completed in
      if let completion = completion {
        completion(self)
      }
    }
  }
  
  /// Draws the squiggles to the drawable rect.
  private func drawSquiggles(byAmount amount: Int) {
    let path = UIBezierPath()
    let allSquigglesWidth = CGFloat(numberOfSymbols) * shapeWidth + CGFloat(numberOfSymbols - 1) * shapeHorizontalMargin
    let beginX = (frame.size.width - allSquigglesWidth) / 2
    
    for i in 0..<numberOfSymbols {
      let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + (CGFloat(i) * shapeHorizontalMargin)
      let currentShapeY = shapeVerticalMargin
      let curveXOffset = shapeWidth * 0.35
      
      path.move(to: CGPoint(x: currentShapeX, y: currentShapeY))

      path.addCurve(to: CGPoint(x: currentShapeX, y: currentShapeY + shapeHeight),
                    controlPoint1: CGPoint(x: currentShapeX + curveXOffset, y: currentShapeY + shapeHeight / 3),
                    controlPoint2: CGPoint(x: currentShapeX - curveXOffset, y: currentShapeY + (shapeHeight / 3) * 2))
      
      path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY + shapeHeight))
      
      path.addCurve(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY),
                    controlPoint1: CGPoint(x: currentShapeX + shapeWidth - curveXOffset, y: currentShapeY + (shapeHeight / 3) * 2),
                    controlPoint2: CGPoint(x: currentShapeX + shapeWidth + curveXOffset, y: currentShapeY + shapeHeight / 3))
      
      path.addLine(to: CGPoint(x: currentShapeX, y: currentShapeY))
    }
    
    self.path = path
  }
  
  /// Draws the ovals to the drawable rect.
  private func drawOvals(byAmount amount: Int) {
    let allOvalsWidth = CGFloat(numberOfSymbols) * shapeWidth + CGFloat(numberOfSymbols - 1) * shapeHorizontalMargin
    let beginX = (frame.size.width - allOvalsWidth) / 2
    path = UIBezierPath()
    
    for i in 0..<numberOfSymbols {
      let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + (CGFloat(i) * shapeHorizontalMargin)

      path!.append(UIBezierPath(roundedRect: CGRect(x: currentShapeX,
                                                    y: shapeVerticalMargin,
                                                    width: shapeWidth,
                                                    height: shapeHeight),
                                cornerRadius: shapeWidth))
    }
  }
  
  /// Draws the diamonds to the drawable rect.
  private func drawDiamonds(byAmount amount: Int) {
    let allDiamondsWidth = CGFloat(numberOfSymbols) * shapeWidth + CGFloat(numberOfSymbols - 1) * shapeHorizontalMargin
    let beginX = (frame.size.width - allDiamondsWidth) / 2
    
    let path = UIBezierPath()
    
    for i in 0..<numberOfSymbols {
      let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + (CGFloat(i) * shapeHorizontalMargin)
      
      path.move(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin))
      path.addLine(to: CGPoint(x: currentShapeX, y: drawableCenter.y))
      path.addLine(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin + shapeHeight))
      path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: drawableCenter.y))
      path.addLine(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin))
    }
    
    self.path = path
  }
  
  // MARK: NSCopying implementation
  
  func copy(with zone: NSZone? = nil) -> Any {
    let newCardButton = SetCardButton()
    newCardButton.frame = frame
    newCardButton.layer.backgroundColor = layer.backgroundColor
    newCardButton.symbolShape = symbolShape
    newCardButton.numberOfSymbols = numberOfSymbols
    newCardButton.color = color
    newCardButton.symbolShading = symbolShading
    
    return newCardButton
  }

}
