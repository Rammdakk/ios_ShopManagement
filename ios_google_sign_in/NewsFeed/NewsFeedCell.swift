//
// Created by Рамиль Зиганшин on 24.10.2022.
//

import UIKit

final class NewsCell: UICollectionViewCell {
    static let reuseIdentifier = "NewsCell"
    private let newsImageView = UIImageView()
    private let newsTitleLabel = UILabel()
    private let newsDescriptionLabel = UILabel()

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
        setupImageView()
        setupTitleLabel()
        setupDescriptionLabel()
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
    }

    private func setupImageView() {
        newsImageView.layer.cornerRadius = 8
        newsImageView.layer.cornerCurve = .continuous
        newsImageView.clipsToBounds = true
        newsImageView.contentMode = .scaleAspectFit
        newsImageView.backgroundColor = .white
        contentView.addSubview(newsImageView)
        newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:
        5).isActive = true
        newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:
        -5).isActive = true
        newsImageView.pinHeight(to: contentView.widthAnchor)
    }

    private func setupTitleLabel() {
        newsTitleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        newsTitleLabel.textColor = .label
        newsTitleLabel.numberOfLines = 2
        contentView.addSubview(newsTitleLabel)
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.heightAnchor.constraint(equalToConstant:
        newsTitleLabel.font.lineHeight).isActive = true
        newsTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant:
        0).isActive = true
        newsTitleLabel.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant:
        0).isActive = true
        newsTitleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 12).isActive = true
    }

    private func setupDescriptionLabel() {
        newsDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        newsDescriptionLabel.textColor = .secondaryLabel
        newsDescriptionLabel.numberOfLines = 2
        contentView.addSubview(newsDescriptionLabel)
        newsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        newsDescriptionLabel.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant:
        0).isActive = true
        newsDescriptionLabel.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant:
        0).isActive = true
        newsDescriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant:
        4).isActive = true
    }

    func configure(with news: NewsViewModel) {
        newsTitleLabel.text = news.title
        newsDescriptionLabel.text = news.price
        if let url = news.imageURL {
            setImage(from: url, news: news)
        }
    }

    func setImage(from url: URL, news: NewsViewModel) {
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
    }
}
