//
//  MainPresenter.swift
//  TestApp
//
//  Created by Nikolay Churyanin on 2905.2020.
//  Copyright © 2020 Nikolay Churyanin. All rights reserved.
//

import Foundation

final class MainPresenter {

    private let newsService: NewsService.Type

    private(set) var news = [Rss.Channel.Item]()

    init(newsService: NewsService.Type) {
        self.newsService = newsService
    }
}

extension MainPresenter {

    func loadNews(
        source: String,
        completion: @escaping () -> Void,
        onError: @escaping (String) -> Void
    ) {
        guard let url = URL(string: source) else {
            onError("Invalid url")
            return
        }

        newsService.loadNews(
            url: url,
            completion: { [weak self] news in
                guard let self = self else { return }

                let newsChanging = { () -> [Rss.Channel.Item] in
                    let newNews = Set(news.flatMap { $0.items })

                    let oldNews = Set(self.news)

                    let intersect = oldNews.intersection(newNews)
                    let substruct = newNews.subtracting(oldNews)

                    return (Array(intersect) + Array(substruct))
                }

                self.news = newsChanging().sorted(by: { $0.date > $1.date })

                completion()
            },
            onError: { [weak self] error in
                self?.news = []
                onError(error.localizedDescription)
            }
        )
    }

    func setReaded(index: Int) {
        news[index].readed = true
    }
}
