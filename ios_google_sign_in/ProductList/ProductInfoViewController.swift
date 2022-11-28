//
// Created by Рамиль Зиганшин on 24.10.2022.
//

import UIKit

final class ProductInfoViewController: UIViewController {
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UITextView()
    private var phoneNumberField = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

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
        descriptionLabel.backgroundColor = .green
        view.addSubview(descriptionLabel)
        descriptionLabel.pin(to: view, [.left: 16, .right: 16])
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 8)
        descriptionLabel.isScrollEnabled = false
    }

    private func setUpPhoneTextView() {
        phoneNumberField.isScrollEnabled = false
        phoneNumberField.keyboardType = .phonePad
        view.addSubview(phoneNumberField)
        phoneNumberField.pin(to: view, [.left: 16, .right: 16])
        phoneNumberField.pinTop(to: descriptionLabel.bottomAnchor, 8)
    }

    // MARK: - Objc functions

    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
