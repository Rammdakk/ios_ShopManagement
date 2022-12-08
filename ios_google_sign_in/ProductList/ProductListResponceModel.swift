//
// Created by Рамиль Зиганшин on 24.10.2022.
//

enum ProductListResponceModel {
    enum GetNews {
        struct Request {
        }

        struct Response {
            var values: ItemsList
        }
    }

    // MARK: - News

    struct ItemsList: Decodable {
        let values: [[String]]?
    }

    struct Error: Decodable {
        let code: Int
        let message: String
        let status: String
    }
}
