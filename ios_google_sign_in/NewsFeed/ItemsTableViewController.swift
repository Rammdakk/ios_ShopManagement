//
//  ItemsTableViewController.swift
//  riziganshinPW5
//
//  Created by Рамиль Зиганшин on 20.10.2022.
//

import UIKit
import GoogleSignIn
import Firebase
import Alamofire

protocol NewsFeedDisplayLogic: AnyObject {
    typealias Model = NewsFeedModel
    func displayData(_ viewModel: [NewsViewModel])
}

class ItemsTableViewController: UIViewController {

    // MARK: - External vars

    // MARK: - Internal vars
    private var interactor: NewsFeedBusinessLogic
    private var tableView: UICollectionView =
            UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let refreshControl = UIRefreshControl()
    private var isLoading = false
    private var newsViewModels = [NewsViewModel]()

    // MARK: - Lifecycle

    init(interactor: NewsFeedBusinessLogic) {
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
        if GIDSignIn.sharedInstance.currentUser == nil {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [self] _, _ in
                updateData()
            }
        } else {
            updateData()
        }
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .systemBackground
        configureTableView()
    }

    private func configureTableView() {
        setTableViewUpdates()
        setTableViewUI()
        setTableViewDelegate()
        setTableViewCell()
    }

    private func setTableViewUpdates() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }

    private func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setTableViewUI() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.pinLeft(to: view, 16)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinRight(to: view, 16)
        tableView.pinBottom(to: view)
    }

    private func setTableViewCell() {
        tableView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.reuseIdentifier)
    }

    private func reloadData() {
        isLoading = false
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func loadDataFromSheets() {
        isLoading = true
        interactor.fetchNews(Model.GetNews.Request())
    }

    // MARK: - Button action

    @objc
    private func updateData() {
        refreshControl.endRefreshing()
        loadDataFromSheets()
    }

    @objc
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension ItemsTableViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading {
            return 0
        } else {
            return newsViewModels.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
            -> UICollectionViewCell {

        let viewModel = newsViewModels[indexPath.row]
        if let newsCell = tableView.dequeueReusableCell(withReuseIdentifier: NewsCell.reuseIdentifier, for: indexPath)
                as? NewsCell {
            newsCell.configure(with: viewModel)
            return newsCell
        }

        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension ItemsTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isLoading {
            let newsVC = NewsViewController()
            newsVC.setData(viewModel: newsViewModels[indexPath.row])
            navigationController?.pushViewController(newsVC, animated: true)
        }
    }
}

extension ItemsTableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionViewLayout.collectionView?.frame.width ?? 200) - 10) / 2
        let height = ((collectionViewLayout.collectionView?.frame.height ?? 400) - 20) / 2.3
        return CGSize(width: width, height: height)
    }
}

// MARK: - Display Logic

extension ItemsTableViewController: NewsFeedDisplayLogic {
    func displayData(_ viewModel: [NewsViewModel]) {
        newsViewModels = viewModel
        reloadData()
    }
}
