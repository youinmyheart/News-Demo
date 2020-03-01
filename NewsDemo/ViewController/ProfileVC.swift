// 
// ViewController.swift
// 
// Created on 2/28/20.
// 

import UIKit
import AFNetworking
import SwiftyJSON

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.delegate = self
    }
    
    func setUpUI() {
        navigationItem.title = "Profile"
    }
}

extension ProfileVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            AppUtils.log("didSelect tab Profile")
        }
    }
}

