// CategoryViewModel.swift
// Created on 3/4/20. 

import UIKit

class CategoryViewModel: NSObject {

    private var category: Category
    
    var image: UIImage? {
        return category.image
    }
    
    var text: String? {
        return category.text
    }
    
    var isSelected: Bool {
        get {
            return category.isSelected
        }
        set {
            category.isSelected = newValue
        }
    }
    
    var cornerRadius: CGFloat {
        return 2
    }
    
    init(category: Category) {
        self.category = category
    }
}
