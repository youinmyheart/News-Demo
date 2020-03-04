// 
// FooterTableCell.swift
// 
// Created on 3/1/20.
// 

import UIKit

class FooterTableCell: UITableViewCell {

    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblArticleLink: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with model: ArticleViewModel) {
        lblContent.text = model.content
        lblAuthor.text = model.author
        lblArticleLink.attributedText = model.link
    }
}
