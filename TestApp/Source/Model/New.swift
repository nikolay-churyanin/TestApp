//
//  New.swift
//  TestApp
//
//  Created by Nikolay Churyanin on 2905.2020.
//  Copyright © 2020 Nikolay Churyanin. All rights reserved.
//

import Foundation

struct Rss {
    let channels: [Channel]

    struct Channel {
        let title: String
        let items: [Item]

        struct Item {
            let title: String
            let description: String
            let date: Date

            var readed = false
        }
    }
}

extension Rss: Decodable {

    enum CodingKeys: String, CodingKey {
        case channel
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        channels = try container.decode([Channel].self, forKey: .channel)
    }
}

extension Rss.Channel: Decodable {

    enum CodingKeys: String, CodingKey {
        case title
        case item
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decode(String.self, forKey: .title)
        items = try container.decode([Item].self, forKey: .item)
    }
}

extension Rss.Channel.Item: Decodable {

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case pubDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateStr = try container.decode(String.self, forKey: .pubDate)
        guard let pubDate = DateFormatter.fullDateFormatter.date(from: dateStr) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: [CodingKeys.pubDate],
                debugDescription: "Invalid date")
            )
        }

        title = try container.decode(String.self, forKey: .title)
        description = (try? container.decode(String.self, forKey: .description)) ?? ""
        date = pubDate
    }
}

extension Rss.Channel.Item: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(date)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title && lhs.description == rhs.description && lhs.date == rhs.date
    }
}
