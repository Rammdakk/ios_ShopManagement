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
}

class ProductListPresenter {
    // MARK: - External vars
    weak var viewController: ProductListDisplayLogic?
}

// MARK: - PresentationLogic

extension ProductListPresenter: ProductListPresentationLogic {
    func presentData(_ response: Model.GetNews.Response) {

        let data: [ProductViewMode]? = response.values.values?.map { (element: [String]) in
            ProductViewMode(title: element[0], checlLink: element[2],
                    description: element[4], imageUrlPath: element[3], price: element[1])

        }
        viewController?.displayData(data ?? [ProductViewMode]())
    }
}
