//
// Created by Рамиль Зиганшин on 24.10.2022.
//

import UIKit

final class ProductInfoViewController: UIViewController {
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UITextView()
    private var phoneNumberField = UITextView()
    private var mesageTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpKeyboard()
    }

    deinit {
        unsubscribeFromKeyboard()
    }

// MARK: - Keyboard setUp

    func setUpKeyboard() {
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillShow),
                name: UIWindow.keyboardWillShowNotification,
                object: nil)

        NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillHide),
                name: UIResponder.keyboardWillHideNotification,
                object: nil)
    }

    var delta: Double?

    func unsubscribeFromKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification,
                object: nil)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification,
                object: nil)
    }

    // swiftlint:disable force_cast

    @objc
    func keyboardWillShow(_ notification: NSNotification) {

        print("keyboardWillShow")
        guard let userInfo = notification.userInfo else {
            return
        }

        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let originFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if targetFrame.equalTo(originFrame) {
            return
        }
        delta = targetFrame.origin.y - phoneNumberField.frame.origin.y - phoneNumberField.frame.height - 10.0

        UIView.animateKeyframes(withDuration: duration, delay: 0.0,
                options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: { [self] in
            view.frame.origin.y += delta ?? 0
        })
    }

    @objc
    func keyboardWillHide(_ notification: NSNotification) {
        print("keyboardWillHide")
        guard let userInfo = notification.userInfo else {
            return
        }

        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt

        UIView.animateKeyframes(withDuration: duration, delay: 0.0,
                options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: { [self] in
            view.frame.origin.y -= delta ?? 0
        })
    }

// swiftlint:enable force_cast

// MARK: - Configure
    func setData(viewModel: ProductViewMode) {
        titleLabel.text = viewModel.title
//        descriptionLabel.dataDetectorTypes = .link
//        let attributedString = NSMutableAttributedString(string: "Чек")
//        attributedString.setAttributes([.link: URL(string: viewModel.checlLink)!], range: NSMakeRange(0, 2))
//        descriptionLabel.attributedText = attributedString
        descriptionLabel.text = viewModel.description
        descriptionLabel.isEditable = false
        if let data = viewModel.imageData {
            imageView.image = UIImage(data: data)
        }
    }

// MARK: - Private methods

    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavbar()
        setImageView()
        setTitleLabel()
        setDescriptionLabel()
        setUpPhoneTextView()
    }

    private func setupNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
    }

    private func setImageView() {
        //  imageView.image = UIImage(named: "landscape")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.pin(to: view, [.left: 0, .right: 0])
        imageView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        imageView.pinHeight(to: imageView.widthAnchor, 1)
    }

    private func setTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: imageView.bottomAnchor, 12)
        titleLabel.pin(to: view, [.left: 16, .right: 16])
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
    }

    private func setDescriptionLabel() {
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        view.addSubview(descriptionLabel)
        descriptionLabel.pin(to: view, [.left: 16, .right: 16])
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 8)
        descriptionLabel.isScrollEnabled = false
    }

    private func setUpPhoneTextView() {
        phoneNumberField.isScrollEnabled = false
        phoneNumberField.keyboardType = .phonePad
        phoneNumberField.layer.borderWidth = 1.0
        phoneNumberField.layer.cornerRadius = 8
        phoneNumberField.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(phoneNumberField)
        phoneNumberField.pin(to: view, [.left: 18, .right: 18])
        phoneNumberField.pinTop(to: descriptionLabel.bottomAnchor, 8)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Objc functions

    @objc
    func dismiss(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
