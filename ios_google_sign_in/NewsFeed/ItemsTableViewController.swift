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
    private var tableView = UITableView(frame: .zero, style: .plain)
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
        isLoading = true
        interactor.fetchNews(Model.GetNews.Request())
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavbar()
        configureTableView()
    }

    private func setupNavbar() {
        navigationItem.title = "News List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(goBack)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "gobackward"),
                style: .plain,
                target: self,
                action: #selector(updateData)
        )
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationItem.leftBarButtonItem?.tintColor = .label
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
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = 120
        tableView.pinLeft(to: view)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinRight(to: view)
        tableView.pinBottom(to: view)
    }

    private func setTableViewCell() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
    }

    private func reloadData() {
        isLoading = false
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    @objc
    private func loadDataFromSheets() {
        let sheetID = "1HvXfgK2VJBIvJEWVHD4jy4ClPLzfh_l-CUDX0AxiEnA"
        let range = "A2:C2"
        guard let accessToken = GIDSignIn.sharedInstance.currentUser?.authentication.accessToken else {
            return
        }
        print(accessToken)
        let header: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        let requestURL = "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/\(range)"
        let req = AF.request(requestURL, method: .get, encoding: JSONEncoding.default, headers: header)
        req.responseJSON { response in print(response.value) }
    }

    // MARK: - Button action

    @objc
    private func updateData() {
        refreshControl.endRefreshing()
        isLoading = true
        interactor.fetchNews(Model.GetNews.Request())
        loadDataFromSheets()
    }

    @objc
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ItemsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 0
        } else {
            return newsViewModels.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
        } else {
            let viewModel = newsViewModels[indexPath.row]
            if let newsCell = tableView.dequeueReusableCell(withIdentifier:
            NewsCell.reuseIdentifier, for: indexPath) as? NewsCell {
                newsCell.configure(with: viewModel)
                return newsCell
            }
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension ItemsTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoading {
            let newsVC = NewsViewController()
            newsVC.setData(vm: newsViewModels[indexPath.row])
            navigationController?.pushViewController(newsVC, animated: true)
        }
    }
}

// MARK: - Display Logic

extension ItemsTableViewController: NewsFeedDisplayLogic {
    func displayData(_ viewModel: [NewsViewModel]) {
        newsViewModels = viewModel
        reloadData()
    }
}
