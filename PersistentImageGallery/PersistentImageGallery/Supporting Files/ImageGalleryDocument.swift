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
  
  /// The document thumbnail.
  var thumbnail: UIImage?
  
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
  
  override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocumentSaveOperation) throws -> [AnyHashable : Any] {
    var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
    if let thumbnail = thumbnail {
      attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey : thumbnail]
    }
    
    return attributes
  }
}

