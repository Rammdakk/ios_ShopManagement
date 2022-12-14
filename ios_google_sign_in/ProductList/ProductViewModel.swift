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

    init(title: String, checkLink: String,
         description: String = "", imageUrlPath: String?, price: String?) {
        self.title = title
        self.description = description
        invoiceLink = checkLink
        self.price = price ?? ""
        if let imagePath = imageUrlPath,
           let imageURL = URL(string: imagePath) {
            self.imageURL = imageURL
        } else {
            imageURL = nil
        }
    }
}
