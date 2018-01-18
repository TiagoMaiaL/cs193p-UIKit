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
  
  var themes = [
    ["🇧🇷", "🇧🇪", "🇯🇵", "🇨🇦", "🇺🇸", "🇵🇪", "🇮🇪", "🇦🇷"],
    ["😀", "🙄", "😡", "🤢", "🤡", "😱", "😍", "🤠"],
    ["🏌️", "🤼‍♂️", "🥋", "🏹", "🥊", "🏊", "🤾🏿‍♂️", "🏇🏿"],
    ["🦊", "🐼", "🦁", "🐘", "🐓", "🦀", "🐷", "🦉"],
    ["🥑", "🍍", "🍆", "🍠", "🍉", "🍇", "🥝", "🍒"],
    ["💻", "🖥", "⌚️", "☎️", "🖨", "🖱", "📱", "⌨️"]
  ]
  
  var pickedThemeEmojis = ["🇧🇷", "🇧🇪", "🇯🇵", "🇨🇦", "🇺🇸", "🇵🇪", "🇮🇪", "🇦🇷"]
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setRandomTheme()
  }

  // MARK: Actions
  
  var cardsEmojisMap = [Int : String]()
  
  @IBAction func didTapCard(_ sender: UIButton) {
    guard let index = cardButtons.index(of: sender) else { return }
    guard concentration.cards.indices.contains(index) else { return }
    
    let card = concentration.cards[index]
    
    guard pickedThemeEmojis.indices.contains(card.identifier) else { return }
    
    if cardsEmojisMap[card.identifier] == nil {
      cardsEmojisMap[card.identifier] = pickedThemeEmojis[card.identifier]
    }
    
    concentration.flipCard(with: index)
    
    displayCards()
    displayLabels()
  }
  
  @IBAction func didTapNewGame(_ sender: UIButton) {
    setRandomTheme()
    concentration.resetGame()
    displayCards()
    displayLabels()
    cardsEmojisMap = [:]
  }
  
  // MARK: Imperatives
  
  func setRandomTheme() {
    let randomThemeIndex = Int(arc4random_uniform(UInt32(themes.count)))
    
    guard themes.indices.contains(randomThemeIndex) else {
      pickedThemeEmojis = themes[0]
      return
    }
    
    pickedThemeEmojis = themes[randomThemeIndex]
  }
  
  func displayLabels() {
    flipsLabel.text = "Flips: \(concentration.flipsCount)"
    scoreLabel.text = "Score: \(concentration.score)"
  }
  
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

