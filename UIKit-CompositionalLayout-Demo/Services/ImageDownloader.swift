//
//  ImageDownloader.swift
//  UIKit-CompositionalLayout-Demo
//
//  Created by yilmaz on 7.10.2022.
//

import UIKit

class ImageDownloader {

    private var imageDataTask: URLSessionDataTask?
    private let cache = ImageCache.cache

    func downloadPhoto(with url: URL, completion: @escaping ((UIImage?, Bool) -> Void)) {

        if let data = ImageCache.imageData(for: url),
            let image = UIImage(data: data) {
            completion(image, true)
            return
        }

        imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            self?.imageDataTask = nil

            guard let data = data,
                  let response = response,
                  let image = UIImage(data: data),
                  error == nil
            else { return }

            ImageCache.storeImageData(data: data, response: response, for: url)

            // Decode the JPEG image in a background thread
            DispatchQueue.global(qos: .userInteractive).async {
                let decodedImage = image.preloadedImage()
                completion(decodedImage, false)
            }
        }
        imageDataTask?.resume()
    }

    func cancel() {
        imageDataTask?.cancel()
    }

}
