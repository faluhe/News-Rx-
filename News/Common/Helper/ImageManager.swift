//
//  ImageManager.swift
//  News
//
//  Created by Ismailov Farrukh on 17/08/23.
//

import UIKit

final class ImageManager {

    static let shared = ImageManager()

    private let cache = ImageCache.shared

    private init() {}

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Check cache first
        if let cachedImage = cache.image(forKey: url.absoluteString) {
            print("Cached image found")
            DispatchQueue.main.async {
                completion(cachedImage)
            }
        } else {
            // Image not in cache, load it asynchronously
            DispatchQueue.global(qos: .background).async {
                if let imageData = try? Data(contentsOf: url),
                   let image = UIImage(data: imageData) {
                    // Store the image in the cache
                    self.cache.setImage(image, forKey: url.absoluteString)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }
}


