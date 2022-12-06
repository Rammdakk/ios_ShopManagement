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
//        var items: Model.ItemsList
        worker.getProductsWithRefreshingTokens(request) { [weak self] result in
            switch result {
            case .success(let items):
                print("success")
                self?.presenter.presentData(Model.GetNews.Response(values: items))
            case .failure(let err):
                print("failure")
                switch err {
                case .badURL:
                    self?.presenter.displayError("bad URL")
                    print("badUrl")
                case .decoding:
                    self?.presenter.displayError("bad URL")
                    print("decoding")
                case .emptyData:
                    self?.presenter.displayError("bad URL")
                    print("noData")
                case .noAccessToken:
                    self?.presenter.displayError("bad URL")
                    print("noAccessToken")
                case .network(let error):
                    self?.presenter.displayError("Error: \(error._code)")
                    print(error._code)
                }

            }

        }
    }
}
