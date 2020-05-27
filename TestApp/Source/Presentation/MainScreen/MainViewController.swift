//
//  MainViewController.swift
//  TestApp
//
//  Created by Nikolay Churyanin on 2905.2020.
//  Copyright © 2020 Nikolay Churyanin. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    private let presenter: MainPresenter
    private let selectSourcePresenter: SelectSourcePresenter

    // MARK: Subviews
    private let tableView = UITableView()
    private let urlTextField = UITextField()
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)

    init(presenter: MainPresenter, selectSourcePresenter: SelectSourcePresenter) {
        self.presenter = presenter
        self.selectSourcePresenter = selectSourcePresenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life cycle
    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureNavigationItem()
        configureActivityIndicatorView()

        activityIndicatorView.startAnimating()
        presenter.loadNews(
            source: urlTextField.text ?? "",
            completion: { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.activityIndicatorView.stopAnimating()
                }
            },
            onError: { [weak self] message in
                DispatchQueue.main.async {
                    self?.showAlert(message: message)
                    self?.activityIndicatorView.stopAnimating()
                }
            }
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        activityIndicatorView.center = view.center
    }
}

private extension MainViewController {

    func configureActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.hidesWhenStopped = true
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            SubtitleTableViewCell.self,
            forCellReuseIdentifier: SubtitleTableViewCell.identifier
        )

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(reloadNews), for: .valueChanged)
    }

    func configureNavigationItem() {
        urlTextField.frame = CGRect(
            origin: .zero,
            size: CGSize(width: .max, height: .max)
        )
        urlTextField.textAlignment = .center
        urlTextField.text = selectSourcePresenter.defaultUrlString
        urlTextField.addTarget(self, action: #selector(reloadNews), for: .editingDidEndOnExit)
        urlTextField.addTarget(self, action: #selector(showSelectSourceScreen), for: .editingDidBegin)
        navigationItem.titleView = urlTextField
    }
}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SubtitleTableViewCell.identifier,
            for: indexPath
        )

        let new = presenter.news[indexPath.row]

        cell.textLabel?.text = new.title
        cell.detailTextLabel?.text = new.formattedDate
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = new.readed ? .cyan : .white

        return cell
    }
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.setReaded(index: indexPath.row)
        goToDetailScreen(new: presenter.news[indexPath.row])

        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension MainViewController {

    func goToDetailScreen(new: Rss.Channel.Item) {
        let vc = DetailNewViewController(presenter: .init(new: new))

        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func showSelectSourceScreen() {
        let vc = SelectSourceViewController(presenter: selectSourcePresenter)

        selectSourcePresenter.selectUrl = { [weak self] url in
            DispatchQueue.main.async {
                self?.urlTextField.text = url
                self?.tableView.refreshControl?.beginRefreshing()
                self?.reloadNews()
            }
        }

        present(vc, animated: true, completion: nil)
    }
}

private extension MainViewController {

    @objc func reloadNews() {

        guard let source = urlTextField.text else {
            return
        }

        presenter.loadNews(
            source: source,
            completion: { [weak self] in
                DispatchQueue.main.async {
                    self?.selectSourcePresenter.saveNewUrl(string: source)
                    self?.tableView.reloadData()
                    self?.tableView.refreshControl?.endRefreshing()
                }
            },
            onError: { [weak self] message in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.tableView.refreshControl?.endRefreshing()
                    self?.showAlert(message: message)
                }
            }
        )
    }
}

private extension Rss.Channel.Item {

    var formattedDate: String {
        DateFormatter.formatter(dateFormat: "dd MMM yyyy HH:mm").string(from: date)
    }
}
