//
//  ConcentrationCardsContainerView.swift
//  AnimatedSetGamee
//
//  Created by Tiago Maia Lopes on 08/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class ConcentrationCardsContainerView: CardsContainerView {

  // TODO: Prepare for IB.
  
  // MARK: Properties
  
  // MARK: Initializer
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
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
  
  override func makeButtons(byAmount numberOfButtons: Int) -> [CardButton] {
    return (0..<numberOfButtons).map { _ in ConcentrationCardButton() }
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
  
}
