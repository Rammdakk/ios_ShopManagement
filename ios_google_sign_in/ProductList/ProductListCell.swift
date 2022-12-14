//
// Created by Рамиль Зиганшин on 24.10.2022.
//

import UIKit

final class ProductListCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductCell"
    private let productImageView = WebImageView()
    private let productTitle = UILabel()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func setupView() {
        setupPriceLabel()
        setupDescriptionLabel()
        setupTitleLabel()
        setupImageView()
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
    }

    private func setupImageView() {
        productImageView.layer.cornerRadius = 8
        productImageView.layer.cornerCurve = .continuous
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFit
        productImageView.backgroundColor = .systemBackground
        contentView.addSubview(productImageView)
        productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productImageView.bottomAnchor.constraint(equalTo: productTitle.topAnchor, constant: -6).isActive = true
        productImageView.pinWidth(to: productTitle.widthAnchor)
    }

    private func setupTitleLabel() {
        productTitle.font = .systemFont(ofSize: 14, weight: .medium)
        productTitle.textColor = .label
        productTitle.lineBreakMode = .byWordWrapping
        productTitle.numberOfLines = 2
        contentView.addSubview(productTitle)
        productTitle.translatesAutoresizingMaskIntoConstraints = false
        productTitle.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        productTitle.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: -8).isActive = true
        productTitle.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -4).isActive = true
    }

    private func setupDescriptionLabel() {
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 1
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: -8).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant:
        -4).isActive = true
    }

    private func setupPriceLabel() {
        priceLabel.font = .systemFont(ofSize: 14, weight: .medium)
        priceLabel.textColor = .label
        priceLabel.numberOfLines = 1
        contentView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:
        4).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:
        4).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:
        -8).isActive = true
    }

    func configure(with product: ProductViewModel) {
        productTitle.text = product.title + "\n"
        descriptionLabel.text = product.description.replacingOccurrences(of: "\n", with: " ")
        if product.price.isEmpty {
            priceLabel.text = "Цена не указана"
        } else {
            priceLabel.text = "₽" + product.price
        }
        productImageView.set(imageURL: product.imageURL)
    }

    override func prepareForReuse() {
        productImageView.image = nil
        productTitle.text = nil
        descriptionLabel.text = nil
        priceLabel.text = nil
    }
}
