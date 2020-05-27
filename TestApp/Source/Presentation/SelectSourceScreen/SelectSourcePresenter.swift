//
//  SelectSourcePresenter.swift
//  TestApp
//
//  Created by Nikolay Churyanin on 2905.2020.
//  Copyright © 2020 Nikolay Churyanin. All rights reserved.
//

import Foundation

final class SelectSourcePresenter {

    let defaultUrlString = "https://www.banki.ru/xml/news.rss"

    var selectUrl: ((String) -> Void)?

    var urlsString: [String] {
        [defaultUrlString] + savedUrlStrings
    }

    private lazy var savedUrlStrings = loadSavedUrls()

    func saveNewUrl(string: String) {
        if urlsString.contains(string) { return }

        savedUrlStrings += [string]

        UserDefaults.standard.setValue(
            savedUrlStrings,
            forKey: SelectSourcePresenter.savedUrlsKey
        )
    }

    private func loadSavedUrls() -> [String] {
        let array = UserDefaults.standard.value(
            forKey: SelectSourcePresenter.savedUrlsKey
        ) as? [String]

        return array ?? []
    }
}

private extension SelectSourcePresenter {

    static let savedUrlsKey = "saved.urls.string.key"
}
