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
  
  /// The cards presented in the UI.
  @IBOutlet var cardButtons: [UIButton]!
  
  /// The UI label indicating the amount of flips.
  @IBOutlet weak var flipsLabel: UILabel!
  
  /// The UI label indicating the player's score.
  @IBOutlet weak var scoreLabel: UILabel!
  
  /// The model encapsulating the concentration game's logic.
  lazy var concentration = Concentration(numberOfPairs: (cardButtons.count / 2))
  
  /// A set of themes with emojis used in the cards.
  /// There are 6 themes, one of them is choosed randomly
  /// every time a new game starts.
  var themes = [
    ["🇧🇷", "🇧🇪", "🇯🇵", "🇨🇦", "🇺🇸", "🇵🇪", "🇮🇪", "🇦🇷"],
    ["😀", "🙄", "😡", "🤢", "🤡", "😱", "😍", "🤠"],
    ["🏌️", "🤼‍♂️", "🥋", "🏹", "🥊", "🏊", "🤾🏿‍♂️", "🏇🏿"],
    ["🦊", "🐼", "🦁", "🐘", "🐓", "🦀", "🐷", "🦉"],
    ["🥑", "🍍", "🍆", "🍠", "🍉", "🍇", "🥝", "🍒"],
    ["💻", "🖥", "⌚️", "☎️", "🖨", "🖱", "📱", "⌨️"]
  ]
  
  /// The randomly picked theme.
  /// Each emoji in a card is picked from these emojis.
  var pickedTheme = [String]()
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    chooseRandomTheme()
  }

  // MARK: Actions
  
  /// The map between a card identifier and the emoji used with it.
  /// This is the dictionary responsible for mapping
  /// which emoji is going to be displayed by a which card.
  var cardsAndEmojisMap = [Int : String]()
  
  /// Action fired when a card button is tapped.
  /// It flips a card checks if there's a match or not.
  @IBAction func didTapCard(_ sender: UIButton) {
    guard let index = cardButtons.index(of: sender) else { return }
    guard concentration.cards.indices.contains(index) else { return }
    
    let card = concentration.cards[index]
    
    // TODO: Put this in a specific function.
    guard pickedTheme.indices.contains(card.identifier) else { return }
    
    if cardsAndEmojisMap[card.identifier] == nil {
      cardsAndEmojisMap[card.identifier] = pickedTheme[card.identifier]
    }
    
    concentration.flipCard(with: index)
    
    displayCards()
    displayLabels()
  }
  
  /// Action fired when the new game button is tapped.
  /// It resets the current game and refreshes the UI.
  @IBAction func didTapNewGame(_ sender: UIButton) {
    chooseRandomTheme()
    concentration.resetGame()
    displayCards()
    displayLabels()
    cardsAndEmojisMap = [:]
  }
  
  // MARK: Imperatives
  
  /// Method used to randomly choose the game's theme.
  func chooseRandomTheme() {
    let randomThemeIndex = Int(arc4random_uniform(UInt32(themes.count)))
    
    guard themes.indices.contains(randomThemeIndex) else {
      pickedTheme = themes[0]
      return
    }
    
    pickedTheme = themes[randomThemeIndex]
  }
  
  /// Method used to refresh the scores and flips UI labels.
  func displayLabels() {
    flipsLabel.text = "Flips: \(concentration.flipsCount)"
    scoreLabel.text = "Score: \(concentration.score)"
  }
  
  /// Method in charge of displaying each card's state
  /// with the assciated card button.
  func displayCards() {
    for (index, cardButton) in cardButtons.enumerated() {
      guard concentration.cards.indices.contains(index) else { continue }
      
      let card = concentration.cards[index]
      
      if card.isFaceUp {
        cardButton.setTitle(cardsAndEmojisMap[card.identifier], for: .normal)
        cardButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      } else {
        cardButton.setTitle("", for: .normal)
        cardButton.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
      }
    }
  }
  
}

