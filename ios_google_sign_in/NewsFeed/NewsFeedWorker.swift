//
// Created by Рамиль Зиганшин on 24.10.2022.
//

import UIKit
import GoogleSignIn

protocol NewsFeedWorkerLogic {
    typealias Model = NewsFeedModel
    func getNews(_ request: Model.GetNews.Request, completion: @escaping (Model.ItemsList) -> Void)
    func loadImage(from urlString: String, completion: @escaping (_ data: Data?) -> Void)
}

class NewsFeedWorker: NewsFeedWorkerLogic {
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
                                                        type: Auth.self) else {
            return
        }
        let accessToken = result.accessToken
        print(accessToken)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            if
                    let data = data,
//                    let error = error as? NSError,
                    let items = try? self?.decoder.decode(Model.ItemsList.self, from: data) {
                print("error.status")
                print(error)
                if ((response as? HTTPURLResponse)?.statusCode == 401) {
                    print("401")
                    self?.getNewsWithRefreshingTokens(requests, completion: completion)
                    return
                }
                print("check")
                print(items)
                completion(items)
            } else {
                print("Could not get any content")
                print(error)
            }
        }

        task.resume()
    }
    
    
    func getNewsWithRefreshingTokens(_ request: Model.GetNews.Request, completion: @escaping (Model.ItemsList) -> Void) {
        print("trying to refresh token")
        guard let url = URL(string: "https://accounts.google.com/o/oauth2/token") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let result = KeychainHelper.standard.read(service: service,
                                                  account: account,
                                                        type: Auth.self) else {
            return
        }
        let accessToken = result.accessToken
        print(accessToken)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            if
                    let data = data,
//                    let error = error as? NSError,
                    let items = try? self?.decoder.decode(Model.ItemsList.self, from: data) {
                print("error.status")
                print(error)
                if ((response as? HTTPURLResponse)?.statusCode == 401) {
                    
                }
                print(items)
                completion(items)
            } else {
                print("Could not get any content")
                print(error)
            }
        }

        task.resume()
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
