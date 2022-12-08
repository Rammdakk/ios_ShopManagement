//
// Created by Рамиль Зиганшин on 24.10.2022.
//

import UIKit

final class ProductViewModel {
    let title: String
    let description: String
    let invoiceLink: String
    let price: String
    let imageURL: URL?
    var imageData: Data?

    init(title: String, checkLink: String,
         description: String = "", imageUrlPath: String?, price: String?) {
        self.title = title
        self.description = description
        invoiceLink = checkLink
        self.price = price ?? ""
        if let imageURL = URL(string: imageUrlPath ?? "https://www.short.ink/zv8gTW8R0eu") {
            self.imageURL = imageURL
        } else {
            imageURL = URL(string: "https://www.short.ink/zv8gTW8R0eu")
        }
    }
}
