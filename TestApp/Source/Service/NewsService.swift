//
//  NewsService.swift
//  TestApp
//
//  Created by Nikolay Churyanin on 2905.2020.
//  Copyright © 2020 Nikolay Churyanin. All rights reserved.
//

import Foundation
import XMLParsing

enum NewsService {

    static func loadNews(
        url: URL,
        completion: @escaping (([Rss.Channel]) -> Void),
        onError: @escaping ((Error) -> Void)
    ) {

        URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let error = error {
                onError(error)
                return
            }

            guard let data = data else {
                onError(AppError.notFound)
                return
            }

            do {
                let news = try XMLDecoder().decode(Rss.self, from: data)
                completion(news.channels)
            } catch let error {
                onError(error)
            }
        }.resume()
    }
}
