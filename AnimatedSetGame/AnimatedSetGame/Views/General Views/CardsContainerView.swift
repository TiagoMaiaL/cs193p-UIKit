//
//  CardsContainerView.swift
//  AnimatedSetGamee
//
//  Created by Tiago Maia Lopes on 07/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

/// Protocol used to give the superview or controller a
/// chance to act after some card container events.
protocol CardsContainerViewDelegate {
  
  /// Method called when the removal animation ends.
  func cardsRemovalDidFinish()
  
  /// Method called when the deal animation ends.
  func cardsDealDidFinish()
  
  /// Method called when the deal animation ends for a given card.
  func didFinishDealingCard(_ button: CardButton)
}

/// A view holding card buttons.
@IBDesignable
class CardsContainerView: UIView, UIDynamicAnimatorDelegate {

  // MARK: Properties
  
  /// The number of buttons to be displayed on a storyboard file with this view in it.
  @IBInspectable var numberOfButtonsForDisplay: Int = 0
  
  /// The container's delegate
  var delegate: CardsContainerViewDelegate?
  
  /// The contained card buttons.
  var buttons = [CardButton]()
  
  /// The grid in charge of generating the calculated
  /// frame of each contained button.
  var grid = Grid(layout: Grid.Layout.aspectRatio(3/2))
  
  /// The animator object responsible for each button's animations.
  lazy var animator = UIDynamicAnimator(referenceView: self)
  
  /// The animator in charge of positioning each contained button.
  var positioningAnimator: UIViewPropertyAnimator?
  
  /// The translated frame used by the dealing animation.
  /// - Note: This frame is the origin and size for all added buttons.
  ///         When the deal animation takes place, all cards will fly from
  ///         this frame to each destination.
  var discardToFrame: CGRect!
  
  /// The translated deck frame used by the removal animation.
  /// - Note: When the removal animation takes place, all cards will fly from
  ///         their current positions to this frame.
  var dealingFromFrame: CGRect!
  
  /// The rect in which the buttons are going to be positioned,
  /// according to the grid.
  var gridRect: CGRect {
    get {
      return CGRect(x: bounds.size.width * 0.025,
                    y: bounds.size.height * 0.025,
                    width: bounds.size.width * 0.95,
                    height: bounds.size.height * 0.95)
    }
  }
  
  /// The scheduled deal animations of each card button.
  /// - Note: This array can be used to cancel any scheduled animations
  var scheduledDealAnimations: [Timer]?
  
  /// Tells if the dealing animation is running.
  /// If it's running, we shouldn't overlap the current dealing one.
  /// Only one deal animation must be performed at a time.
  var isPerformingDealAnimation = false
  
  /// The buttons that are going to be positioned in the grid.
  var buttonsToPosition: [CardButton] {
    return buttons
  }
  
  // MARK: Initializer
  
  override func awakeFromNib() {
    animator.delegate = self
  }
  
