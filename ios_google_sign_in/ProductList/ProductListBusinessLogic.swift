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
//        worker.getNews(request) { [weak self] result in
//            self?.presenter.presentData(Model.GetNews.Response(values: result))
//        }
        worker.getProductsWithRefreshingTokens(request) { [weak self] result in
            self?.presenter.presentData(Model.GetNews.Response(values: result))
        }
    }
}
