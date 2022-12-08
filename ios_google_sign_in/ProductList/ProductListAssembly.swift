//
// Created by Рамиль Зиганшин on 24.10.2022.
//

import UIKit

class ProductListAssembly {
    static func build() -> UIViewController {
        let presenter = ProductListPresenter()
        let worker = ProductListWorker()
        let interactor = ProductListInteractor(presenter: presenter, worker: worker)
        let viewController = ProductListViewController(interactor: interactor)
        presenter.viewController = viewController
        return viewController
    }
}
