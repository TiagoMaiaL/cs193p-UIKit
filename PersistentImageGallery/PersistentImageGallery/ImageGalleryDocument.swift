//
//  ImageGalleryDocument.swift
//  PersistentImageGallery
//
//  Created by Tiago Maia Lopes on 03/04/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class ImageGalleryDocument: UIDocument {
  
  // MARK: - Properties
  
  /// The gallery stored by this document.
  var gallery: ImageGallery?
  
  // MARK: - Life cycle
  
  override func contents(forType typeName: String) throws -> Any {
    return gallery?.json ?? Data()
  }
  
  override func load(fromContents contents: Any, ofType typeName: String?) throws {
    if let data = contents as? Data {
      gallery = ImageGallery(json: data)
    }
  }
}

