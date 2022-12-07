//
//  NewsFeedPresentationLogic.swift
//  riziganshinPW5
//
//  Created by Рамиль Зиганшин on 20.10.2022.
//

import UIKit

protocol ProductListPresentationLogic {
    typealias Model = ProductListResponceModel
    func presentData(_ response: Model.GetNews.Response)
    func displayError(_ errorMessage: String)
}

class ProductListPresenter {
    // MARK: - External vars
    weak var viewController: ProductListDisplayLogic?
}

// MARK: - PresentationLogic

extension ProductListPresenter: ProductListPresentationLogic {
    func presentData(_ response: Model.GetNews.Response) {
        let data: [ProductViewModel]? = response.values.values?.map { (element: [String]) in
            ProductViewModel(title: element.get(at: 0) ?? "-", checkLink: element.get(at: 2) ?? "",
                             description: element.get(at: 4) ?? " ", imageUrlPath: element.get(at: 3), price: element.get(at: 1))

        }
        viewController?.displayData(data ?? [ProductViewModel]())
    }

    func displayError(_ errorMessage: String) {
        viewController?.displayError(errorMessage)
    }
}
