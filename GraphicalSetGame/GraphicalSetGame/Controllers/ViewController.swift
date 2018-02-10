//
//  ViewController.swift
//  SetGame
//
//  Created by Tiago Maia Lopes on 1/23/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  // MARK: Properties
  
  /// The main set game.
  private var setGame = SetGame()
  
  /// The UI score label.
  @IBOutlet weak var scoreLabel: UILabel!
  
  /// The label containing the number of metched trios.
  @IBOutlet weak var matchedTriosLabel: UILabel!
  
  /// The deal more button in the UI.
  @IBOutlet weak var dealMoreButton: UIButton!
  
  /// The view containing all cards.
  @IBOutlet weak var cardsContainerView: CardContainerView!
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setGame.dealCards(forAmount: 12)
    cardsContainerView.addCardButtons(byAmount: 12)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    displayCards()
  }
  
  // MARK: Imperatives
  
  /// Displays each card dealt by the setGame.
  /// Method in chard of keeping the UI in sync with the model.
  private func displayCards() {
    // TODO:
  }
  
  /// Checks if it's possible to deal more cards and
  /// enables or disables the deal more button accordingly.
  private func handleDealMoreButton() {
    dealMoreButton.isEnabled = setGame.deck.count > 3
  }

  // MARK: Actions
  
  /// Selects the chosen card.
  func didTapCard(_ sender: UIButton) {
    // TODO:
  }
  
  // Adds more cards to the UI.
  @IBAction func didTapDealMore(_ sender: UIButton) {
    if setGame.matchedCards.count > 0 {
      setGame.removeMatchedCardsFromTable()
    }
    
    setGame.dealCards()
    cardsContainerView.addCardButtons()
    
    displayCards()
  }
  
  /// Restarts the current game.
  @IBAction func didTapNewGame(_ sender: UIButton) {
    setGame.reset()
    
    setGame.dealCards(forAmount: 12)
    cardsContainerView.clearCardContainer()
    cardsContainerView.addCardButtons(byAmount: 12)
    
    displayCards()
  }
}

