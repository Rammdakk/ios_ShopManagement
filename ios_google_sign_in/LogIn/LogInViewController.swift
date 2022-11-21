//
//  LogInViewController.swift
//  ios_google_sign_in
//
//  Created by Рамиль Зиганшин on 31.10.2022.
//

import UIKit
import GoogleSignIn
import Firebase
import Alamofire

class LogInViewController: UIViewController {

    private let incrementButton = GIDSignInButton()

    override func viewDidLoad() {
        super.viewDidLoad()
//        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
//            GIDSignIn.sharedInstance.restorePreviousSignIn()
//            let viewController = NewsFeedAssembly.build()
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
        setupView()


//        let result = KeychainHelper.standard.read(service: service,
//                account: account,
//                type: Auth.self)
//        if result != nil {
//            let viewController = NewsFeedAssembly.build()
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
    }

    static let sheetsReadScope = "https://www.googleapis.com/auth/spreadsheets"

    @objc
    private func googleSetUp() {
        guard let clientApiKey = FirebaseApp.app()?.options.apiKey else {
            return
        }
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self, hint: "",
                additionalScopes: [LogInViewController.sheetsReadScope]) { user, error in
            if let error = error {
                print(error)
                return
            }
            guard let accesToken = user?.authentication.accessToken,
                  let refreshToken = user?.authentication.refreshToken
            else {
                return
            }
            print(clientID)
            print(refreshToken)
//            print(GIDSignIn.sharedInstance.restorePreviousSignIn())
            let auth = Auth(accessToken: accesToken, refreshToken: refreshToken)
            KeychainHelper.standard.save(auth, service: service, account: account)
            let viewController = NewsFeedAssembly.build()
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
