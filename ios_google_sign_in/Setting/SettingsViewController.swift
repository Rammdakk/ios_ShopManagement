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
    private var sheetPageName = UITextView()
    private var sendButton = UIButton()
    private var pickerView = UIPickerView()
    private var errorButton = UIButton()
    private var data = [""]

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
        checkLink()
    }

    // MARK: - UI setup methods

    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavbar()
        setSheetsLabel()
        setUpPageSelector()
        setUpSendButton()
        setUpPicker()
        setUpErrorHandling()
    }

    private func setUpErrorHandling() {
        view.addSubview(errorButton)
        errorButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 2)
        errorButton.pin(to: view, [.right, .left], 8)
        errorButton.layer.cornerRadius = 8
        errorButton.translatesAutoresizingMaskIntoConstraints = false
        errorButton.setHeight(to: 45)
        errorButton.sizeToFit()
        errorButton.backgroundColor = .red
        errorButton.isHidden = true
        errorButton.addTarget(self, action: #selector(checkLink), for: .touchUpInside)
        errorButton.titleLabel?.numberOfLines = 0
        errorButton.titleLabel?.lineBreakMode = .byWordWrapping
    }

    private func setUpPicker() {
        pickerView.dataSource = self
        pickerView.delegate = self
        sheetPageName.inputView = pickerView
        sheetPageName.text = ""
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
            if sheetsId.isEmpty {
                sheetLink.text = " Ссылка на таблицу"
                sheetLink.textColor = UIColor.lightGray
            } else {
                sheetLink.text = "https://docs.google.com/spreadsheets/d/" + sheetsId
                sheetLink.textColor = UIColor.black
            }
        } else {
            sheetLink.text = " Ссылка на таблицу"
            sheetLink.textColor = UIColor.lightGray
        }
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
        pageNumberTitle.text = "Номер страницы:"
        pageNumberTitle.textColor = UIColor.lightGray
        view.addSubview(pageNumberTitle)
        pageNumberTitle.pin(to: view, [.left: 20, .right: 190])
        pageNumberTitle.pinTop(to: sheetLink.bottomAnchor, 15)
        pageNumberTitle.isEditable = false
        sheetPageName.isScrollEnabled = false
        sheetPageName.font = .systemFont(ofSize: 16, weight: .medium)
        sheetPageName.textAlignment = .center
        sheetPageName.layer.borderWidth = 1.0
        sheetPageName.layer.cornerRadius = 8
        sheetPageName.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(sheetPageName)
        sheetPageName.pinTop(to: sheetLink.bottomAnchor, 15)
        sheetPageName.pin(to: view, [.right: 18])
        sheetPageName.pinLeft(to: pageNumberTitle.trailingAnchor)
        sheetPageName.isEditable = false
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

    private func parseInput(input: String) -> String {
        let str = input.substring(start: input.findEndPos(search: "/d/") ?? String.Index(utf16Offset: 0, in: input))
        return str.substring(end: str.findStartPos(search: "/") ?? String.Index(utf16Offset: str.count, in: str))
    }

    // MARK: - Objc functions

    @objc
    private func checkLink() {
        errorButton.isHidden = true
        interactor.fetchSheetsList(sheetID: parseInput(input: sheetLink.text))
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
        UserDefaults.standard.setValue(sheetPageName.text, forKey: SettingKeys.pageNumber)
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
        sendButton.isHidden = true
        sheetPageName.isHidden = true
        pageNumberTitle.isHidden = true
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Ссылка на таблицу"
            textView.textColor = UIColor.lightGray
            data = []
            sheetPageName.text = ""
            sendButton.isHidden = true
            sendButton.isHidden = true
            sheetPageName.isHidden = true
            pageNumberTitle.isHidden = true
        } else {
            checkLink()
        }
    }
}

// MARK: - SettingsListDisplayLogic

extension SettingsViewController: SettingsDisplayLogic {
    func displayData(_ viewModel: [String]) {
        print(viewModel)
        DispatchQueue.main.async { [weak self] in
            self?.data = viewModel
            if let sheet = UserDefaults.standard.string(forKey: SettingKeys.pageNumber) {
                self?.sheetPageName.text = self?.data.contains(sheet) ?? true ? sheet : viewModel[0]
            } else {
                self?.sheetPageName.text = self?.data[0]
            }
            self?.sheetPageName.isHidden = false
            self?.pageNumberTitle.isHidden = false
            self?.sendButton.isHidden = false
        }
    }

    func displayError(_ errorMessage: String) {
        print(errorMessage)
        DispatchQueue.main.async { [weak self] in
            if let view = self?.errorButton {
                UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    view.isHidden = false
                })
                view.setTitle("\(errorMessage)\nПроверьте ссылку на таблицу", for: .normal)
                view.titleLabel?.textAlignment = .center
                view.sizeToFit()
            }
            self?.data = []
            self?.sheetPageName.text = ""
            self?.sendButton.isHidden = true
        }
    }
}

// MARK: - UIPickerViewDataSource

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
}

// MARK: - UIPickerViewDelegate

extension SettingsViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sheetPageName.text = data[row]
        self.view.endEditing(true)
    }

    func doneDistancePicker() {
        sheetPageName.resignFirstResponder()
    }

    func cancelDistancePicker() {
        sheetPageName.resignFirstResponder()
    }
}
