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

    private let signInButton = UIButton()

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
            let viewController = ProductListAssembly.build()
            self.navigationController?.setViewControllers([viewController], animated: true)
        }
    }

    private func setupView() {
        view.backgroundColor = .systemGray6
        self.navigationItem.title = "Sign-In"
        signInButtonSetUp()
    }

    private func signInButtonSetUp() {
        let fileManager = FileManager.default
        signInButton.setImage(fileManager.getImageInBundle(bundlePath: "google.png"), for: .normal)
        signInButton.contentHorizontalAlignment = .fill
        signInButton.imageView?.contentMode = .scaleAspectFit
        NSLayoutConstraint(item: signInButton.imageView,
                           attribute:NSLayoutConstraint.Attribute.centerY, relatedBy:
                            NSLayoutConstraint.Relation.equal, toItem: signInButton, attribute:
                            NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true

        signInButton.imageView?.pinLeft(to: signInButton)
        signInButton.imageView?.pinHeight(to: signInButton.heightAnchor, 0.6)
        signInButton.backgroundColor = .white
        signInButton.layer.borderWidth = 1.0
        signInButton.layer.cornerRadius = 30
        signInButton.layer.borderColor = UIColor.black.cgColor
        signInButton.setHeight(to: 60)
        signInButton.setTitle("Continue with Google", for: .normal)
        signInButton.setTitleColor(.black, for: .normal)
        signInButton.titleLabel?.textAlignment = .left
        signInButton.titleLabel?.pinLeft(to: signInButton.imageView ?? signInButton, 90)
        signInButton.sizeToFit()
        view.addSubview(signInButton)
        signInButton.pinBottom(to: view.centerYAnchor, -24)
        signInButton.pin(to: view, [.left: 24, .right: 24])
        signInButton.addTarget(self, action:
        #selector(googleSetUp), for: .touchUpInside)
    }
}
