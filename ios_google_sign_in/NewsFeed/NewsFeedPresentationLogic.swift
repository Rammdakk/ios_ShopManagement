//
//  NewsFeedPresentationLogic.swift
//  riziganshinPW5
//
//  Created by Рамиль Зиганшин on 20.10.2022.
//

import UIKit

protocol NewsFeedPresentationLogic {
    typealias Model = NewsFeedModel
    func presentData(_ response: Model.GetNews.Response)
}

class NewsFeedPresenter {
    // MARK: - External vars
    weak var viewController: NewsFeedDisplayLogic?
}

// MARK: - PresentationLogic

extension NewsFeedPresenter: NewsFeedPresentationLogic {
    func presentData(_ response: Model.GetNews.Response) {

        let data: [NewsViewModel]? = response.values.values?.map { (element: [String]) in
            NewsViewModel(title: element[0], checlLink: element[2], imageUrlPath: element[3], price: element[1])
     
            
        }

        viewController?.displayData(data ?? [NewsViewModel]())
    }
}
