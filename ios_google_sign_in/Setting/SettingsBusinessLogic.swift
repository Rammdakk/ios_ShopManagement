//
//  SettingsBusinessLogic.swift
//  ios_google_sign_in
//
//  Created by Рамиль Зиганшин on 08.12.2022.
//

import UIKit

protocol SettingBusinessLogic {
    typealias Model = ProductListResponceModel
    func fetchSheetsList(sheetID: String)
}

class SettingInteractor {
    // MARK: - External vars
    private let presenter: SettingPresentationLogic
    private let worker: SettingWorkerLogic

    init(
            presenter: SettingPresentationLogic,
            worker: SettingWorkerLogic
    ) {
        self.presenter = presenter
        self.worker = worker
    }

}

// MARK: - Business logic

extension SettingInteractor: SettingBusinessLogic {
    func fetchSheetsList(sheetID: String) {
        worker.getSheets(sheetID: sheetID) { [weak self] result in
            switch result {
            case .success(let items):
                print("success")
                self?.presenter.presentData(items)
            case .failure(let err):
                print("failure")
                switch err {
                case .badURL:
                    self?.presenter.displayError("Некорректная ссылка на таблицу.")
                    print("badUrl")
                case .decoding:
                    self?.presenter.displayError("Ошибка получения данных.")
                    print("decoding")
                case .emptyData:
                    self?.presenter.displayError("Нет данных.")
                    print("noData")
                case .noAccessToken:
                    self?.presenter.displayError("Ошибка авторизации.")
                    print("noAccessToken")
                case .network(let error):
                    switch error._code {
                    case 401:
                        self?.presenter.displayError("Ошибка авторизации.")
                    case 403:
                        self?.presenter.displayError("Ошибка получения доступа к таблице.")
                    case 404:
                        self?.presenter.displayError("Ошибка, не удалось получить данные.")
                    case 500...599:
                        self?.presenter.displayError("Ошибка на сервере. Повторите позднее.")

                    default:
                        self?.presenter.displayError("Ошибка: \(error._code)")
                    }
                }

            }

        }
    }
}
