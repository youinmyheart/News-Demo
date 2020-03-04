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
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var containerSignIn: UIView!
    @IBOutlet weak var containerCreateAccount: UIView!
    
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var lblPasswordError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        setUpUI()
        handleUserAlreadySignedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.delegate = self
        registerKeyboardNoti()
        view.endEditing(true)
        
        txtEmail.text = ""
        txtPassword.text = ""
    }
    
    @IBAction func tapBtnSignIn(_ sender: Any) {
        AppUtils.log("tapBtnSignIn")
        handleSigningIn()
    }
    
    @IBAction func tapBtnCreateAccount(_ sender: Any) {
        AppUtils.log("tapBtnCreateAccount")
        goToRegistrationVC()
    }
    
    func setUpUI() {
        navigationItem.title = "Profile"
        containerSignIn.layer.cornerRadius = 5
        containerCreateAccount.layer.cornerRadius = 5
        btnSignIn.layer.cornerRadius = 5
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // prevents the scroll view from swallowing up the touch event of child buttons
        //tapGesture.cancelsTouchesInView = false
        m_scrollView.addGestureRecognizer(tapGesture)
        
        hideAllErrorTexts()
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtEmail.returnKeyType = .next
        txtPassword.returnKeyType = .done
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
    
    func handleSigningIn() {
        guard let email = validateEmail() else {
            return
        }
        
        guard let pass = validatePassword() else {
            return
        }
        
        if let savedDic = UserDefaults.standard.dictionary(forKey: "userInfo") {
            AppUtils.log("savedDic:", savedDic)
            if let account = savedDic[email] as? Dictionary<String, Any> {
                let password = account["password"] as? String
                if pass == password {
                    let name = account["name"] as? String
                    let userInfo = UserInfo(name: name, image: nil, email: email)
                    saveUserSignedIn(userInfo: userInfo)
                    goToUserProfileVC(userInfo: userInfo, animated: true)
                } else {
                    AppUtils.showAlert(title: "Error", message: "Incorrect username or password", buttonStr: "OK", viewController: self) { (action) in
                        
                    }
                }
            } else {
                // account does not exist
                AppUtils.showAlert(title: "Error", message: "Incorrect username or password", buttonStr: "OK", viewController: self) { (action) in
                    
                }
            }
        } else {
            // user never register account, no data was saved.
            AppUtils.showAlert(title: "Error", message: "Incorrect username or password", buttonStr: "OK", viewController: self) { (action) in
                
            }
        }
    }
    
    func handleUserAlreadySignedIn() {
        if let dic = UserDefaults.standard.dictionary(forKey: "currentUser") {
            let name = dic["name"] as? String
            let email = dic["email"] as? String
            let image = dic["image"] as? UIImage
            let userInfo = UserInfo(name: name, image: image, email: email)
            goToUserProfileVC(userInfo: userInfo, animated: false)
        }
    }
    
    func saveUserSignedIn(userInfo: UserInfo) {
        let dicInfo = ["email": userInfo.email ?? "", "name": userInfo.name ?? ""] as [String : Any]
        UserDefaults.standard.set(dicInfo, forKey: "currentUser")
    }
    
    func hideAllErrorTexts() {
        lblEmailError.isHidden = true
        lblPasswordError.isHidden = true
    }
    
    func validateEmail() -> String? {
        guard let email = txtEmail.text, AppUtils.isValidEmail(email) else {
            lblEmailError.isHidden = false
            lblEmailError.text = "Email is not valid"
            return nil
        }
        lblEmailError.isHidden = true
        return email
    }
    
    func validatePassword() -> String? {
        guard let pass = txtPassword.text, !AppUtils.isEmptyString(pass) else {
            lblPasswordError.isHidden = false
            lblPasswordError.text = "Password is not valid"
            return nil
        }
        lblPasswordError.isHidden = true
        return pass
    }
    
    func goToRegistrationVC() {
        print("goToRegistrationVC")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func goToUserProfileVC(userInfo: UserInfo, animated: Bool) {
        print("goToUserProfileVC")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        controller.m_userInfo = userInfo
        self.navigationController?.pushViewController(controller, animated: animated)
    }
}

extension ProfileVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            AppUtils.log("didSelect tab Profile")
        }
    }
}

extension ProfileVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        AppUtils.log("textFieldDidEndEditing")
        if textField == txtEmail && !AppUtils.isEmptyString(txtEmail.text) {
            _ = validateEmail()
        } else if textField == txtPassword && !AppUtils.isEmptyString(txtPassword.text) {
            _ = validatePassword()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            textField.resignFirstResponder()
            txtPassword.becomeFirstResponder()
        } else if textField == txtPassword {
            textField.resignFirstResponder()
            handleSigningIn()
        }
        return true
    }
}

