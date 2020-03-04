// 
// NewsDetailVC.swift
// 
// Created on 3/1/20.
// 

import UIKit

class NewsDetailVC: UIViewController {

    let headerCellId = "HeaderTableCell"
    let imageCellId = "ImageTableCell"
    let footerCellId = "FooterTableCell"
    
    var m_articleViewModel = ArticleViewModel(article: Article())
    
    @IBOutlet weak var m_tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        downloadImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func downloadImage() {
        // download image if it doesnn't exist
        if m_articleViewModel.image != nil {
            // image was downloaded before
            return
        }
        
        if m_articleViewModel.isDownloading ?? false {
            return
        }
        
        guard let urlToImageArticle = m_articleViewModel.urlToImage else { return }
        
        AppUtils.log("downloading image")
        let indexPath = IndexPath(row: 1, section: 0)
        m_articleViewModel.isDownloading = true
        _ = ApiManager.downloadImage(urlString: urlToImageArticle, onProgress: { (progress) in
            //AppUtils.log("progress:", progress)
        }) { (imageObj, error, errorStr) in
            //AppUtils.log("imageObj:", imageObj)
            self.m_articleViewModel.isDownloading = false
            let tableView = self.m_tableView
            if let error = error {
                AppUtils.log("error:", error.localizedDescription)
                AppUtils.log("errorStr:", errorStr)
            } else {
                if let imageObj = imageObj as? UIImage {
                    self.m_articleViewModel.image = imageObj
                    let cell = tableView?.cellForRow(at: indexPath) as? ImageTableCell
                    cell?.m_imageView.image = imageObj
                    tableView?.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}

extension NewsDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCellId, for: indexPath) as! HeaderTableCell
            cell.configure(with: m_articleViewModel)
            cell.selectionStyle = .none
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCellId, for: indexPath) as! ImageTableCell
            cell.configure(with: m_articleViewModel)
            cell.selectionStyle = .none
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: footerCellId, for: indexPath) as! FooterTableCell
            cell.configure(with: m_articleViewModel)
            cell.selectionStyle = .none
            return cell
        
        default:
            return UITableViewCell()
        }
    }
}
