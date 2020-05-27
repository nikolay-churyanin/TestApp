//
//  DetailNewPresenter.swift
//  TestApp
//
//  Created by Nikolay Churyanin on 2905.2020.
//  Copyright © 2020 Nikolay Churyanin. All rights reserved.
//

import Foundation

final class DetailNewPresenter {

    let htmlDescriptionString: String

    init(new: Rss.Channel.Item) {

        htmlDescriptionString = """
        <header>\
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
        </header>\
        <body>\
        <h1>\(new.title)</h1>\
        <p>\(new.description)</p>\
        <p style = "text-align:right">\(DateFormatter.formatter(dateFormat: "dd MMM yyyy HH:mm").string(from: new.date))</p>
        </body>
        """
    }
}
