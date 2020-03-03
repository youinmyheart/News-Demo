// RegistrationVC.swift
// Created on 3/3/20. 

import UIKit

class RegistrationVC: UIViewController {

    @IBOutlet weak var m_imageView: UIImageView!
    @IBOutlet weak var m_scrollView: UIScrollView!
    @IBOutlet weak var m_containerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblConfirmPassword: UILabel!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnCreateAccount: UIButton!
    
    @IBOutlet weak var lblNameError: UILabel!
    @IBOutlet weak var lblPasswordError: UILabel!
    @IBOutlet weak var lblConfirmPasswordError: UILabel!
    @IBOutlet weak var lblEmailError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNoti()
    }

    @IBAction func tapBtnCreateAccount(_ sender: Any) {
        AppUtils.log("tapBtnCreateAccount")
        handleCreatingAccount()
    }
    
    func setUpUI() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // prevents the scroll view from swallowing up the touch event of child buttons
        //tapGesture.cancelsTouchesInView = false
        m_scrollView.addGestureRecognizer(tapGesture)
        
        hideAllErrorTexts()
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
    
    func handleCreatingAccount() {
        guard let str = txtUsername.text else {
            lblNameError.isHidden = false
            lblNameError.text = "Name must not be empty"
            return
        }
        
        let nameUser = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if AppUtils.isEmptyString(nameUser) {
            lblNameError.isHidden = false
            lblNameError.text = "Name must not be empty"
            return
        }
        
        lblNameError.isHidden = true
        
        guard let pass = txtPassword.text, pass.count >= 6 else {
            lblPasswordError.isHidden = false
            lblPasswordError.text = "Password must has at least 6 characters"
            return
        }
        lblPasswordError.isHidden = true
        
        guard let passConfirm = txtConfirmPassword.text, passConfirm == pass else {
            lblConfirmPasswordError.isHidden = false
            lblConfirmPasswordError.text = "Must be same as password"
            return
        }
        lblConfirmPasswordError.isHidden = true
        
        guard let email = txtEmail.text, AppUtils.isValidEmail(email) else {
            lblEmailError.isHidden = false
            lblEmailError.text = "Email is not valid"
            return
        }
        lblEmailError.isHidden = true
        
        let savedDic = UserDefaults.standard.dictionary(forKey: "userInfo")
        if let savedDic = savedDic {
            if (savedDic[email] as? Dictionary<String, Any>) != nil {
                // email is already existed
                lblEmailError.isHidden = false
                lblEmailError.text = "Email is not available"
                return
            }
        }
        
        // save to user defaults
        var dicToSave: Dictionary<String, Any>
        let dicInfo = ["password": pass, "name": nameUser]
        if let savedDic = savedDic {
            dicToSave = savedDic
            dicToSave[email] = dicInfo
        } else {
            dicToSave = [email: dicInfo]
        }
        
        AppUtils.log("dicToSave:", dicToSave)
        UserDefaults.standard.set(dicToSave, forKey: "userInfo")
        
        let userInfo = UserInfo(name: nameUser, image: nil, email: email)
        AppUtils.showAlert(title: "Congratulation", message: "Your account is created!", buttonStr: "OK", viewController: self) { (action) in
            self.goToUserProfileVC(userInfo: userInfo)
        }
    }
    
    func hideAllErrorTexts() {
        lblNameError.isHidden = true
        lblPasswordError.isHidden = true
        lblConfirmPasswordError.isHidden = true
        lblEmailError.isHidden = true
    }
    
    func goToUserProfileVC(userInfo: UserInfo) {
        print("goToUserProfileVC")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        controller.m_userInfo = userInfo
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
