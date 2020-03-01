// 
// HeaderTableCell.swift
// 
// Created on 3/1/20.
// 

import UIKit

class HeaderTableCell: UITableViewCell {

    @IBOutlet weak var m_title: UILabel!
    @IBOutlet weak var m_sourceName: UILabel!
    @IBOutlet weak var m_publishedAt: UILabel!
    @IBOutlet weak var m_description: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func configure(with model: Article) {
        m_title.text = model.title
        m_sourceName.text = model.sourceName
        m_publishedAt.text = AppUtils.getDateString(from: model.publishedAt)
        m_description.text = model.description
    }
}
