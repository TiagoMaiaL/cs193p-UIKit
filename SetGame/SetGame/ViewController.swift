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
        
        // Highlights the matched cards
        if card.isMatched {
          cardButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        } else {
          cardButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
    guard card.combination.number != .none else { return nil }
    guard card.combination.symbol != .none else { return nil }
    guard card.combination.color != .none else { return nil }
    guard card.combination.shading != .none else { return nil }
    
    let number = card.combination.number
    let symbol = card.combination.symbol
    let color = card.combination.color
    let shading = card.combination.shading
    
    // Checks if a symbol has an associated char.
    if let symbolChar = symbolToText[symbol] {
      // Creates the symbol text according to the number feature.
      let cardText = String(repeating: symbolChar, count: number.rawValue + 1)
      var attributes = [NSAttributedStringKey : Any]()
      // Gets the associated color from the card color feature.
      let cardColor = colorFeatureToColor[color]!
      
      // Adds the given attribute for one of the shading values.
      switch shading {
      case .outlined:
        attributes[NSAttributedStringKey.strokeWidth] = 10
        fallthrough
      case .solid:
        attributes[NSAttributedStringKey.foregroundColor] = cardColor
      case .striped:
        attributes[NSAttributedStringKey.foregroundColor] = cardColor.withAlphaComponent(0.3)
      default:
        break
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

