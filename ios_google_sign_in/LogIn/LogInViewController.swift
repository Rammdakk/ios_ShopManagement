//
//  LogInViewController.swift
//  ios_google_sign_in
//
//  Created by Рамиль Зиганшин on 31.10.2022.
//

import UIKit
import GoogleSignIn

let clientID: String = "966039622219-bqb5ebkp5stl4bqte6npvrg594c81viq.apps.googleusercontent.com"

class LogInViewController: UIViewController {

    private let incrementButton = GIDSignInButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    static let sheetsReadScope = "https://www.googleapis.com/auth/spreadsheets"

    @objc
    private func googleSetUp() {
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self, hint: "",
                additionalScopes: [LogInViewController.sheetsReadScope]) { user, error in
            if let error = error {
                print(error)
                return
            }
            guard let accessToken = user?.authentication.accessToken,
                  let refreshToken = user?.authentication.refreshToken
            else {
                return
            }
            let auth = Auth(accessToken: accessToken, refreshToken: refreshToken)
            KeychainHelper.standard.save(auth, service: service, account: account)
            let viewController = ProductListAssembly.build()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    private func setupView() {
        view.backgroundColor = .systemGray6
        setupIncrementButton()
    }

    private func setupIncrementButton() {
        incrementButton.backgroundColor = .systemGray6
        view.addSubview(incrementButton)
        incrementButton.setHeight(to: 48)
        incrementButton.pinBottom(to: view.centerYAnchor, -120)
        incrementButton.pin(to: view, [.left: 24, .right: 24])
        incrementButton.addTarget(self, action:
        #selector(googleSetUp), for: .touchUpInside)
    }
}
