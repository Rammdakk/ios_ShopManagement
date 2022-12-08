//
// Created by Рамиль Зиганшин on 24.10.2022.
//

import UIKit
import GoogleSignIn

protocol ProductListWorkerLogic {
    typealias Model = ProductListResponceModel
    func getProductsWithRefreshingTokens(_ request: Model.GetNews.Request,
                                         completion: @escaping (Result<Model.ItemsList, Error>) -> Void)
    func loadImage(from urlString: String, completion: @escaping (_ data: Data?) -> Void)
}

class ProductListWorker: ProductListWorkerLogic {
    private let decoder: JSONDecoder = JSONDecoder()
    private let session: URLSession = URLSession.shared

    func getProductsWithRefreshingTokens(_ request: Model.GetNews.Request,
                                         completion: @escaping (Result<Model.ItemsList, Error>) -> Void) {
        let authentication = GIDSignIn.sharedInstance.currentUser?.authentication
        authentication?.do { auth, _ in
            guard let accessToken = auth?.accessToken else {
                completion(.failure(Error.noAccessToken))
                return
            }
            let range = "A2:E100"
            guard let sheetID: String = UserDefaults.standard.string(forKey: SettingKeys.sheetsID),
                  let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/\(range)")
            else {
                completion(.failure(Error.badURL))
                return
            }
            if (sheetID.count < 5) {
                completion(.failure(Error.badURL))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            self.session.dataTask(with: request) { [weak self] data, response, error in
                        if let error = error {
                            completion(.failure(Error.network(error)))
                        }
                        if (response as? HTTPURLResponse)?.statusCode != 200 {
                            completion(.failure(Error.network(NSError(domain: "",
                                                                      code: (response as? HTTPURLResponse)?.statusCode ?? 404, userInfo: nil))))
                            return
                        }
                        guard let data = data else {
                            completion(.failure(Error.emptyData))
                            return
                        }
                        if let items = try? self?.decoder.decode(Model.ItemsList.self, from: data) {
                            completion(.success(items))
                        } else {
                            completion(.failure(Error.decoding))
                        }
                    }
                    .resume()
        }
    }

    func loadImage(from urlString: String, completion: @escaping (_ data: Data?) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: urlString) else {
            return
        }
        let dataTask = session.dataTask(with: url) { (data, _, _) in
            if let data = data {
                completion(data)
            } else {
                print("Could not load image")
            }
        }
        dataTask.resume()
    }

}
