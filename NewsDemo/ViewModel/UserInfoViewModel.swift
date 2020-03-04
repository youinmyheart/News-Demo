// UserInfoViewModel.swift
// Created on 3/4/20. 

import UIKit

class UserInfoViewModel: NSObject {

    private var userInfo: UserInfo
    
    var name: String? {
        return userInfo.name
    }
    
    var image: UIImage? {
        return userInfo.image
    }
    
    var email: String? {
        return userInfo.email
    }
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
}
