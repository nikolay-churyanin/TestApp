//
//  DetailNewViewController.swift
//  TestApp
//
//  Created by Nikolay Churyanin on 2905.2020.
//  Copyright © 2020 Nikolay Churyanin. All rights reserved.
//

import UIKit
import WebKit

final class DetailNewViewController: UIViewController {

    private let presenter: DetailNewPresenter

    //MARK: Subviews

    private let webView = WKWebView()
    private let dateLabel = UILabel()

    init(presenter: DetailNewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
        view.backgroundColor = .white

        webView.loadHTMLString(presenter.htmlDescriptionString, baseURL: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        webView.frame = CGRect(
            x: 10,
            y: view.safeAreaInsets.top + 10,
            width: view.bounds.width - 20,
            height: view.bounds.height - view.safeAreaInsets.top - 10
        )
    }
}
