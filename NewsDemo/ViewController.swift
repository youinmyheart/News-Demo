// 
// ViewController.swift
// 
// Created on 2/28/20.
// 

import UIKit
import AFNetworking
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        testAPI()
    }

    func testAPI() {
        let manager = AFHTTPSessionManager(baseURL: URL(string: Constants.SERVER_BASE_URL))
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        let urlTopHeadlines = "v2/top-headlines"
        
        // Top headlines from US
//        let params = ["apiKey": Constants.API_KEY,
//                       "country": "us"]
        
        // Top headlines from BBC News
        let params = ["apiKey": Constants.API_KEY,
                      "sources": "bbc-news"]
        
        manager.get(urlTopHeadlines, parameters: params, progress: { (progress) in
            AppUtils.log("progress:", progress)
        }, success: { (task, response) in
            AppUtils.log("success")
            if let urlResponse = task.response as? HTTPURLResponse {
                AppUtils.log("statusCode:", urlResponse.statusCode)
            }
            if let response = response as? NSDictionary {
                let json = JSON(response)
                AppUtils.log("status:", json["status"])
                AppUtils.log("totalResults:", json["totalResults"])
                let article = json["articles"][0]
                AppUtils.log("articles 0:", article)
                AppUtils.log("source:", article["source"])
                AppUtils.log("name:", article["source"]["name"])
                AppUtils.log("id:", article["source"]["id"])
                AppUtils.log("author:", article["author"])
                AppUtils.log("title:", article["title"])
                AppUtils.log("description:", article["description"])
                AppUtils.log("url:", article["url"])
                AppUtils.log("urlToImage:", article["urlToImage"])
                AppUtils.log("publishedAt:", article["publishedAt"])
                AppUtils.log("content:", article["content"])
            }
            
        }) { (task, error) in
            AppUtils.log("error:", error)
        }
    }
}

