//
// Created by Рамиль Зиганшин on 24.10.2022.
//

import UIKit

final class NewsViewModel {
    let title: String
    let checlLink: String
    let price: String
    let imageURL: URL?
    var imageData: Data?

    init(title: String, checlLink: String, imageUrlPath: String, price: String) {
        self.title = title
        self.checlLink = checlLink
        self.price = price
        if let imageURL = URL(string: imageUrlPath){
            self.imageURL = imageURL
        } else  {
            self.imageURL = URL(string: "https://www.short.ink/zv8gTW8R0eu")
        }
    }
}
