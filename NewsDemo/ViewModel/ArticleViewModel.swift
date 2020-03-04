// ArticleViewModel.swift
// Created on 3/4/20. 

import UIKit

class ArticleViewModel: NSObject {

    private var article: Article
    
    var image: UIImage? {
        get {
            return article.image
        }
        set {
            article.image = newValue
        }
    }
    
    var placeholderImage: UIImage? {
        return UIImage(named: "placeholder")
    }
    
    var cornerRadius: CGFloat {
        return 5
    }
    
    var title: String? {
        return article.title
    }
    
    var publishedDate: String? {
        return AppUtils.getDateString(from: article.publishedAt)
    }
    
    var sourceName: String? {
        return article.sourceName
    }
    
    var sourceId: String? {
        return article.sourceId
    }
    
    var articleDescription: String? {
        return article.description
    }
    
    var content: String? {
        return article.content
    }
    
    var author: String? {
        return article.author
    }
    
    var link: NSAttributedString? {
        if var url = article.url {
            let prefix = "Link:"
            url = "\(prefix) \(url)"
            let attrString = AppUtils.attributedString(mainStr: url, stringToColor: prefix, color: .black)
            return attrString
        }
        return nil
    }
    
    var urlToImage: String? {
        return article.urlToImage
    }
    
    var isDownloading: Bool? {
        get {
            return article.isDownloading
        }
        set {
            article.isDownloading = newValue
        }
    }
    
    init(article: Article) {
        self.article = article
    }
    
    override init() {
        self.article = Article()
    }
}
