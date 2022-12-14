//
// Created by Рамиль Зиганшин on 24.10.2022.
//

enum ProductListResponceModel {
    enum GetData {
        struct Request {
        }

        struct Response {
            var values: ItemsList
        }
    }

    // MARK: - Product

    struct ItemsList: Decodable {
        let values: [[String]]?
    }

    struct Error: Decodable {
        let code: Int
        let message: String
        let status: String
    }
}

public enum Result<Success, Failure: Swift.Error> {
    /// A success, storing a `Success` value.
    case success(Success)
    /// A failure, storing a `Failure` value.
    case failure(Failure)
}

public enum Error: Swift.Error {
    case badURL
    case decoding
    case emptyData
    case noAccessToken
    case network(Swift.Error)
    
}
