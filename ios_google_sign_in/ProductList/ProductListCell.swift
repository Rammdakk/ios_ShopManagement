//
// Created by Рамиль Зиганшин on 24.10.2022.
//

import UIKit

final class ProductListCell: UICollectionViewCell {
    static let reuseIdentifier = "NewsCell"
    private let newsImageView = UIImageView()
    private let newsTitleLabel = UILabel()
    private let newsDescriptionLabel = UILabel()
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
        newsImageView.layer.cornerRadius = 8
        newsImageView.layer.cornerCurve = .continuous
        newsImageView.clipsToBounds = true
        newsImageView.contentMode = .scaleAspectFit
        newsImageView.backgroundColor = .systemBackground
        contentView.addSubview(newsImageView)
        newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        newsImageView.bottomAnchor.constraint(equalTo: newsTitleLabel.topAnchor, constant: -6).isActive = true
        newsImageView.pinWidth(to: newsTitleLabel.widthAnchor)
    }

    private func setupTitleLabel() {
        newsTitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        newsTitleLabel.textColor = .label
        newsTitleLabel.lineBreakMode = .byWordWrapping
        newsTitleLabel.numberOfLines = 2
        contentView.addSubview(newsTitleLabel)
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        newsTitleLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor).isActive = true
        newsTitleLabel.bottomAnchor.constraint(equalTo: newsDescriptionLabel.topAnchor, constant: -4).isActive = true
    }

    private func setupDescriptionLabel() {
        newsDescriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        newsDescriptionLabel.textColor = .secondaryLabel
        newsDescriptionLabel.numberOfLines = 1
        contentView.addSubview(newsDescriptionLabel)
        newsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        newsDescriptionLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        newsDescriptionLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor).isActive = true
        newsDescriptionLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant:
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

    func configure(with news: ProductViewMode) {
        newsTitleLabel.text = news.title + "\n"
        newsDescriptionLabel.text = news.description.replacingOccurrences(of: "\n", with: " ")
        priceLabel.text = "$" + news.price
        if let url = news.imageURL {
            setImage(from: url, news: news)
        }
    }

    func setImage(from url: URL, news: ProductViewMode) {
        print(url)
        if let data = news.imageData {
            DispatchQueue.main.async {
                self.newsImageView.image = UIImage(data: data)
            }
        } else {
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: url) else {
                    return
                }
                news.imageData = imageData
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.newsImageView.image = image
                }
            }
        }

    }

    override func prepareForReuse() {
        newsImageView.image = nil
        newsTitleLabel.text = nil
        newsDescriptionLabel.text = nil
        priceLabel.text = nil
    }
}
