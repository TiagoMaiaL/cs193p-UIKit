//
//  ViewController.swift
//  SetGame
//
//  Created by Tiago Maia Lopes on 1/23/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class SetViewController: UIViewController, CardContainerViewDelegate, SetGameDelegate {
  
  // MARK: Properties
  
  /// The main set game.
  private var setGame = SetGame()
  
  /// The deck button used both as a deck placeholder and
  /// as the button with the deal more action.
  @IBOutlet weak var deckPlaceholderCard: SetCardButton!
  
  /// The matched deck button used as a the deck placeholder.
  @IBOutlet weak var matchedDeckPlaceholderCard: SetCardButton!
  
  /// The view containing all cards.
  @IBOutlet weak var cardsContainerView: CardContainerView! {
    didSet {
      cardsContainerView.delegate = self
    }
  }
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setGame.delegate = self
    setGame.dealCards(forAmount: 12)
    
    let translatedDeckOrigin = view.convert(deckPlaceholderCard.frame.origin,
                                            to: cardsContainerView)
    let translatedDeckFrame = CGRect(origin: translatedDeckOrigin,
                                     size: deckPlaceholderCard.frame.size)
    cardsContainerView.deckFrame = translatedDeckFrame
    
    let translatedMatchedDeckOrigin = view.convert(matchedDeckPlaceholderCard.frame.origin,
                                                   to: cardsContainerView)
    let translatedMatchedDeckFrame = CGRect(origin: translatedMatchedDeckOrigin,
                                            size: matchedDeckPlaceholderCard.frame.size)
    cardsContainerView.matchedDeckFrame = translatedMatchedDeckFrame
    
    cardsContainerView.addCardButtons(byAmount: 12)
    assignTargetAction()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    displayCards()
  }
  
  // MARK: Imperatives
  
  private func assignTargetAction() {
    for button in cardsContainerView.buttons {
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
    if cardsContainerView.buttons.count > setGame.tableCards.count,
       setGame.deck.isEmpty {
      buttons = cardsContainerView.buttons.filter { $0.alpha == 1 }
    } else {
      // Otherwise, all cardButtons should be updated for display.
      buttons = cardsContainerView.buttons
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
//        cardButton.layer.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        cardButton.isSelected = true
      } else {
//        cardButton.layer.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.849352542)
        cardButton.isSelected = false
      }
    }
  }
  
  /// Hides or shows the deck placeholder card, according to the game's deck.
  private func updateDeckAppearance() {
    matchedDeckPlaceholderCard.isHidden = setGame.matchedDeck.isEmpty
    
    // Delays the update so it always happens while the
    // deal animation is happening.
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
      self.deckPlaceholderCard.isHidden = self.setGame.deck.isEmpty
    }
  }
  
  // MARK: Actions
  
  /// Selects the chosen card.
  @objc func didTapCard(_ sender: UIButton) {
    guard let cardButton = sender as? SetCardButton else {
      return
    }
    
    let index = cardsContainerView.buttons.index(of: cardButton)!
    setGame.selectCard(at: index)
    displayCards()
  }
  
  // Adds more cards to the UI.
  @IBAction func didTapDealMore(_ sender: UIButton) {
    guard !setGame.deck.isEmpty else { return }
    guard cardsContainerView.isPerformingDealAnimation == false else { return }
    
    if setGame.matchedCards.count > 0 {
      setGame.replaceMatchedCards()
    }
    
    setGame.dealCards()
    cardsContainerView.addCardButtons()
    assignTargetAction()
    
    displayCards()
    updateDeckAppearance()
  }
  
  /// Restarts the current game.
  @IBAction func didTapNewGame(_ sender: UIButton) {
    setGame.reset()
    
    setGame.dealCards(forAmount: 12)
    cardsContainerView.clearCardContainer()
    cardsContainerView.addCardButtons(byAmount: 12)
    assignTargetAction()
    
    displayCards()
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
    
    if cardsContainerView.buttons.count > setGame.tableCards.count,
       setGame.deck.isEmpty {

      cardsContainerView.removeEmptyCardButtons() {
        self.cardsContainerView.isUserInteractionEnabled = true
      }
      
      return
    }
    
    cardsContainerView.animateCardButtonsDeal()
  }
  
  // MARK: SetGame delegate implementation
  
  func selectedCardsDidMatch(_ cards: [SetCard]) {
    let matchedCardButtons = cards.map({ card -> SetCardButton in
      let cardIndex = self.setGame.tableCards.index(of: card)!
      return self.cardsContainerView.buttons[cardIndex]
    })
    
    // The replace will happen, if the deck is empty, cards will be
    // removed and the buttons will be out of sync.
    if setGame.deck.isEmpty {
      self.cardsContainerView.isUserInteractionEnabled = false
    }
    
    cardsContainerView.animateMatchedCardButtonsOut(matchedCardButtons)
  }

}
