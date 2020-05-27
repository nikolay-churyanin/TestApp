//
//  SelectSourceViewController.swift
//  TestApp
//
//  Created by Nikolay Churyanin on 2905.2020.
//  Copyright © 2020 Nikolay Churyanin. All rights reserved.
//

import UIKit

final class SelectSourceViewController: UIViewController {

    private let presenter: SelectSourcePresenter

    private let urlTextField = UITextField()
    private let tableView = UITableView()

    init(presenter: SelectSourcePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {

        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        urlTextField.textAlignment = .center
        urlTextField.becomeFirstResponder()
        tableView.tableHeaderView = urlTextField
        urlTextField.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        urlTextField.frame.size.height = 30
        urlTextField.addTarget(self, action: #selector(addNewUrl), for: .editingDidEndOnExit)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: SubtitleTableViewCell.identifier)
        tableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.contentInset.bottom = tableView.safeAreaInsets.bottom
    }
}

extension SelectSourceViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.urlsString.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SubtitleTableViewCell.identifier,
            for: indexPath
        )

        cell.textLabel?.text = presenter.urlsString[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        presenter.selectUrl?(presenter.urlsString[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}

private extension SelectSourceViewController {

    @objc func addNewUrl() {
        guard let text = urlTextField.text else {
            return
        }

        presenter.selectUrl?(text)
        dismiss(animated: true, completion: nil)
    }
}
