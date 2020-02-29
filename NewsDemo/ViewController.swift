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
        
    }

    @IBAction func tapOnBtn(_ sender: Any) {
        AppUtils.log("tapOnBtn")
//        ApiManager.getTopHeadlinesInUS(onSuccess: { (task, articles) in
//            if let article = articles.first {
//                AppUtils.log("article:", article)
//            }
//        }) { (task, error, errStr) in
//            if AppUtils.isEmptyString(errStr) {
//                AppUtils.log("error:", error.localizedDescription)
//            } else {
//                AppUtils.log("error:", errStr)
//            }
//        }
        
//        ApiManager.getTopHeadlinesBBCNews(onSuccess: { (task, articles) in
//            if let article = articles.first {
//                AppUtils.log("article:", article)
//            }
//        }) { (task, error, errStr) in
//            if AppUtils.isEmptyString(errStr) {
//                AppUtils.log("error:", error.localizedDescription)
//            } else {
//                AppUtils.log("error:", errStr)
//            }
//        }
        
        ApiManager.getAllArticles(keyword: "apple", onSuccess: { (task, articles) in
            if let article = articles.first {
                AppUtils.log("article:", article)
            }
        }) { (task, error, errStr) in
            if AppUtils.isEmptyString(errStr) {
                AppUtils.log("error:", error.localizedDescription)
            } else {
                AppUtils.log("error:", errStr)
            }
        }
    }
}

