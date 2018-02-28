//
//  ViewController.swift
//  SetGame
//
//  Created by Tiago Maia Lopes on 1/23/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
  
  // MARK: Properties
  
  /// The main set game.
  private var setGame = SetGame()
  
  /// The deck button used both as a deck placeholder and
  /// as the button with the deal more action.
  @IBOutlet weak var deckPlaceholderCard: SetCardButton!
  
  /// The matched deck button used as a the deck placeholder.
  @IBOutlet weak var matchedDeckPlaceholderCard: SetCardButton!
  
  /// The view containing all cards.
  @IBOutlet weak var cardsContainerView: CardContainerView!
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
//    if cardsContainerView.buttons.count > setGame.tableCards.count {
//      cardsContainerView.removeCardButtons(byAmount: cardsContainerView.buttons.count - setGame.tableCards.count)
//    }
    
    if setGame.matchedCards.count > 0 {
      let matchedCardButtons = setGame.matchedCards.map({ card -> SetCardButton in
        let cardIndex = self.setGame.tableCards.index(of: card)!
        return self.cardsContainerView.buttons[cardIndex]
      })
      
      cardsContainerView.animateMatchedCardButtonsOut(matchedCardButtons)
    }
    
    for (index, cardButton) in cardsContainerView.buttons.enumerated() {
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
        cardButton.layer.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
      } else {
        cardButton.layer.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.849352542)
      }
    }
    
//    scoreLabel.text = "Score: \(setGame.score)"
//    matchedTriosLabel.text = "Matches: \(setGame.matchedDeck.count)"
    
//    handleDealMoreButton()
  }
  
  /// Checks if it's possible to deal more cards and
  /// enables or disables the deal more button accordingly.
  private func handleDealMoreButton() {
//    dealMoreButton.isEnabled = setGame.deck.count > 3
  }

  // MARK: Actions
  
  /// Selects the chosen card.
  @objc func didTapCard(_ sender: UIButton) {
    guard let cardButton = sender as? SetCardButton else {
      return
    }
    
    let index = cardsContainerView.buttons.index(of: cardButton)!
    setGame.selectCard(at: index)
    
    // Flip the tapped card.
    // -------------------------------
    // -------------------------------
//    UIView.transition(with: cardButton,
//                      duration: 0.2,
//                      options: .transitionFlipFromLeft,
//                      animations: {
//                        cardButton.isFaceUp = !cardButton.isFaceUp
//    }) { completed in
//      // Nothing for now.
//    }
    // -------------------------------
    // -------------------------------
    
    displayCards()
  }
  
  // Adds more cards to the UI.
  @IBAction func didTapDealMore(_ sender: UIButton) {
    if setGame.matchedCards.count > 0 {
      setGame.replaceMatchedCards()
    }
    
    setGame.dealCards()
    cardsContainerView.addCardButtons()
    assignTargetAction()
    
    displayCards()
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
//    didTapDealMore(dealMoreButton)
  }
  
  /// Reorder the table
  @IBAction func didRotate(_ sender: UIRotationGestureRecognizer) {
    if sender.state == .began {
      setGame.shuffleTableCards()
      displayCards()
    }
  }
}

