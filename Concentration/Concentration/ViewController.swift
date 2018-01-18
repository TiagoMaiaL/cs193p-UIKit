//
//  ViewController.swift
//  Concentration
//
//  Created by Tiago Maia Lopes on 1/16/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  // MARK: Properties
  
  @IBOutlet var cardButtons: [UIButton]!
  
  @IBOutlet weak var flipsLabel: UILabel!
  
  @IBOutlet weak var scoreLabel: UILabel!
  
  lazy var concentration = Concentration(numberOfPairs: (cardButtons.count / 2))
  
  var emojis = ["🇧🇷", "🇧🇪", "🇯🇵", "🇨🇦", "🇺🇸", "🇵🇪", "🇮🇪", "🇦🇷"]
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: Actions
  
  var cardsEmojisMap = [Int : String]()
  
  @IBAction func didTapCard(_ sender: UIButton) {
    guard let index = cardButtons.index(of: sender) else { return }
    guard concentration.cards.indices.contains(index) else { return }
    
    let card = concentration.cards[index]
    
    guard emojis.indices.contains(card.identifier) else { return }
    
    if cardsEmojisMap[card.identifier] == nil {
      cardsEmojisMap[card.identifier] = emojis[card.identifier]
    }
    
    concentration.flipCard(with: index)
    flipsLabel.text = "Flips: \(concentration.flipsCount)"
    displayCards()
  }
  
  @IBAction func didTapNewGame(_ sender: UIButton) {
    concentration.resetGame()
    displayCards()
    flipsLabel.text = "Flips: 0"
    scoreLabel.text = "Score: 0"
    cardsEmojisMap = [:]
  }
  
  // MARK: Imperatives
  
  func displayCards() {
    for (index, cardButton) in cardButtons.enumerated() {
      guard concentration.cards.indices.contains(index) else { continue }
      
      let card = concentration.cards[index]
      
      if card.isFaceUp {
        cardButton.setTitle(cardsEmojisMap[card.identifier], for: .normal)
        cardButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      } else {
        cardButton.setTitle("", for: .normal)
        cardButton.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
      }
    }
  }
  
}

