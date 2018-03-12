//
//  ConcentrationCardsContainerView.swift
//  AnimatedSetGamee
//
//  Created by Tiago Maia Lopes on 08/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class ConcentrationCardsContainerView: CardsContainerView, UIDynamicAnimatorDelegate {

  // TODO: Prepare for IB.
  
  // MARK: Properties
  
  private var discardToFrame: CGRect!
  
  private var dealingFromFrame: CGRect!
  
  lazy private var animator = UIDynamicAnimator(referenceView: self)
  
  // MARK: Initializer
  
  override func awakeFromNib() {
    animator.delegate = self
    
    let discardToOrigin = convert(CGPoint(x: UIScreen.main.bounds.width,
                                          y: UIScreen.main.bounds.height / 2),
                                  to: self)
    discardToFrame = CGRect(origin: discardToOrigin,
                            size: CGSize(width: 80,
                                         height: 120))
    
    let dealFromOrigin = convert(CGPoint(x: 0,
                                         y: UIScreen.main.bounds.height),
                                 to: self)
    dealingFromFrame = CGRect(origin: dealFromOrigin,
                              size: CGSize(width: 80,
                                           height: 120))
  }
  
  // MARK: Imperatives
  
  // TODO: Refactor this: Put in the superclass.
  func addButtons(byAmount numberOfButtons: Int = 2, animated: Bool = true) {
    // Check to see if a deal animation is being performed.
    
    let cardButtons = (0..<numberOfButtons).map { _ in ConcentrationCardButton() }
    
    for button in cardButtons {
      // Each button is hidden and face down by default.
      button.isActive = false
      button.isFaceUp = false
      
      addSubview(button)
      buttons.append(button)
    }
    
    grid.cellCount += cardButtons.count
    grid.frame = gridRect
    
    if animated {
      dealCardsWithAnimation()
    }
  }
  
  // TODO: Consider changing this to the superclass.
  func dealCardsWithAnimation() {
    let inactiveButtons = buttons.filter { !$0.isActive }
    
    guard !inactiveButtons.isEmpty else { return }
    
    updateViewsFrames(withAnimation: true) {
      var dealAnimationDelay = 0.0
      for (index, button) in inactiveButtons.enumerated() {
        guard let buttonFrame = self.grid[index] else { continue }
        
        button.isFaceUp = false
        button.frame = self.dealingFromFrame
        
        self.bringSubview(toFront: button)
        
        button.isActive = true
        
        let snapBehavior = UISnapBehavior(item: button,
                                          snapTo: buttonFrame.center)
        snapBehavior.damping = 1
        
        Timer.scheduledTimer(withTimeInterval: dealAnimationDelay, repeats: false) { _ in
          // Apply the snap behavior.
          self.animator.addBehavior(snapBehavior)
          
          // Animates the button's size.
          UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: {
              button.bounds.size = buttonFrame.size
            }
          )
        }
        
        dealAnimationDelay += 0.2
      }
    }
  }
  
  override func animateCardsOut(_ buttons: [CardButton]) {
    guard discardToFrame != nil else { return }
    guard let buttons = buttons as? [ConcentrationCardButton] else { return }
    
    var buttonsCopies = [ConcentrationCardButton]()
    
    for button in buttons {
      // Creates the button copy used to be animated.
      let buttonCopy = button.copy() as! ConcentrationCardButton
      buttonsCopies.append(buttonCopy)
      addSubview(buttonCopy)
      
      // Hides the original button.
      button.isActive = false
    }
    
    // Animates each card to the center of the container.
    UIViewPropertyAnimator.runningPropertyAnimator(
      withDuration: 0.2,
      delay: 0.2,
      options: .curveEaseInOut,
      animations: {
        
        buttonsCopies.forEach {
          $0.center = self.center
        }
        
    }, completion: { position in
      
      // Starts animating by scaling each button.
      UIViewPropertyAnimator.runningPropertyAnimator(
        withDuration: 0.3,
        delay: 0,
        options: .curveEaseInOut,
        animations: {
          
          buttonsCopies.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
          }
          
      }, completion: { position in
        
        // Animates each card to the matched deck.
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
          buttonsCopies.forEach { button in
            let snapOutBehavior = UISnapBehavior(item: button, snapTo: self.discardToFrame.center)
            snapOutBehavior.damping = 1
            self.animator.addBehavior(snapOutBehavior)
          }
          
          // Removes the button copies.
          Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
            buttonsCopies.forEach { $0.isActive = false }
            buttonsCopies.forEach { $0.removeFromSuperview() }
            
            self.delegate?.cardsRemovalDidFinish()
          }
        }
      })
    })
  }
  
  override func removeInactiveCardButtons(withCompletion completion: Optional<() -> ()>) {
    let inactiveButtons = buttons.filter { !$0.isActive }
    guard inactiveButtons.count > 0 else { return }
    
    grid.cellCount = buttons.filter({ $0.isActive }).count
    updateViewsFrames(withAnimation: true, andCompletion: completion)
  }
  
  // MARK: UIDynamicAnimator Delegate methods
  
  func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
    animator.removeAllBehaviors()
//    isPerformingDealAnimation = false
  }
  
}
