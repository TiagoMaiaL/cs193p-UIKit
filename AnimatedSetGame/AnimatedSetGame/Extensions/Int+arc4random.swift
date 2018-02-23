//
//  Int+arc4random.swift
//  Concentration
//
//  Created by Tiago Maia Lopes on 1/21/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation

extension Int {
  
  /// A facility property for accessing a random
  /// value from the current Int instance.
  var arc4random: Int {
    return Int(arc4random_uniform(UInt32(self)))
  }
}
