// 
// HomeVC.swift
// 
// Created on 2/29/20.
// 

import UIKit

class HomeVC: UIViewController {

    var m_arrData = [Article]()
    var m_arrFakeData = [Article]()
    
    @IBOutlet weak var m_tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        m_arrFakeData = createFakeLoadingData()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtils.log("viewWillAppear")
        navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.delegate = self
        
        getTopHeadlines()
    }
    
    func setUpUI() {
        navigationItem.title = "Top Headlines"
        m_tableView.register(UINib(nibName: "NewsTableCell", bundle: nil), forCellReuseIdentifier: Constants.newsTableCellId)
    }
    
    func getTopHeadlines() {
        // create fake loading data while user waits for getting top headlines
        m_arrData.removeAll()
        m_arrData = m_arrFakeData
        m_tableView.isUserInteractionEnabled = false
        m_tableView.reloadData()
        ApiManager.getTopHeadlinesInUS(onSuccess: { (task, articles) in
            self.m_arrData = articles
            self.m_tableView.reloadData()
            self.m_tableView.isUserInteractionEnabled = true
            
            // scroll to top of table view
            if self.m_tableView.numberOfRows(inSection: 0) > 0 {
                self.m_tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
            
            // download image for only visible rows after downloading text
            self.downloadImages(indexPaths: self.m_tableView.indexPathsForVisibleRows)
        }) { (task, error, errStr) in
            if AppUtils.isEmptyString(errStr) {
                AppUtils.log("error:", error.localizedDescription)
            } else {
                AppUtils.log("error:", errStr)
            }
        }
    }
    
    func createFakeLoadingData() -> [Article] {
        var arr = [Article]()
        for _ in 0..<9 {
            let article = Article()
            arr.append(article)
        }
        return arr
    }
    
    func downloadImage(indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        
        let row = indexPath.row
        if row >= m_arrData.count {
            return
        }
        
        if m_arrData[row].image != nil {
            // image was downloaded before
            return
        }
        
        if m_arrData[row].isDownloading ?? false {
            return
        }
        
        guard let urlToImageArticle = m_arrData[row].urlToImage else { return }
        //AppUtils.log("downloading image at row:", row)
        self.m_arrData[row].isDownloading = true
        _ = ApiManager.downloadImage(urlString: urlToImageArticle, onProgress: { (progress) in
            //AppUtils.log("progress:", progress)
        }) { (imageObj, error, errorStr) in
            //AppUtils.log("imageObj:", imageObj)
            
            // ensure index is not out of bound, just to be safe like CategoryVC
            if row < 0 || row >= self.m_arrData.count {
                return
            }
            
            self.m_arrData[row].isDownloading = false
            let tableView = self.m_tableView
            if let error = error {
                AppUtils.log("error:", error.localizedDescription)
                AppUtils.log("errorStr:", errorStr)
            } else {
                if let imageObj = imageObj as? UIImage {
                    AppUtils.log("downloaded image at row:", row)
                    self.m_arrData[row].image = imageObj
                    let cell = tableView?.cellForRow(at: indexPath) as? NewsTableCell
                    cell?.m_image.image = imageObj
                    tableView?.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func downloadImages(indexPaths: [IndexPath]?) {
        guard let indexPaths = indexPaths else { return }
        AppUtils.log("downloadImages");
        for indexPath in indexPaths {
            downloadImage(indexPath: indexPath)
        }
    }
    
    func testDownload() {
        AppUtils.log("testDownload")
        // AFNetworking can't download image with this url
        let urlToImageArticle = "https://akns-images.eonline.com/eol_images/Entire_Site/20191016/rs_600x600-191116190900-600.justin-bieber-hailey-bieber.ct.111619.jpg?fit=around|600:467&crop=600:467;center,top&output-quality=90"
        _ = ApiManager.downloadImage(urlString: urlToImageArticle, onProgress: { (progress) in
            AppUtils.log("progress:", progress)
        }) { (imageObj, error, errorStr) in
            AppUtils.log("imageObj:", imageObj as Any)
            if let error = error {
                AppUtils.log("error:", error.localizedDescription)
                AppUtils.log("errorStr:", errorStr)
            }
        }
    }
    
    func goToNewsDetailVC(index: Int) {
        print("goToNewsDetailVC")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NewsDetailVC") as! NewsDetailVC
        controller.m_article = m_arrData[index]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = m_arrData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsTableCellId, for: indexPath) as! NewsTableCell
        cell.configure(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        goToNewsDetailVC(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
            // visible cells on screen
            //downloadImage(indexPath: indexPath)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            AppUtils.log("scrolling finished");
            downloadImages(indexPaths: m_tableView.indexPathsForVisibleRows)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        AppUtils.log("scrolling finished");
        downloadImages(indexPaths: m_tableView.indexPathsForVisibleRows)
    }
}

extension HomeVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            AppUtils.log("didSelect tab Home")
            getTopHeadlines()
        }
    }
}
