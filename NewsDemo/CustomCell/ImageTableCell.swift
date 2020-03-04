// 
// ImageTableCell.swift
// 
// Created on 3/1/20.
// 

import UIKit

class ImageTableCell: UITableViewCell {

    @IBOutlet weak var m_imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with model: ArticleViewModel) {
        if let image = model.image {
            //AppUtils.log("image:", model.image as Any)
            let widthImage = image.size.width
            let heightImage = image.size.height
            let ratio = widthImage / heightImage
            
            let maxWidthImageView = UIScreen.main.bounds.size.width - 20
            var widthImageView = maxWidthImageView
            if widthImageView > widthImage {
                widthImageView = widthImage
            }
            
            var frame = m_imageView.frame
            frame.size.width = widthImageView
            frame.size.height = widthImageView / ratio
            //AppUtils.log("frame:", frame)
            m_imageView.frame = frame
            m_imageView.contentMode = .scaleAspectFill
        }
        
        m_imageView.image = model.image
    }
}
