//
// Created by Рамиль Зиганшин on 24.10.2022.
//

import UIKit

final class NewsCell: UITableViewCell {
    static let reuseIdentifier = "NewsCell"
    private let newsImageView = UIImageView()
    private let newsTitleLabel = UILabel()
    private let newsDescriptionLabel = UILabel()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
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
    }
    


    private func setupImageView() {
        newsImageView.layer.cornerRadius = 8
        newsImageView.layer.cornerCurve = .continuous
        newsImageView.clipsToBounds = true
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(newsImageView)
        newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        newsImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:
        16).isActive = true
        newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:
        -12).isActive = true
        newsImageView.pinWidth(to: newsImageView.heightAnchor)
    }

    private func setupTitleLabel() {
        newsTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        newsTitleLabel.textColor = .label
        newsTitleLabel.numberOfLines = 1
        contentView.addSubview(newsTitleLabel)
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.heightAnchor.constraint(equalToConstant:
        newsTitleLabel.font.lineHeight).isActive = true
        newsTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant:
        12).isActive = true
        newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        newsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:
        -12).isActive = true
    }

    private func setupDescriptionLabel() {
        newsDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        newsDescriptionLabel.textColor = .secondaryLabel
        newsDescriptionLabel.numberOfLines = 0
        contentView.addSubview(newsDescriptionLabel)
        newsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        newsDescriptionLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor,
                constant: 12).isActive = true
        newsDescriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant:
        12).isActive = true
        newsDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                constant: -16).isActive = true
        newsDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -12).isActive = true
    }

    func configure(with news: NewsViewModel) {
        newsTitleLabel.text = news.title
        newsDescriptionLabel.text = news.checlLink
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
