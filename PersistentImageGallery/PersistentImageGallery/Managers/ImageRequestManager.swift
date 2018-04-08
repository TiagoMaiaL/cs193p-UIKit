//
//  ImageRequestManager.swift
//  PersistentImageGallery
//
//  Created by Tiago Maia Lopes on 08/04/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation

/// The ImageRequestManager's delegate.
protocol ImageRequestManagerDelegate {
  
  /// Method called when the response returns successfully.
  func didReceiveReponseData(_ data: Data, at url: URL)
  
  /// Method called when there's an error reported by the server.
  func didReceiveErrorResponse(_ response: URLResponse)
  
  /// Method called when there's a transport error.
  func didReceiveClientError(_ error: Error)
}

/// Class in charge of requesting the provided images
/// from the internet and cache them.
class ImageRequestManager {
  
  // MARK: - Properties
  
  /// The manager's delegate.
  var delegate: ImageRequestManagerDelegate?

  private lazy var configuration: URLSessionConfiguration = {
    let configuration = URLSessionConfiguration.default
    // TODO: Configure the cache policy and the cache object here.
    return configuration
  }()
  
  /// The session used to make each data task.
  private(set) lazy var session: URLSession = {
    let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    return session
  }()
  
  // MARK: - Imperatives
  
  /// Requests an image at the provided URL.
  func request(at url: URL) {
    let task = session.dataTask(with: url) { (data, response, transportError) in
      
      guard transportError == nil else {
        self.delegate?.didReceiveClientError(transportError!)
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else {
          // TODO: Check for the response's mime type as well.
          self.delegate?.didReceiveErrorResponse(response!)
          return
      }
      
      self.delegate?.didReceiveReponseData(data!, at: url)
    }
    task.resume()
  }
  
}
