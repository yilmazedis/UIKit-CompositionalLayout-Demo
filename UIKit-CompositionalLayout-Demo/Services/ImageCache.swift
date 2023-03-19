//
//  ImageCache.swift
//  UIKit-CompositionalLayout-Demo
//
//  Created by yilmaz on 7.10.2022.
//

import UIKit

class ImageCache {

    static let cache: URLCache = {
        let diskPath = "myCache"

        if #available(iOS 13.0, *) {
            let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let cacheURL = cachesDirectory.appendingPathComponent(diskPath, isDirectory: true)
            return URLCache(
                memoryCapacity: ImageCache.memoryCapacity,
                diskCapacity: ImageCache.diskCapacity,
                directory: cacheURL
            )
        } else {
            return URLCache(
                memoryCapacity: ImageCache.memoryCapacity,
                diskCapacity: ImageCache.diskCapacity,
                diskPath: diskPath
            )
        }
    }()
    
    static func storeImageData(data: Data, response: URLResponse, for url: URL) {
        let cachedResponse = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
    }

    static func imageData(for url: URL) -> Data? {
        return cache.cachedResponse(for: URLRequest(url: url))?.data
    }

    static let memoryCapacity: Int = 200.megabytes
    static let diskCapacity: Int = 400.megabytes
}

private extension Int {
    var megabytes: Int { return self * 1024 * 1024 }
}
