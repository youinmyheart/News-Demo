// 
// News.swift
// 
// Created on 2/29/20.
// 

import UIKit
import SwiftyJSON

struct Article {

    var sourceName: String? = ""
    var sourceId: String? = ""
    var author: String? = ""
    var title: String? = ""
    var description: String? = ""
    var url: String? = ""
    var urlToImage: String? = ""
    var publishedAt: String? = ""
    var content: String? = ""
}

extension Article {
    init(json: JSON) {
        sourceName = json["source"]["name"].stringValue
        sourceId = json["source"]["id"].stringValue
        author = json["author"].stringValue
        title = json["title"].stringValue
        description = json["description"].stringValue
        url = json["url"].stringValue
        urlToImage = json["urlToImage"].stringValue
        publishedAt = json["publishedAt"].stringValue
        content = json["content"].stringValue
    }
}
