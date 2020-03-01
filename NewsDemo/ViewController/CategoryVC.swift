// 
// CategoryVC.swift
// 
// Created on 2/29/20.
// 

import UIKit

class CategoryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUpUI() {
        navigationItem.title = "Custom News"
    }
}
