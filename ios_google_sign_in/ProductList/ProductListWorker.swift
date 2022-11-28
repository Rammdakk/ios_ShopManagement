//
// Created by Рамиль Зиганшин on 24.10.2022.
//

import UIKit
import GoogleSignIn

protocol ProductListWorkerLogic {
    typealias Model = ProductListResponceModel
    func getNews(_ request: Model.GetNews.Request, completion: @escaping (Model.ItemsList) -> Void)
    func getNewsWithRefreshingTokens(_ request: Model.GetNews.Request, completion: @escaping (Model.ItemsList) -> Void)
    func loadImage(from urlString: String, completion: @escaping (_ data: Data?) -> Void)
}

class ProductListWorker: ProductListWorkerLogic {
    private let decoder: JSONDecoder = JSONDecoder()
    private let session: URLSession = URLSession.shared

    func getNews(_ requests: Model.GetNews.Request, completion: @escaping (Model.ItemsList) -> Void) {
        let sheetID = "1HvXfgK2VJBIvJEWVHD4jy4ClPLzfh_l-CUDX0AxiEnA"
        let range = "A2:D100"
        guard let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/\(range)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        guard let result = KeychainHelper.standard.read(service: service,
                account: account,
                type: Auth.self)
        else {
            return
        }
        let accessToken = result.accessToken
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            if
                    let data = data,
                    let items = try? self?.decoder.decode(Model.ItemsList.self, from: data) {
                if (response as? HTTPURLResponse)?.statusCode == 401 {
                    print("401")
                    self?.getNewsWithRefreshingTokens(requests, completion: completion)
                    return
                }
                completion(items)
            } else {
                print("Could not get any content")
                print(error as Any)
            }
        }

        task.resume()
    }

    func getNewsWithRefreshingTokens(_ request: Model.GetNews.Request,
                                     completion: @escaping (Model.ItemsList) -> Void) {
        print("getNewsWithRefreshingTokens")
        let authentication = GIDSignIn.sharedInstance.currentUser?.authentication
        authentication?.do { auth, _ in
            guard let accessToken = auth?.accessToken else {
                return
            }
            let sheetID = "1HvXfgK2VJBIvJEWVHD4jy4ClPLzfh_l-CUDX0AxiEnA"
            let range = "A2:E100"
            guard let url =
            URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/\(range)")
            else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            let task = self.session.dataTask(with: request) { [weak self] data, response, _ in
                if
                        let data = data,
                        let items = try? self?.decoder.decode(Model.ItemsList.self, from: data) {
                    if (response as? HTTPURLResponse)?.statusCode == 401 {
                    }
                    completion(items)
                } else {
                    print("Could not get any content")
                }
            }
            task.resume()
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
