// UserProfileVC.swift
// Created on 3/3/20. 

import UIKit

class UserProfileVC: UIViewController {

    var m_userInfo = UserInfo()
    
    @IBOutlet weak var m_userImage: UIImageView!
    @IBOutlet weak var lblNameUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        setUpUI()
    }
    
    @IBAction func tapBtnSignOut(_ sender: Any) {
        AppUtils.log("tapBtnSignOut")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setUpUI() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        let radius = m_userImage.frame.width / 2
        m_userImage.layer.cornerRadius = radius
        
        var image = UIImage(named: "animal") // default image
        if m_userInfo.image != nil {
            image = m_userInfo.image
        }
        m_userImage.image = image
        
        lblNameUser.text = m_userInfo.name
    }
}