  // MARK: Life cycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // Only updates the buttons frames if the centered rect has changed,
    // This will occur when orientation changes.
    // This check will prevent frame changes while
    // the dynamic animator is doing it's job.
    if grid.frame != gridRect {
      updateViewsFrames()
    }
  }
  
  // MARK: Imperatives
  
  /// Prepares the container for the device's rotation event.
  /// Stops any running deal animations and respositions all the views.
  func prepareForRotation() {
    animator.removeAllBehaviors()
    
    // Invalidates all scheduled deal animations.
    scheduledDealAnimations?.forEach { timer in
      if timer.isValid {
        timer.invalidate()
      }
    }
    
    positioningAnimator?.stopAnimation(true)
    
    for button in buttons {
      button.transform = .identity
      button.setNeedsDisplay()
    }
    
    isPerformingDealAnimation = false
  }
  
  /// Instantiates a new array of buttons with the specified count of elements.
  func makeButtons(byAmount numberOfButtons: Int) -> [CardButton] { return [] }
  
  /// Adds new buttons to the UI.
  /// - Parameter byAmount: The number of buttons to be added.
  /// - Parameter animated: Bool indicating if the addition should be animated.
  func addButtons(byAmount numberOfButtons: Int = 3, animated: Bool = false) {
    guard isPerformingDealAnimation == false else { return }
    
    let cardButtons = makeButtons(byAmount: numberOfButtons)
    
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
  
  /// Animates all empty cards to their original positions.
  /// - Note: The animation is performed by taking a copy of
  ///         each inactive button and animating them from the deck
  ///         to their current position.
  func dealCardsWithAnimation() {
    // The animation is only performed if a previous one isn't happening.
    // If two animations run at the same time, the frames are changed and the
    // animator doesn't handle this well.
    guard isPerformingDealAnimation == false else { return }
    
    // The animation is only applied to the inactive cards.
    guard !buttons.filter({ !$0.isActive }).isEmpty else { return }
    
    // The animation now has taken place.
    isPerformingDealAnimation = true
    
    updateViewsFrames(withAnimation: true) {
      var dealAnimationDelay = 0.0
      
      for (i, button) in self.buttons.enumerated() {
        // The deal animation is applied only to the inactive buttons.
        if button.isActive { continue }
        
        guard let currentFrame = self.grid[i] else { continue }
        
        button.isFaceUp = false
        
        // Changes the position and size to match the provided deck's frame.
        button.frame = self.dealingFromFrame
        self.bringSubview(toFront: button)
        
        // The card will appear on top of the deck.
        button.isActive = true
        
        let snapBehavior = UISnapBehavior(item: button,
                                          snapTo: currentFrame.center)
        snapBehavior.damping = 0.8
        
        if self.scheduledDealAnimations == nil {
          self.scheduledDealAnimations = []
        }
        
        let animationTimer = Timer.scheduledTimer(withTimeInterval: dealAnimationDelay, repeats: false) { _ in
          // Apply the snap behavior.
          self.animator.addBehavior(snapBehavior)
          
          // Animates the button's size.
          UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: {
              button.bounds.size = currentFrame.size
            }
          )
          
          Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
            self.delegate?.didFinishDealingCard(button)
          }
        }
        
        self.scheduledDealAnimations!.append(animationTimer)
        
        dealAnimationDelay += 0.2
      }
    }
  }
  
  /// Applies the grid frames to all subviews.
  func updateViewsFrames(withAnimation animated: Bool = false,
                                 andCompletion completion: Optional<() -> ()> = nil) {
    grid.frame = gridRect
    
    if animated {
      if let propertyAnimator = positioningAnimator {
        propertyAnimator.stopAnimation(true)
        positioningAnimator = nil
      }
      
      positioningAnimator = UIViewPropertyAnimator.runningPropertyAnimator(
        withDuration: 0.2,
        delay: 0,
        options: .curveEaseInOut,
        animations: {
          self.respositionViews()
        }
      ) { _ in
        if let completion = completion {
          completion()
        }
      }
      
      print("Positioning animator: \(positioningAnimator!)")
    } else {
      respositionViews()
    }
  }
  
  /// Assigns each button's to the corresponding grid's frame.
  func respositionViews() {
    grid.frame = gridRect
    
    for (i, button) in buttonsToPosition.enumerated() {
      if let frame = grid[i] {
        button.frame = frame
      }
    }
    
    setNeedsLayout()
  }
  
  /// Removes the inactive card buttons from the container.
  func removeInactiveCardButtons(withCompletion completion: Optional<() -> ()> = nil) {
    let inactiveButtons = buttons.filter { !$0.isActive }
    
    guard inactiveButtons.count > 0 else { return }
    
    for button in inactiveButtons {
      buttons.remove(at: buttons.index(of: button)!)
      button.removeFromSuperview()
    }
    
    grid.cellCount = buttons.count
    updateViewsFrames(withAnimation: true, andCompletion: completion)
  }
  
  /// Removes all buttons from the container.
  func clearCardContainer(withAnimation animated: Bool = false, completion: Optional<() -> ()> = nil) {
    if animated {
      animateCardsOut(buttons)
    }
    
    buttons.forEach {
      $0.removeFromSuperview()
    }
    buttons = []
    grid.cellCount = 0
    
    setNeedsLayout()
  }
  
  /// Animates the passed buttons out of the container.
  func animateCardsOut(_ buttons: [CardButton]) {}

  // MARK: UIDynamicAnimator Delegate methods
  
  func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
    animator.removeAllBehaviors()
    isPerformingDealAnimation = false
    scheduledDealAnimations = nil
  }
  
}

extension UIView {
  
  /// Removes all subviews.
  func removeAllSubviews() {
    for subview in subviews {
      subview.removeFromSuperview()
    }
  }
  
}

extension CGRect {
  
  /// Returns the center of this rect.
  var center: CGPoint {
    return CGPoint(
      x: midX,
      y: midY
    )
  }
  
}
