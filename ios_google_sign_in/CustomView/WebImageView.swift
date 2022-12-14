//
//  WebImageView.swift
//  ios_google_sign_in
//
//  Created by Рамиль Зиганшин on 14.12.2022.
//

import Foundation
import UIKit

class WebImageView: UIImageView {

    private var currentUrlString: URL?

    func set(imageURL: URL?) {
        currentUrlString = imageURL
        guard let url = imageURL else {
            self.image = FileManager.default.getImageInBundle(bundlePath: "no_image.jpg")
            return
        }
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            print("restore from cache")
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, _ in
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.handleLoadedImage(data: data, response: response)
                } else {
                    self?.image = FileManager.default.getImageInBundle(bundlePath: "no_image.jpg")
                }
            }
        }
        dataTask.resume()
    }

    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseUrl = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseUrl))
        if responseUrl.absoluteString == currentUrlString?.absoluteString {
            self.image = UIImage(data: data)
        }
    }
}
