//
//  ImageRequestManager.swift
//  PersistentImageGallery
//
//  Created by Tiago Maia Lopes on 08/04/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation

/// Class in charge of requesting the provided images
/// from the internet and cache them.
class ImageRequestManager {
  
  // MARK: - Properties

  /// The session configuration object used to determine the cache
  /// policy and the disk space available.
  private lazy var configuration: URLSessionConfiguration = {
    // 80 MB for the image caching.
    let cache = URLCache(memoryCapacity: 0, diskCapacity: 80 * 1024 * 1024, diskPath: nil)
    
    let configuration = URLSessionConfiguration.default
    configuration.urlCache = cache
    configuration.requestCachePolicy = .returnCacheDataElseLoad
    
    return configuration
  }()
  
  /// The session used to make each data task.
  private(set) lazy var session: URLSession = {
    let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    return session
  }()
  
  // MARK: - Imperatives
  
  /// Requests an image at the provided URL.
  func request(
    at url: URL,
    withCompletionHandler completion: @escaping (Data) -> (),
    andErrorHandler onError: @escaping (Error?, URLResponse?) -> ()
  ) {
    let task = session.dataTask(with: url) { (data, response, transportError) in
      
      guard transportError == nil, let data = data else {
        onError(transportError, nil)
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode),
        ["image/jpeg", "image/png"].contains(httpResponse.mimeType) else {
          onError(nil, response)
          return
      }

      completion(data)
    }

    task.resume()
  }
  
}
