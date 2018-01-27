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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    displayCards()
  }
  
  // MARK: Imperatives
  
  /// Displays each card dealt by the setGame.
  /// Method in chard of keeping the UI in sync with the model.
  private func displayCards() {
    for (index, card) in setGame.tableCards.enumerated() {
      let cardButton = cardButtons[index]
      
      if let card = card {
        cardButton.setAttributedTitle(getAttributedText(forCard: card)!, for: .normal)
        
        // If the card is selected, display borders to indicate the state.
        if card.isSelected {
          cardButton.layer.borderWidth = 3
          cardButton.layer.borderColor = UIColor.blue.cgColor
          cardButton.layer.cornerRadius = 8
        } else {
          cardButton.layer.borderWidth = 0
          cardButton.layer.cornerRadius = 0
        }
        
      } else {
        // Card was matched, hide the associated button for now.
        cardButton.isHidden = true
      }
    }
  }
  
  /// Returns the configured attributed text for the given card,
  /// configured based on the card features.
  private func getAttributedText(forCard card: SetCard) -> NSAttributedString? {
    guard let number = card.combination.number else { return nil }
    guard let symbol = card.combination.symbol else { return nil }
    guard let color = card.combination.color else { return nil }
    guard let shading = card.combination.shading else { return nil }
    
    if let symbolChar = symbolToText[symbol] {
      let cardText = String(repeating: symbolChar, count: number.rawValue + 1)
      var attributes = [NSAttributedStringKey : Any]()
      let cardColor = colorFeatureToColor[color]!
      
      switch shading {
      case .outlined:
        attributes[NSAttributedStringKey.strokeWidth] = 10
        fallthrough
      case .solid:
        attributes[NSAttributedStringKey.foregroundColor] = cardColor
      case .striped:
        attributes[NSAttributedStringKey.foregroundColor] = cardColor.withAlphaComponent(0.3)
      }
      
      let attributedText = NSAttributedString(string: cardText,
                                              attributes: attributes)
      return attributedText
    } else {
      return nil
    }
  }

  // MARK: Actions
  
  @IBAction func didTapCard(_ sender: UIButton) {
    guard let index = cardButtons.index(of: sender) else { return }
    guard let _ = setGame.tableCards[index] else { return }
    
    setGame.selectCard(at: index)
    
    displayCards()
  }
  
  @IBAction func didTapDealMore(_ sender: UIButton) {
    
  }
  
  @IBAction func didTapNewGame(_ sender: UIButton) {
    
  }
}

