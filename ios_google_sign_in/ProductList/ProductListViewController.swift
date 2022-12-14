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
    func displayData(_ viewModel: [ProductViewModel])
    func displayError(_ errorMessage: String)
}

class ProductListViewController: UIViewController {

    // MARK: - Internal vars
    private var interactor: ProductListBusinessLogic
    private var tableView: UICollectionView =
            UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let searchBar = UISearchBar()
    private let refreshControl = UIRefreshControl()
    private var isLoading = false
    private var productsViewModels = [ProductViewModel]()
    private var filteredItems = [ProductViewModel]()
    private var settingsButton = UIButton()
    private var signOutButton = UIButton()
    private var helloMessage = UILabel()
    private var helloMessageUser = UILabel()
    private var errorButton = UIButton()

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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateData()
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .systemBackground
        configureTableView()
        setUpSearch()
        setUpButton()
        setUpGreetings()
        setUpErrorHandling()
    }

    private func setUpButton() {
        let fileManager = FileManager.default
        // Settings button
        settingsButton.setImage(fileManager.getImageInBundle(bundlePath: "Filter.png"), for: .normal)
        view.addSubview(settingsButton)
        settingsButton.contentHorizontalAlignment = .fill
        settingsButton.contentVerticalAlignment = .fill
        settingsButton.imageView?.contentMode = .scaleAspectFit
        settingsButton.pinBottom(to: searchBar.bottomAnchor)
        settingsButton.pinLeft(to: searchBar.trailingAnchor, 4)
        settingsButton.pinTop(to: searchBar.topAnchor)
        settingsButton.pinRight(to: view, 8)
        settingsButton.addTarget(self, action: #selector(goToSetting), for: .touchUpInside)
        // Sign-out button
        signOutButton.setImage(fileManager.getImageInBundle(bundlePath: "logout.png"), for: .normal)
        view.addSubview(signOutButton)
        signOutButton.contentHorizontalAlignment = .fill
        signOutButton.contentVerticalAlignment = .fill
        signOutButton.imageView?.contentMode = .scaleAspectFit
        signOutButton.pinLeft(to: searchBar.trailingAnchor, 4)
        signOutButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 5)
        signOutButton.pinRight(to: view, 8)
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
    }

    private func setUpGreetings() {
        helloMessage.text = "Привет  👋"
        view.addSubview(helloMessage)
        helloMessage.font = UIFont.systemFont(ofSize: 18.00)
        helloMessage.numberOfLines = 1
        helloMessage.pinLeft(to: view, 12)
        helloMessage.pinTop(to: signOutButton)
        helloMessageUser.text = GIDSignIn.sharedInstance.currentUser?.profile?.name ?? "User"
        view.addSubview(helloMessageUser)
        helloMessageUser.font = UIFont.boldSystemFont(ofSize: 18.00)
        helloMessageUser.numberOfLines = 1
        helloMessageUser.pinLeft(to: view, 12)
        helloMessageUser.pinTop(to: helloMessage.bottomAnchor, 1)
    }

    private func setUpSearch() {
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.pinBottom(to: tableView.topAnchor, 10)
        searchBar.pinLeft(to: view, 8)
        searchBar.pinRight(to: view, 67)
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.borderStyle = .none
        searchBar.layer.borderWidth = 1.0
        searchBar.layer.cornerRadius = 8
        searchBar.layer.borderColor = UIColor.lightGray.cgColor
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
        errorButton.addTarget(self, action: #selector(updateData), for: .touchUpInside)
        errorButton.titleLabel?.numberOfLines = 0
        errorButton.titleLabel?.lineBreakMode = .byWordWrapping
    }

    @objc
    func dismiss(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    // MARK: - CollectionView configure

    private func configureTableView() {
        setTableViewUpdates()
        setTableViewUI()
        setTableViewDelegate()
        setTableViewCell()
    }

    private func setTableViewUpdates() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        tableView.addSubview(refreshControl)
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
        interactor.fetchData(Model.GetData.Request())
    }

    // MARK: - Button action

    @objc
    private func goToSetting() {
        let viewController = SettingsAssembly.build()
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func updateData() {
        refreshControl.endRefreshing()
        errorButton.isHidden = true
        loadDataFromSheets()
    }

    @objc
    private func signOut() {
        GIDSignIn.sharedInstance.signOut()
        UserDefaults.standard.setValue("", forKey: SettingKeys.sheetsID)
        UserDefaults.standard.setValue("", forKey: SettingKeys.pageNumber)
        self.navigationController?.setViewControllers([LogInViewController()], animated: true)
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
        if let productCell = tableView.dequeueReusableCell(withReuseIdentifier: ProductListCell.reuseIdentifier,
                for: indexPath)
                as? ProductListCell {
            productCell.configure(with: viewModel)
            return productCell
        }

        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isLoading {
            let productInfoVC = ProductInfoViewController()
            productInfoVC.setData(viewModel: filteredItems[indexPath.row])
            navigationController?.pushViewController(productInfoVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionViewLayout.collectionView?.frame.width ?? 200) - 10) / 2
        let height = ((collectionViewLayout.collectionView?.frame.height ?? 400) - 20) / 1.9
        return CGSize(width: width, height: height)
    }
}

// MARK: - UISearchBarDelegate

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
    func displayData(_ viewModel: [ProductViewModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.isHidden = false
            if let view = self?.errorButton {
                UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    view.isHidden = true
                })
            }
        }
        productsViewModels = viewModel
        filteredItems = productsViewModels
        reloadData()
    }

    func displayError(_ errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.isHidden = true
            if let view = self?.errorButton {
                UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    view.isHidden = false
                })
                view.setTitle("\(errorMessage)\nНажмите, чтоб обновить", for: .normal)
                view.titleLabel?.textAlignment = .center
                view.sizeToFit()
            }
        }
        print("error")
    }
}
