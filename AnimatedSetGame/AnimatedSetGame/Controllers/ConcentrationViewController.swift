//
//  ViewController.swift
//  Concentration
//
//  Created by Tiago Maia Lopes on 1/16/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

// The following Theme code is part of one of the extra credit tasks.
// MARK: Extra credit 1
// -------------------------

typealias Emojis = [String]

/// Enum representing all the possible card themes.
enum Theme: Int {
  
  case Flags, Faces, Sports, Animals, Fruits, Appliances
  
  /// The color of the back of the card
  var cardColor: UIColor {
    switch self {
    case .Flags:
      return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      
    case .Faces:
      return #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
      
    case .Sports:
      return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
      
    case .Animals:
      return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
      
    case .Fruits:
      return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
      
    case .Appliances:
      return #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    }
  }
  
  /// The color of the background view
  var backgroundColor: UIColor {
    switch self {
    case .Flags:
      return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
      
    case .Faces:
      return #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
      
    case .Sports:
      return #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
      
    case .Animals:
      return #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
      
    case .Fruits:
      return #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
      
    case .Appliances:
      return #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
    }
  }
  
  /// The emojis used by this theme
  var emojis: Emojis {
    switch self {
    case .Flags:
      return ["🇧🇷", "🇧🇪", "🇯🇵", "🇨🇦", "🇺🇸", "🇵🇪", "🇮🇪", "🇦🇷"]
      
    case .Faces:
      return ["😀", "🙄", "😡", "🤢", "🤡", "😱", "😍", "🤠"]
      
    case .Sports:
      return ["🏌️", "🤼‍♂️", "🥋", "🏹", "🥊", "🏊", "🤾🏿‍♂️", "🏇🏿"]
      
    case .Animals:
      return ["🦊", "🐼", "🦁", "🐘", "🐓", "🦀", "🐷", "🦉"]
      
    case .Fruits:
      return ["🥑", "🍍", "🍆", "🍠", "🍉", "🍇", "🥝", "🍒"]
      
    case .Appliances:
      return ["💻", "🖥", "⌚️", "☎️", "🖨", "🖱", "📱", "⌨️"]
    }
  }
  
  /// The count of possible themes.
  static var count: Int {
    return Theme.Appliances.rawValue + 1
  }
  
  static func getRandom() -> Theme {
    return Theme(rawValue: Theme.count.arc4random)!
  }
  
}

// -------------------------
// -------------------------

class ConcentrationViewController: UIViewController {

  // MARK: Properties
  
  /// The cards presented in the UI.
  @IBOutlet var cardButtons: [UIButton]!
  
  /// The UI label indicating the amount of flips.
  @IBOutlet weak var flipsLabel: UILabel!
  
  /// The UI label indicating the player's score.
  @IBOutlet weak var scoreLabel: UILabel!
  
  /// The model encapsulating the concentration game's logic.
  private lazy var concentration = Concentration(numberOfPairs: (cardButtons.count / 2))
  
  /// The randomly picked theme.
  /// The theme is chosen every time a new game starts.
  private var pickedTheme: Theme!
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    chooseRandomTheme()
  }

  // MARK: Actions
  
  /// Action fired when a card button is tapped.
  /// It flips a card checks if there's a match or not.
  @IBAction func didTapCard(_ sender: UIButton) {
    guard let index = cardButtons.index(of: sender) else { return }
    
    concentration.flipCard(at: index)
    
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
  }
  
  // MARK: Imperatives
  
  /// The map between a card and the emoji used with it.
  /// This is the dictionary responsible for mapping
  /// which emoji is going to be displayed by which card.
  private var cardsAndEmojisMap = [Card : String]()
  
  /// Method used to randomly choose the game's theme.
  private func chooseRandomTheme() {
    pickedTheme = Theme.getRandom()
    view.backgroundColor = pickedTheme.backgroundColor
    
    cardsAndEmojisMap = [:]
    var emojis = pickedTheme.emojis
    
    for card in concentration.cards {
      if cardsAndEmojisMap[card] == nil {
        cardsAndEmojisMap[card] = emojis.remove(at: emojis.count.arc4random)
      }
    }
    
    displayCards()
  }
  
  /// Method used to refresh the scores and flips UI labels.
  private func displayLabels() {
    flipsLabel.text = "Flips: \(concentration.flipsCount)"
    scoreLabel.text = "Score: \(concentration.score)"
  }
  
  /// Method in charge of displaying each card's state
  /// with the assciated card button.
  private func displayCards() {
    for (index, cardButton) in cardButtons.enumerated() {
      guard concentration.cards.indices.contains(index) else { continue }
      
      let card = concentration.cards[index]
      
      if card.isFaceUp {
        cardButton.setTitle(cardsAndEmojisMap[card], for: .normal)
        cardButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      } else {
        cardButton.setTitle("", for: .normal)
        cardButton.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : pickedTheme.cardColor
      }
    }
  }
  
}

