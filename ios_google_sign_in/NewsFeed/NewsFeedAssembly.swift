//
// Created by Рамиль Зиганшин on 24.10.2022.
//

import UIKit

class NewsFeedAssembly {
    static func build() -> UIViewController {
        let presenter = NewsFeedPresenter()
        let worker = NewsFeedWorker()
        let interactor = NewsFeedInteractor(presenter: presenter, worker: worker)
        let vc = ItemsTableViewController(interactor: interactor)
        presenter.viewController = vc
        return vc
    }
}
