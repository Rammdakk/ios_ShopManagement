//
// Created by Рамиль Зиганшин on 29.11.2022.
//

import UIKit

protocol SettingsDisplayLogic: AnyObject {
    typealias Model = ProductListResponceModel
    func displayData(_ viewModel: [String])
    func displayError(_ errorMessage: String)
}

final class SettingsViewController: UIViewController {
    // MARK: - Internal vars
    private var interactor: SettingBusinessLogic
    private var sheetLink = UITextView()
    private var pageNumberTitle = UITextView()
    private var pageNumberText = UITextView()
    private var decreaseButton = UIButton()
    private var increaseButton = UIButton()
    private var sendButton = UIButton()
    private var pageNumber: Int = UserDefaults.standard.integer(forKey: SettingKeys.pageNumber)

    // MARK: - Init
    init(interactor: SettingBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        setUpSendButton()
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
        sheetLink.font = .systemFont(ofSize: 18, weight: .medium)
        if let sheetsId = UserDefaults.standard.string(forKey: SettingKeys.sheetsID) {
            sheetLink.text = "https://docs.google.com/spreadsheets/d/" + sheetsId
        } else {
            sheetLink.text = " Ссылка на таблицу"
        }
        sheetLink.textColor = UIColor.lightGray
        sheetLink.layer.borderWidth = 1.0
        sheetLink.layer.cornerRadius = 8
        sheetLink.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(sheetLink)
        sheetLink.pin(to: view, [.left: 18, .right: 18])
        sheetLink.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 40)
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
        pageNumberTitle.pinTop(to: sheetLink.bottomAnchor, 15)
        pageNumberTitle.isEditable = false

        increaseButton.backgroundColor = .label
        increaseButton.setTitle("+", for: .normal)
        increaseButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        view.addSubview(increaseButton)
        increaseButton.pinTop(to: sheetLink.bottomAnchor, 15)
        increaseButton.pinRight(to: sheetLink.trailingAnchor)
        increaseButton.layer.cornerRadius = 8
        increaseButton.clipsToBounds = true
        increaseButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        increaseButton.addTarget(self, action: #selector(increase), for: .touchUpInside)

        pageNumberText.isScrollEnabled = false
        pageNumberText.font = .systemFont(ofSize: 16, weight: .medium)
        pageNumberText.text = String(pageNumber)
        pageNumberText.textAlignment = .center
        pageNumberText.backgroundColor = .label
        pageNumberText.textColor = .systemBackground
        view.addSubview(pageNumberText)
        pageNumberText.pinRight(to: increaseButton.leadingAnchor)
        pageNumberText.pinTop(to: sheetLink.bottomAnchor, 15)
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
        decreaseButton.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        sendButton.isHidden = true
    }

    private func setUpSendButton() {
        sendButton.setTitle("Отправить", for: .normal)
        sendButton.backgroundColor = .label
        sendButton.setTitleColor(.systemBackground, for: .normal)
        view.addSubview(sendButton)
        sendButton.pin(to: view, [.left: 18, .right: 18])
        sendButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 10)
        sendButton.layer.cornerRadius = 8
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setHeight(to: 45)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }

    private func checkLink() {
        interactor.fetchNews(sheetID: parseInput(input: sheetLink.text))
    }

    private func parseInput(input: String) -> String {
        let str = input.substring(start: input.findEndPos(search: "/d/") ?? String.Index(utf16Offset: 0, in: input))
        return str.substring(end: str.findStartPos(search: "/") ?? String.Index(utf16Offset: str.count, in: str))
    }

    // MARK: - Objc functions

    @objc
    func increase() {
        pageNumber += 1
        pageNumberText.text = String(pageNumber)
    }

    @objc
    func decrease() {
        if pageNumber > 0 {
            pageNumber -= 1
            pageNumberText.text = String(pageNumber)
        }
    }

    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    func sendMessage(sender: UIButton!) {
        if sheetLink.text.isEmpty {
            return
        }
        UserDefaults.standard.setValue(parseInput(input: sheetLink.text), forKey: SettingKeys.sheetsID)
        UserDefaults.standard.setValue(pageNumber, forKey: SettingKeys.pageNumber)
        navigationController?.popViewController(animated: true)
    }

    @objc
    func dismiss(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: - UITextViewDelegate

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
        } else{
            checkLink()
        }
    }
}

// MARK: - SettingsListDisplayLogic

extension SettingsViewController: SettingsDisplayLogic{
    func displayData(_ viewModel: [String]){
        print(viewModel)
        DispatchQueue.main.async { [weak self] in
            self?.sendButton.isHidden = false
        }

    }
    func displayError(_ errorMessage: String) {
        print(errorMessage)
    }
}
