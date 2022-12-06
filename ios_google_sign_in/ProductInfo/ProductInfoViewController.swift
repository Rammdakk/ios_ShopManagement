//
// Created by Рамиль Зиганшин on 24.10.2022.
//

import UIKit

final class ProductInfoViewController: UIViewController {
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.delegate = self
        scroll.contentSize = CGSize(width: self.view.frame.size.width, height: 2000)
        return scroll
    }()
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UITextView()
    private var phoneNumberField = UITextView()
    private var messageTextView = UITextView()
    private var sendButton = UIButton()

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

    func unsubscribeFromKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification,
                object: nil)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification,
                object: nil)
    }

    @objc
    func keyboardWillShow(_ notification: NSNotification) {

        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue)?.cgRectValue
        else {
            // if keyboard size is not available
            return
        }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc
    func keyboardWillHide(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

// MARK: - Configure
    func setData(viewModel: ProductViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        descriptionLabel.isEditable = false
        phoneNumberField.text = "+7"
        messageTextView.text = """
                               Спасибо за покупку \(viewModel.title)!\n
                               🧾Чек можно скачать тут: \(viewModel.invoiceLink)\nЖдем Вас снова!\n
                               """
        if let data = viewModel.imageData {
            imageView.image = UIImage(data: data)
        }
    }

// MARK: - SetUp UI

    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavbar()
        view.addSubview(scrollView)
        setImageView()
        setTitleLabel()
        setDescriptionLabel()
        setUpPhoneTextView()
        setUpMessageTextView()
        setUpSendButton()
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
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        imageView.pin(to: view, [.left: 0, .right: 0])
        imageView.pinTop(to: scrollView.topAnchor)
        imageView.pinHeight(to: imageView.widthAnchor, 1)
    }

    private func setTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        scrollView.addSubview(titleLabel)
        titleLabel.pinTop(to: imageView.bottomAnchor, 12)
        titleLabel.pin(to: view, [.left: 16, .right: 16])
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
    }

    private func setDescriptionLabel() {
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        scrollView.addSubview(descriptionLabel)
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
        scrollView.addSubview(phoneNumberField)
        phoneNumberField.pin(to: view, [.left: 18, .right: 18])
        phoneNumberField.pinTop(to: descriptionLabel.bottomAnchor, 8)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(tap)
    }

    private func setUpMessageTextView() {
        messageTextView.isScrollEnabled = false
        messageTextView.keyboardType = .default
        messageTextView.layer.borderWidth = 1.0
        messageTextView.layer.cornerRadius = 8
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor
        scrollView.addSubview(messageTextView)
        messageTextView.pin(to: view, [.left: 18, .right: 18])
        messageTextView.pinTop(to: phoneNumberField.bottomAnchor, 8)
    }

    private func setUpSendButton() {
        sendButton.setTitle("Отправить", for: .normal)
        sendButton.backgroundColor = .label
        sendButton.setTitleColor(.systemBackground, for: .normal)
        scrollView.addSubview(sendButton)
        sendButton.pin(to: view, [.left: 18, .right: 18])
        sendButton.layer.cornerRadius = 8
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setHeight(to: 45)
        NSLayoutConstraint.activate([
            sendButton.bottomAnchor.constraint(equalTo: scrollView.frameLayoutGuide.bottomAnchor, constant: -5)
        ])
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }

    // MARK: - Objc functions

    @objc
    func sendMessage(sender: UIButton!) {
        if phoneNumberField.text.count < 5 {
            // TODO: - Show warning
            return
        }
        let queryItems = [URLQueryItem(name: "text", value: messageTextView.text)]
        var urlComps = URLComponents(string: "https://wa.me/\(phoneNumberField.text ?? "")")
        urlComps?.queryItems = queryItems
        if let url = urlComps?.url {
            print(url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("https://wa.me/\(phoneNumberField.text ?? "")?text=\(messageTextView.text ?? "")")
        }
    }

    @objc
    func dismiss(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension ProductInfoViewController: UIScrollViewDelegate {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = view.safeAreaLayoutGuide
        scrollView.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: layout.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: layout.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        var height = 10.0
        scrollView.subviews.forEach { view in
            height += view.layer.frame.height
        }
        scrollView.contentSize.height = height
    }
}
