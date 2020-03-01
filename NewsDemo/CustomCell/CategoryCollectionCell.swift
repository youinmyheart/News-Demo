// 
// CategoryCollectionCell.swift
// 
// Created on 3/1/20.
// 

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var m_mainImageView: UIImageView!
    @IBOutlet weak var m_darkImageView: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var m_lineImageView: UIImageView!
    
    public func configure(with model: Category) {
        m_mainImageView.image = model.image
        lblCategory.text = model.text
        m_darkImageView.isHidden = !model.isSelected
        m_lineImageView.isHidden = !model.isSelected
        m_lineImageView.layer.cornerRadius = 2
        m_lineImageView.clipsToBounds = true
    }
}
