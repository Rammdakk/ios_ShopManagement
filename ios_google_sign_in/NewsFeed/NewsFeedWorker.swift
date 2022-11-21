//
// Created by Рамиль Зиганшин on 24.10.2022.
//

import UIKit
import GoogleSignIn

protocol NewsFeedWorkerLogic {
    typealias Model = NewsFeedModel
    func getNews(_ request: Model.GetNews.Request, completion: @escaping (Model.ItemsList) -> Void)
    func getNewsWithRefreshingTokens(_ request: Model.GetNews.Request, completion: @escaping (Model.ItemsList) -> Void)
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
                type: Auth.self)
        else {
            return
        }
        var accessToken = result.accessToken
// swiftlint:disable all
        accessToken = "ya29.a0AeTM1ifQEazfiEATVRFIZJ5DiTmF-2Qf5EDL8bVI6_2M8o8-4k603Tqk8ddvpyp5juLQ-HDdjQNJGruhC2QyDXBvWx_-gisLyBvhwMr22v8Fn9uMzaLsIT3S0MTpjfljCaUayApgPqVM-wQSiqYhjkC_4Fj2jgaCgYKAVMSAQ8SFQHWtWOmDZ69zel9-JyOpzyZZe2ncg0165"
// swiftlint:enable all
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
                print("check")
                print(response)
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
        let authentication = GIDSignIn.sharedInstance.currentUser?.authentication
        authentication?.do { auth, error in
            guard let accessToken = auth?.accessToken else {
                print("error ac2")
                print(error)
                return
            }
            let sheetID = "1HvXfgK2VJBIvJEWVHD4jy4ClPLzfh_l-CUDX0AxiEnA"
            let range = "A2:D100"
            guard let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/\(range)") else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            print("************")
            print(request)
            print(accessToken)
            print("************")
            let task = self.session.dataTask(with: request) { [weak self] data, response, error in
                if
                        let data = data,
//                    let error = error as? NSError,
                        let items = try? self?.decoder.decode(Model.ItemsList.self, from: data) {
                    print("error.status")
                    print(error)
                    print(response)
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
