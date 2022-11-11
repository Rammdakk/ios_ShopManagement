//
//  NewsFeedBusinessLogicAndInteractor.swift
//  riziganshinPW5
//
//  Created by Рамиль Зиганшин on 20.10.2022.
//

import UIKit

protocol NewsFeedBusinessLogic {
    typealias Model = NewsFeedModel
    func fetchNews(_ request: Model.GetNews.Request)
}

class NewsFeedInteractor {
    // MARK: - External vars
    private let presenter: NewsFeedPresentationLogic
    private let worker: NewsFeedWorkerLogic

    init(
            presenter: NewsFeedPresentationLogic,
            worker: NewsFeedWorkerLogic
    ) {
        self.presenter = presenter
        self.worker = worker
    }

}

// MARK: - Business logic

extension NewsFeedInteractor: NewsFeedBusinessLogic {
    func fetchNews(_ request: Model.GetNews.Request) {
        worker.getNews(request) { [weak self] result in
            self?.presenter.presentData(Model.GetNews.Response(values: result))
        }
    }
}
