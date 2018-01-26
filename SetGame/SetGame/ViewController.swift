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
  
  /// The card buttons being displayed in the UI.
  @IBOutlet var cardButtons: [UIButton]! {
    didSet {
      _ = setGame.dealCards(forAmount: cardButtons.count)
    }
  }
  
  /// The mapping between a symbol card feature and it's
  /// corresponding displayable char.
  private let symbolToText: [Symbol : String] = [
    .squiggle : "■",
    .diamond : "▲",
    .oval : "●"
  ]
  
  /// The mapping between a color card feature and it's
  /// corresponding literal displayable UIColor.
  private let colorFeatureToColor: [Color : UIColor] = [
    .red : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
    .green : #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),
    .purple : #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
  ]
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: Imperatives
  
  /// Displays each card dealt by the setGame.
  /// Method in chard of keeping the UI in sync with the model.
  private func displayCards() {
    for (index, card) in setGame.tableCards.enumerated() {
      let cardButton = cardButtons[index]
      
      if let card = card {
        cardButton.titleLabel?.text = getText(forCard: card)
        // TODO: Get each feature: color, shape, shading and number
        // TODO: Display each featere,
        // TODO: Determine color mapping
        // TODO: Determine shape mapping
        // TODO: Determine shading routines.
      } else {
        // Card was matched, hide the associated button for now.
        cardButton.isHidden = true
      }
    }
  }
  
  // TODO: This should be an optional.
  // TODO: Figure out how this is going to work with the rest of the code.
  private func getText(forCard card: SetCard) -> String {
    var cardText = ""
    
    guard let number = card.combination.number else { return "" }
    guard let symbol = card.combination.symbol else { return "" }
    guard let color = card.combination.color else { return "" }
    guard let shading = card.combination.shading else { return "" }
    
    return cardText
  }

  // MARK: Actions
  
  @IBAction func didTapCard(_ sender: UIButton) {
    
  }
  
  @IBAction func didTapDealMore(_ sender: UIButton) {
    
  }
  
  @IBAction func didTapNewGame(_ sender: UIButton) {
    
  }
}

