//
//  SettingsWorker.swift
//  ios_google_sign_in
//
//  Created by Рамиль Зиганшин on 08.12.2022.
//

import UIKit
import GoogleSignIn

protocol SettingWorkerLogic {
    func getSheets(sheetID: String,
                   completion: @escaping (Result<Sheet, Error>) -> Void)
}

class SettingWorker: SettingWorkerLogic {
    private let decoder: JSONDecoder = JSONDecoder()
    private let session: URLSession = URLSession.shared

    func getSheets(sheetID: String,
                   completion: @escaping (Result<Sheet, Error>) -> Void) {
        let authentication = GIDSignIn.sharedInstance.currentUser?.authentication
        authentication?.do { auth, _ in
            guard let accessToken = auth?.accessToken else {
                completion(.failure(Error.noAccessToken))
                return
            }
            guard let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)")
            else {
                completion(.failure(Error.badURL))
                return
            }
            if sheetID.count < 5 {
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
                        if let items = try? self?.decoder.decode(Sheet.self, from: data) {
                            if !items.sheets.isEmpty {
                                completion(.success(items))
                                return
                            } else {
                                completion(.failure(Error.emptyData))
                                return
                            }
                        } else {
                            completion(.failure(Error.decoding))
                        }
                    }
                    .resume()
        }
    }
}
