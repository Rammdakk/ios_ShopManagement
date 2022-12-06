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
            ProductViewModel(title: element[0], checkLink: element[2],
                    description: element[4], imageUrlPath: element[3], price: element[1])

        }
        viewController?.displayData(data ?? [ProductViewModel]())
    }

    func displayError(_ errorMessage: String) {
        viewController?.displayError(errorMessage)
    }
}
