//
// Created by Рамиль Зиганшин on 29.11.2022.
//

import UIKit

final class SettingsViewController: UIViewController {
    private var sheetLink = UITextView()
    private var pageNumberTitle = UITextView()
    private var pageNumberText = UITextView()
    private var decreaseButton = UIButton()
    private var increaseButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI setup methods

    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavbar()
        setSheetsLabel()
        setUpPageSelector()
    }

    private func setupNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(goBack)
        )
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem?.tintColor = .label
    }

    private func setSheetsLabel() {
        sheetLink.isScrollEnabled = false
        sheetLink.font = .systemFont(ofSize: 20, weight: .medium)
        sheetLink.text = "Ссылка на таблицу"
        sheetLink.textColor = UIColor.lightGray
        sheetLink.layer.borderWidth = 1.0
        sheetLink.layer.cornerRadius = 8
        sheetLink.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(sheetLink)
        sheetLink.pin(to: view, [.left: 18, .right: 18])
        sheetLink.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 40)
        sheetLink.setHeight(to: 45)
        sheetLink.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(tap)
    }

    private func setUpPageSelector() {
        pageNumberTitle.isScrollEnabled = false
        pageNumberTitle.font = .systemFont(ofSize: 16, weight: .medium)
        pageNumberTitle.text = "Номер страницы"
        pageNumberTitle.textColor = UIColor.lightGray
        view.addSubview(pageNumberTitle)
        pageNumberTitle.pin(to: view, [.left: 20, .right: 190])
        pageNumberTitle.pinTop(to: sheetLink.bottomAnchor, 10)
        pageNumberTitle.isEditable = false

        increaseButton.backgroundColor = .label
        increaseButton.setTitle("+", for: .normal)
        increaseButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        view.addSubview(increaseButton)
        increaseButton.pinTop(to: sheetLink.bottomAnchor, 10)
        increaseButton.pinRight(to: sheetLink.trailingAnchor)
        increaseButton.layer.cornerRadius = 8
        increaseButton.clipsToBounds = true
        increaseButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]

        pageNumberText.isScrollEnabled = false
        pageNumberText.font = .systemFont(ofSize: 16, weight: .medium)
        pageNumberText.text = "0"
        pageNumberText.textAlignment = .center
        pageNumberText.backgroundColor = .label
        pageNumberText.textColor = .systemBackground
        view.addSubview(pageNumberText)
        pageNumberText.pinRight(to: increaseButton.leadingAnchor)
        pageNumberText.pinTop(to: sheetLink.bottomAnchor, 10)
        pageNumberText.isEditable = false
        increaseButton.pinBottom(to: pageNumberText.bottomAnchor)

        decreaseButton.backgroundColor = .label
        view.addSubview(decreaseButton)
        decreaseButton.setTitle("-", for: .normal)
        decreaseButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        decreaseButton.pinTop(to: pageNumberText.topAnchor)
        decreaseButton.pinRight(to: pageNumberText.leadingAnchor)
        decreaseButton.pinBottom(to: pageNumberText.bottomAnchor)
        decreaseButton.layer.cornerRadius = 8
        decreaseButton.clipsToBounds = true
        decreaseButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

    // MARK: - Objc functions

    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    func dismiss(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension SettingsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Ссылка на таблицу"
            textView.textColor = UIColor.lightGray
        }
    }
}
