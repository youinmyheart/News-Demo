// 
// ViewController.swift
// 
// Created on 2/28/20.
// 

import UIKit
import AFNetworking
import SwiftyJSON

class ProfileVC: UIViewController {

    @IBOutlet weak var m_scrollView: UIScrollView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var containerSignIn: UIView!
    @IBOutlet weak var containerCreateAccount: UIView!
    
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
        registerKeyboardNoti()
    }
    
    @IBAction func tapBtnSignIn(_ sender: Any) {
        AppUtils.log("tapBtnSignIn")
    }
    
    @IBAction func tapBtnCreateAccount(_ sender: Any) {
        AppUtils.log("tapBtnCreateAccount")
    }
    
    func setUpUI() {
        navigationItem.title = "Profile"
        containerSignIn.layer.cornerRadius = 5
        containerCreateAccount.layer.cornerRadius = 5
        btnSignIn.layer.cornerRadius = 5
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // prevents the scroll view from swallowing up the touch event of child buttons
        tapGesture.cancelsTouchesInView = false
        m_scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func registerKeyboardNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        guard let userInfo = notification.userInfo else { return }
        
        guard let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return  }
        
        var keyboardFrame: CGRect = value.cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = m_scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        m_scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        m_scrollView.contentInset = contentInset
    }
}

extension ProfileVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            AppUtils.log("didSelect tab Profile")
        }
    }
}

