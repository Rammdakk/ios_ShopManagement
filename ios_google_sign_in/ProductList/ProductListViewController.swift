//
//  ItemsTableViewController.swift
//  riziganshinPW5
//
//  Created by Рамиль Зиганшин on 20.10.2022.
//

import UIKit
import GoogleSignIn

protocol ProductListDisplayLogic: AnyObject {
    typealias Model = ProductListResponceModel
    func displayData(_ viewModel: [ProductViewMode])
}

class ProductListViewController: UIViewController {

    // MARK: - External vars

    // MARK: - Internal vars
    private var interactor: ProductListBusinessLogic
    private var tableView: UICollectionView =
            UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let searchBar = UISearchBar()
    private let refreshControl = UIRefreshControl()
    private var isLoading = false
    private var productsViewModels = [ProductViewMode]()
    private var filteredItems = [ProductViewMode]()

    // MARK: - Lifecycle

    init(interactor: ProductListBusinessLogic) {
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
        updateData()
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .systemBackground
        configureTableView()
        setUpSearch()
    }

    private func setUpSearch() {
        searchBar.delegate = self
        view.addSubview(searchBar)
//        searchController.searchBar.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 10)
        searchBar.pinBottom(to: tableView.topAnchor, 10)
        searchBar.pinLeft(to: view, 8)
        searchBar.pinRight(to: view, 40)
        searchBar.enablesReturnKeyAutomatically = false
    }

    @objc
    func dismiss(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
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
        tableView.pinLeft(to: view, 8)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 140)
        tableView.pinRight(to: view, 8)
        tableView.pinBottom(to: view)
    }

    private func setTableViewCell() {
        tableView.register(ProductListCell.self, forCellWithReuseIdentifier: ProductListCell.reuseIdentifier)
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

extension ProductListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading {
            return 0
        } else {
            return filteredItems.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
            -> UICollectionViewCell {

        let viewModel = productsViewModels[indexPath.row]
        if let newsCell = tableView.dequeueReusableCell(withReuseIdentifier: ProductListCell.reuseIdentifier, for: indexPath)
                as? ProductListCell {
            newsCell.configure(with: viewModel)
            return newsCell
        }

        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isLoading {
            let newsVC = ProductInfoViewController()
            newsVC.setData(viewModel: filteredItems[indexPath.row])
            navigationController?.pushViewController(newsVC, animated: true)
        }
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionViewLayout.collectionView?.frame.width ?? 200) - 10) / 2
        let height = ((collectionViewLayout.collectionView?.frame.height ?? 400) - 20) / 1.9
        return CGSize(width: width, height: height)
    }
}

// MARK: - SearchBarDelegate

extension ProductListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredItems = productsViewModels
        } else {
            filteredItems = productsViewModels.filter({ (data) -> Bool in
                let tmp = data.title
                return tmp.lowercased().contains(searchText.lowercased())
            })
        }
        reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Display Logic

extension ProductListViewController: ProductListDisplayLogic {
    func displayData(_ viewModel: [ProductViewMode]) {
        productsViewModels = viewModel
        filteredItems = productsViewModels
        reloadData()
    }
}
