//
//  CardContainerView.swift
//  GraphicalSetGamee
//
//  Created by Tiago Maia Lopes on 09/02/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

/// The view responsible for holding and displaying a grid of cardButtons.
@IBDesignable
class SetCardsContainerView: CardsContainerView {
  
  // MARK: View life cycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // Only updates the buttons frames if the centered rect has changed,
    // This will occur when orientation changes.
    // This check will prevent frame changes while
    // the animator is doing it's job.
    if grid.frame != gridRect {
      updateViewsFrames()
    }
  }
  
  /// Draws the card buttons for storyboard display.
  /// - Note: The button's properties are randomly generated.
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    
    if numberOfButtonsForDisplay > 0 {
      addButtons(byAmount: numberOfButtonsForDisplay)
      
      respositionViews()
      
      for button: SetCardButton in buttons as! [SetCardButton] {
        button.alpha = 1
        button.isFaceUp = true
        
        button.symbolShape = SetCardButton.CardSymbolShape.randomized()
        button.color = SetCardButton.CardColor.randomized()
        button.symbolShading = SetCardButton.CardSymbolShading.randomized()
        button.numberOfSymbols = 4.arc4random
        
        if (button.numberOfSymbols == 0 || button.numberOfSymbols > 3) {
          button.numberOfSymbols = 1
        }
        
        button.setNeedsDisplay()
      }
    }
  }
  
  // MARK: Imperatives
  
  override func makeButtons(byAmount numberOfButtons: Int) -> [CardButton] {
    return (0..<numberOfButtons).map { _ in SetCardButton() }
  }
  
  /// Animates the passed buttons out of the table and on
  /// to the pile of matched cards.
  ///
  /// - Note: The animation takes place in three steps:
  ///         * A scale transformation is applied
  ///         * The buttons are concentrated in the center of this view
  ///         * The cards are flipped
  ///         * The cards are put in the matched pile
  override func animateCardsOut(_ buttons: [CardButton]) {
    guard discardToFrame != nil else { return }
    guard let buttons = buttons as? [SetCardButton] else { return }
    
    var buttonsCopies = [SetCardButton]()
    
    for button in buttons {
      // Creates the button copy used to be animated.
      let buttonCopy = button.copy(with: nil) as! SetCardButton
      buttonsCopies.append(buttonCopy)
      addSubview(buttonCopy)
      
      // Hides the original button.
      button.isActive = false
    }
    
    // Starts animating by scaling each button.
    UIViewPropertyAnimator.runningPropertyAnimator(
      withDuration: 0.1,
      delay: 0,
      options: .curveEaseIn,
      animations: {

        buttonsCopies.forEach {
          $0.bounds.size = CGSize(
            width: $0.frame.size.width * 1.1,
            height: $0.frame.size.height * 1.1
          )
        }
        
    }, completion: { position in
      
      // Animates each card to the center of the container view.
      UIViewPropertyAnimator.runningPropertyAnimator(
        withDuration: 0.2,
        delay: 0,
        options: .curveEaseIn,
        animations: {
          
          buttonsCopies.forEach { $0.center = self.center }
          
      }, completion: { position in
        // Flips each card down
        buttonsCopies.forEach { $0.flipCard() }
        
        // Animates each card to the matched deck.

        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
          buttonsCopies.forEach { button in
            let snapOutBehavior = UISnapBehavior(item: button, snapTo: self.discardToFrame.center)
            snapOutBehavior.damping = 0.8
            self.animator.addBehavior(snapOutBehavior)
            
            UIViewPropertyAnimator.runningPropertyAnimator(
              withDuration: 0.2,
              delay: 0,
              options: .curveEaseIn,
              animations: {
                button.bounds.size = self.discardToFrame.size
              }
            )
          }
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(
          withDuration: 0.2,
          delay: 1,
          options: .curveEaseInOut,
          animations: {
            buttonsCopies.forEach { $0.alpha = 0 }
        }) { _ in
          buttonsCopies.forEach {
            $0.removeFromSuperview()
          }
          
          // Calls the delegate, if set.
          if let delegate = self.delegate {
            delegate.cardsRemovalDidFinish()
          }
        }

      })
    })
  }
  
}

