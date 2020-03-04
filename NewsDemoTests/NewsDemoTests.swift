// 
// NewsDemoTests.swift
// 
// Created on 2/28/20.
// 

import XCTest
@testable import NewsDemo

class NewsDemoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testArticleViewModel() {
        let sourceId = "cbs-news"
        let sourceName = "CBS News"
        let author = "CBS News"
        let title = "Coronavirus updates: Race to increase testing as COVID-19 spreads in U.S. and elsewhere - CBS News"
        let description = "China has reined in the virus, but the dramatic spread in at least 4 other nations, including the U.S., highlights the limited understanding of the disease."
        let url = "https://www.cbsnews.com/live-updates/coronavirus-outbreak-death-toll-us-infections-latest-news-updates-2020-03-04/"
        let urlToImage = "https://cbsnews2.cbsistatic.com/hub/i/r/2020/03/04/72f9a77c-a91f-4776-b0e5-2721bd454d90/thumbnail/1200x630/95e4decd2c7947aa81242c8dde7d078b/coronavirus-test-12040667781.jpg"
        let publishedDate = "2020-03-04T12:35:00Z"
        let content = "The coronavirus that emerged late last year and spread from central China was in almost 80 countries Wednesday morning, with outbreaks growing fast in South Korea, Italy, Iran and the United States. At least nine people have died of the COVID-19 disease"
        let article = Article(sourceName: sourceName, sourceId: sourceId, author: author, title: title, description: description, url: url, urlToImage: urlToImage, publishedAt: publishedDate, content: content, image: nil, isDownloading: false)
        let viewModel = ArticleViewModel(article: article)
        
        XCTAssertEqual(viewModel.sourceId, sourceId)
        XCTAssertEqual(viewModel.sourceName, sourceName)
        XCTAssertEqual(viewModel.author, author)
        XCTAssertEqual(viewModel.title, title)
        XCTAssertEqual(viewModel.articleDescription, description)
        
        let prefix = "Link:"
        let str = "\(prefix) \(url)"
        let attrString = AppUtils.attributedString(mainStr: str, stringToColor: prefix, color: .black)
        XCTAssertEqual(viewModel.link, attrString)
        XCTAssertEqual(viewModel.urlToImage, urlToImage)
        XCTAssertEqual(viewModel.publishedDate, AppUtils.getDateString(from: publishedDate))
        XCTAssertEqual(viewModel.content, content)
        XCTAssertEqual(viewModel.image, nil)
        XCTAssertEqual(viewModel.isDownloading, false)
        XCTAssertEqual(viewModel.cornerRadius, 5)
        XCTAssertEqual(viewModel.placeholderImage, UIImage(named: "placeholder"))
    }
    
    func testCategoryViewModel() {
        let bitcoinImage = UIImage(named: "bitcoin")
        let category = Category(image: bitcoinImage, text: "Bitcoin", isSelected: false)
        let viewModel = CategoryViewModel(category: category)
        
        XCTAssertEqual(bitcoinImage, viewModel.image)
        XCTAssertEqual("Bitcoin", viewModel.text)
        XCTAssertEqual(false, viewModel.isSelected)
        XCTAssertEqual(2, viewModel.cornerRadius)
    }
}
