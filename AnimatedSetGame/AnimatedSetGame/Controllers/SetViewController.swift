//
//  ViewController.swift
//  SetGame
//
//  Created by Tiago Maia Lopes on 1/23/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class SetViewController: UIViewController, CardsContainerViewDelegate, SetGameDelegate {
  
  // MARK: Properties
  
  /// The main set game.
  private var setGame = SetGame()
  
  /// The deck button used both as a deck placeholder and
  /// as the button with the deal more action.
  @IBOutlet weak var deckPlaceholderCard: SetCardButton!
  
  /// The matched deck button used as a the deck placeholder.
  @IBOutlet weak var matchedDeckPlaceholderCard: SetCardButton!
  
  /// The label indicating the number of matches performed.
  @IBOutlet weak var matchesLabel: UILabel!
  
  /// The view containing all cards.
  @IBOutlet weak var containerView: SetCardsContainerView! {
    didSet {
      containerView.delegate = self
    }
  }
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setGame.delegate = self
    setGame.dealCards(forAmount: 12)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if !setGame.tableCards.isEmpty, containerView.buttons.isEmpty {
      containerView.addButtons(byAmount: 12, animated: true)
      assignTargetAction()
    }
    
    displayCards()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let translatedDealOrigin = view.convert(deckPlaceholderCard.frame.origin,
                                            to: containerView)
    let translatedDealFrame = CGRect(origin: translatedDealOrigin,
                                     size: deckPlaceholderCard.frame.size)
    containerView.dealingFromFrame = translatedDealFrame
    
    let translatedDiscardOrigin = view.convert(matchedDeckPlaceholderCard.frame.origin,
                                                   to: containerView)
    let translatedDiscardFrame = CGRect(origin: translatedDiscardOrigin,
                                            size: matchedDeckPlaceholderCard.frame.size)
    containerView.discardToFrame = translatedDiscardFrame
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    coordinator.animate(alongsideTransition: { _ in
      self.containerView.prepareForRotation()
    }) { _ in
      self.containerView.updateViewsFrames(withAnimation: true) {
        for button in self.containerView.buttons {
          if !button.isFaceUp {
            button.turnFaceUp(animated: true)
          }
        }
      }
    }
  }
  
  // MARK: Imperatives
  
  private func assignTargetAction() {
    for button in containerView.buttons {
      button.addTarget(self, action: #selector(didTapCard(_:)), for: .touchUpInside)
    }
  }
  
  /// Displays each card dealt by the setGame.
  /// Method in chard of keeping the UI in sync with the model.
  private func displayCards() {
    
    // The buttons to be displayed
    var buttons: [SetCardButton]!
    
    // If there's no more cards on the deck, we should disconsider the hidden
    // card buttons, they are going to be removed from the container so only
    // the visible cards should be updated for display.
    if containerView.buttons.count > setGame.tableCards.count,
       setGame.deck.isEmpty {
      buttons = containerView.buttons.filter { $0.alpha == 1 } as! [SetCardButton]
    } else {
      // Otherwise, all cardButtons should be updated for display.
      buttons = containerView.buttons as! [SetCardButton]
    }
    
    for (index, cardButton) in buttons.enumerated() {
      guard setGame.tableCards.indices.contains(index) else { continue }
      
      let currentCard = setGame.tableCards[index]
      
      // Color feature:
      switch currentCard.combination.color {
      case .green:
        cardButton.color = .green
      case .purple:
        cardButton.color = .purple
      case .red:
        cardButton.color = .red
      default:
        break
      }
      
      // Number feature:
      switch currentCard.combination.number {
      case .one:
        cardButton.numberOfSymbols = 1
      case .two:
        cardButton.numberOfSymbols = 2
      case .three:
        cardButton.numberOfSymbols = 3
      default:
        break
      }
      
      // Symbol feature:
      switch currentCard.combination.symbol {
      case .diamond:
        cardButton.symbolShape = .diamond
      case .squiggle:
        cardButton.symbolShape = .squiggle
      case .oval:
        cardButton.symbolShape = .oval
      default:
        break
      }
      
      // Shading feature:
      switch currentCard.combination.shading {
      case .outlined:
        cardButton.symbolShading = .outlined
      case .solid:
        cardButton.symbolShading = .solid
      case .striped:
        cardButton.symbolShading = .striped
      default:
        break
      }
      
      // Selection:
      if setGame.selectedCards.contains(currentCard) ||
         setGame.matchedCards.contains(currentCard) {
        cardButton.isSelected = true
      } else {
        cardButton.isSelected = false
      }
    }
  }
  
  /// Hides or shows the deck placeholder card, according to the game's deck.
  private func updateDeckAppearance() {
    UIViewPropertyAnimator.runningPropertyAnimator(
      withDuration: 0.1,
      delay: 0.3,
      options: .curveEaseIn,
      animations: {
        self.matchedDeckPlaceholderCard.alpha = self.setGame.matchedDeck.isEmpty ? 0 : 1
        self.deckPlaceholderCard.alpha = self.setGame.deck.isEmpty ? 0 : 1
      }
    )
  }
  
  // MARK: Actions
  
  /// Selects the chosen card.
  @objc func didTapCard(_ sender: UIButton) {
    guard let cardButton = sender as? SetCardButton else {
      return
    }
    
    let index = containerView.buttons.index(of: cardButton)!
    setGame.selectCard(at: index)
    displayCards()
  }
  
  // Adds more cards to the UI.
  @IBAction func didTapDealMore(_ sender: UIButton) {
    guard !setGame.deck.isEmpty else { return }
    guard !containerView.isPerformingDealAnimation else { return }
    
    if setGame.matchedCards.count > 0 {
      setGame.replaceMatchedCards()
    }
    
    setGame.dealCards()
    containerView.addButtons(animated: true)
    assignTargetAction()
    
    displayCards()
    updateDeckAppearance()
  }
  
  /// Restarts the current game.
  @IBAction func didTapNewGame(_ sender: UIBarButtonItem) {
    guard !containerView.isPerformingDealAnimation else { return }
    
    setGame.reset()
    setGame.dealCards(forAmount: 12)
    containerView.clearCardContainer(withAnimation: true)
  }
  
  /// Deals more cards.
  @IBAction func didSwipeDown(_ sender: UISwipeGestureRecognizer) {
    if !setGame.deck.isEmpty {
      didTapDealMore(deckPlaceholderCard)
    }
  }
  
  /// Reorder the table
  @IBAction func didRotate(_ sender: UIRotationGestureRecognizer) {
    if sender.state == .began {
      setGame.shuffleTableCards()
      displayCards()
    }
  }
  
  // MARK: Cards container delegate implementation
  
  /// Method called after the removal becomes animation.
  func cardsRemovalDidFinish() {
    updateDeckAppearance()
    
    guard !containerView.buttons.isEmpty else {
      containerView.addButtons(byAmount: 12, animated: true)
      assignTargetAction()
      displayCards()
      matchesLabel.text = "Matches: 0"
      return
    }
    
    guard containerView.buttons.count == setGame.tableCards.count, !setGame.deck.isEmpty else {
      containerView.removeInactiveCardButtons() {
        self.containerView.isUserInteractionEnabled = true
      }
      return
    }
    
    containerView.dealCardsWithAnimation()
  }
  
  // MARK: SetGame delegate implementation
  
  func selectedCardsDidMatch(_ cards: [SetCard]) {
    matchesLabel.text = "Matches: \(setGame.matchedDeck.count)"
    
    let matchedCardButtons = cards.map({ card -> SetCardButton in
      let cardIndex = self.setGame.tableCards.index(of: card)!
      return self.containerView.buttons[cardIndex] as! SetCardButton
    })
    
    // The replace will happen, if the deck is empty, cards will be
    // removed and the buttons will be out of sync.
    if setGame.deck.isEmpty {
      self.containerView.isUserInteractionEnabled = false
    }
    
    containerView.animateCardsOut(matchedCardButtons)
  }
  
  func cardsDealDidFinish() {}
  
  func didFinishDealingCard(_ button: CardButton) {
    button.turnFaceUp(animated: true)
  }

}
