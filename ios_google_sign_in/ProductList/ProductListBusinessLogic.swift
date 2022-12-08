//
//  NewsFeedBusinessLogicAndInteractor.swift
//  riziganshinPW5
//
//  Created by Рамиль Зиганшин on 20.10.2022.
//

import UIKit

protocol ProductListBusinessLogic {
    typealias Model = ProductListResponceModel
    func fetchNews(_ request: Model.GetNews.Request)
}

class ProductListInteractor {
    // MARK: - External vars
    private let presenter: ProductListPresentationLogic
    private let worker: ProductListWorkerLogic

    init(
            presenter: ProductListPresentationLogic,
            worker: ProductListWorkerLogic
    ) {
        self.presenter = presenter
        self.worker = worker
    }

}

// MARK: - Business logic

extension ProductListInteractor: ProductListBusinessLogic {
    func fetchNews(_ request: Model.GetNews.Request) {
        worker.getProductsWithRefreshingTokens(request) { [weak self] result in
            switch result {
            case .success(let items):
                print("success")
                self?.presenter.presentData(Model.GetNews.Response(values: items))
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
