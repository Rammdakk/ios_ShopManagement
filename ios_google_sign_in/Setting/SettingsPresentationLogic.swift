//
//  SettingsPresentationLogic.swift
//  ios_google_sign_in
//
//  Created by Рамиль Зиганшин on 08.12.2022.
//

import UIKit

protocol SettingPresentationLogic {
    func presentData(_ response: Sheet)
    func displayError(_ errorMessage: String)
}

class SettingPresenter {
    // MARK: - External vars
    weak var viewController: SettingsDisplayLogic?
}

// MARK: - PresentationLogic

extension SettingPresenter: SettingPresentationLogic {
    func presentData(_ response: Sheet) {
        let data: [String] = response.sheets.map { (element: SheetElement) in
            element.properties.title
        }
        viewController?.displayData(data)
    }

    func displayError(_ errorMessage: String) {
        viewController?.displayError(errorMessage)
    }
}
