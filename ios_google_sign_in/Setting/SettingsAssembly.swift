//
//  SettingsAssembly.swift
//  ios_google_sign_in
//
//  Created by Рамиль Зиганшин on 08.12.2022.
//

import UIKit

class SettingsAssembly {
    static func build() -> UIViewController {
        let presenter = SettingPresenter()
        let worker = SettingWorker()
        let interactor = SettingInteractor(presenter: presenter, worker: worker)
        let viewController = SettingsViewController(interactor: interactor)
        presenter.viewController = viewController
        return viewController
    }
}
