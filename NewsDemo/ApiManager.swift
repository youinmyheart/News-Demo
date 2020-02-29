// 
// ApiManager.swift
// 
// Created on 2/29/20.
// 

import UIKit
import AFNetworking
import SwiftyJSON

class ApiManager: NSObject {
    
    static func getTopHeadlinesInUS(onSuccess: ((URLSessionDataTask, [Article]) -> Void)?, onError: ((URLSessionDataTask?, Error, String) -> Void)?) {
        AppUtils.log("getTopHeadlinesInUS")
        // Top headlines from US
        getTopHeadlines(country: Constants.COUNTRY_US, onSuccess: onSuccess, onError: onError)
    }
    
    static func getTopHeadlinesBBCNews(onSuccess: ((URLSessionDataTask, [Article]) -> Void)?, onError: ((URLSessionDataTask?, Error, String) -> Void)?) {
        AppUtils.log("getTopHeadlinesBBCNews")
        // Top headlines from BBC News
        getTopHeadlines(source: Constants.SOURCE_BBC_NEWS, onSuccess: onSuccess, onError: onError)
    }
    
    static func getAllArticles(keyword: String, onSuccess: ((URLSessionDataTask, [Article]) -> Void)?, onError: ((URLSessionDataTask?, Error, String) -> Void)?) {
        AppUtils.log("getAllArticles")
        // All articles about Bitcoin from the last month, sorted by recent first
        // with free use, we can only get data from last month to current date
        let prevMonth = AppUtils.getPreviousMonth()
        getAllArticles(keyword: keyword, dateFrom: prevMonth, sortBy: "publishedAt", onSuccess: onSuccess, onError: onError)
    }
    
    static func getTopHeadlines(country: String, onSuccess: ((URLSessionDataTask, [Article]) -> Void)?, onError: ((URLSessionDataTask?, Error, String) -> Void)?) {
        let urlTopHeadlines = "v2/top-headlines"
        let params = ["apiKey": Constants.API_KEY,
                      "country": country]
        requestGet(urlString: urlTopHeadlines, params: params, onSuccess: onSuccess, onError: onError)
    }
    
    static func getTopHeadlines(source: String, onSuccess: ((URLSessionDataTask, [Article]) -> Void)?, onError: ((URLSessionDataTask?, Error, String) -> Void)?) {
        let urlTopHeadlines = "v2/top-headlines"
        let params = ["apiKey": Constants.API_KEY,
                      "sources": source]
        requestGet(urlString: urlTopHeadlines, params: params, onSuccess: onSuccess, onError: onError)
    }
    
    static func getAllArticles(keyword: String, dateFrom: String, sortBy: String, onSuccess: ((URLSessionDataTask, [Article]) -> Void)?, onError: ((URLSessionDataTask?, Error, String) -> Void)?) {
        let urlEverything = "v2/everything"
        let params = ["apiKey": Constants.API_KEY,
                      "q": keyword,
                      "from": dateFrom,
                      "sortBy": sortBy]
        requestGet(urlString: urlEverything, params: params, onSuccess: onSuccess, onError: onError)
    }
    
    static func requestGet(urlString: String, params: Dictionary<String, Any>?, onSuccess: ((URLSessionDataTask, [Article]) -> Void)?, onError: ((URLSessionDataTask?, Error, String) -> Void)?) {
        let manager = AFHTTPSessionManager(baseURL: URL(string: Constants.SERVER_BASE_URL))
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        manager.get(urlString, parameters: params, progress: { (progress) in
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
                
                let arr = json["articles"].arrayValue.map { Article(json: $0) }
                if let onSuccess = onSuccess {
                    onSuccess(task, arr)
                }
            } else {
                if let onSuccess = onSuccess {
                    onSuccess(task, [Article]())
                }
            }
        }) { (task, error) in
            //AppUtils.log("error:", error)
            //AppUtils.log("error:", error.localizedDescription)
            var errorStr = ""
            let errData = error._userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey]
            if let errData = errData as? Data {
                if let errResponse = String(data: errData, encoding: String.Encoding.utf8) {
                    errorStr = errResponse
                }
            }
            
            if let onError = onError {
                onError(task, error, errorStr)
            }
        }
    }
}
