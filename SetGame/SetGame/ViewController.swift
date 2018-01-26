//
//  ViewController.swift
//  SetGame
//
//  Created by Tiago Maia Lopes on 1/23/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  /// The main set game.
  private var setGame = SetGame()
  
  /// The card buttons being displayed in the UI.
  @IBOutlet var cardButtons: [UIButton]!
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _ = setGame.dealCards(forAmount: 12)
  }

  // MARK: Actions
  
  @IBAction func didTapCard(_ sender: UIButton) {
    
  }
  
  @IBAction func didTapDealMore(_ sender: UIButton) {
    
  }
  
  @IBAction func didTapNewGame(_ sender: UIButton) {
    
  }
}

