// 
// NewsTableCell.swift
// 
// Created on 2/29/20.
// 

import UIKit

class NewsTableCell: UITableViewCell {

    @IBOutlet weak var m_image: UIImageView!
    @IBOutlet weak var m_title: UILabel!
    @IBOutlet weak var m_publishedDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with model: ArticleViewModel) {
        if let imageArticle = model.image {
            m_image.image = imageArticle
        } else {
            m_image.image = model.placeholderImage
        }
        m_image.layer.cornerRadius = model.cornerRadius
        m_title.text = model.title
        m_publishedDate.text = model.publishedDate
    }
}
