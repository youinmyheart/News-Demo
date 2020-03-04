// 
// CategoryVC.swift
// 
// Created on 2/29/20.
// 

import UIKit

class CategoryVC: UIViewController {

    let categoryCellId = "CategoryCollectionCell"
    
    var m_arrCategoryViewModels = [CategoryViewModel]()
    var m_selectedIndex = 0 // selected category index in array of categories
    var m_previousSelectedIndex = -1 // previous selected category index
    
    var m_arrData = [ArticleViewModel]() // array of news
    var m_arrFakeData = [ArticleViewModel]() // array of fake loading data
    
    @IBOutlet weak var m_collectionView: UICollectionView!
    @IBOutlet weak var m_tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        setUpUI()
        m_arrFakeData = createFakeLoadingData()
        createDataCategory()
        updateSelectedCategory()
        getNews(with: m_selectedIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtils.log("viewWillAppear")
        navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.delegate = self
    }
    
    func setUpUI() {
        navigationItem.title = "Custom News"
        m_tableView.register(UINib(nibName: "NewsTableCell", bundle: nil), forCellReuseIdentifier: Constants.newsTableCellId)
    }
    
    func createArrayArticleViewModel(articles: [Article]) -> [ArticleViewModel] {
        var models = [ArticleViewModel]()
        for article in articles {
            models.append(ArticleViewModel(article: article))
        }
        return models
    }
    
    func createDataCategory() {
        let bitcoinImage = UIImage(named: "bitcoin")
        let appleImage = UIImage(named: "apple")
        let earthquakeImage = UIImage(named: "earthquake")
        let animalImage = UIImage(named: "animal")
        let bitcoin = Category(image: bitcoinImage, text: "Bitcoin", isSelected: false)
        let apple = Category(image: appleImage, text: "Apple", isSelected: false)
        let earthquake = Category(image: earthquakeImage, text: "Earthquake", isSelected: false)
        let animal = Category(image: animalImage, text: "Animal", isSelected: false)
        
        m_arrCategoryViewModels.removeAll()
        m_arrCategoryViewModels.append(CategoryViewModel(category: bitcoin))
        m_arrCategoryViewModels.append(CategoryViewModel(category: apple))
        m_arrCategoryViewModels.append(CategoryViewModel(category: earthquake))
        m_arrCategoryViewModels.append(CategoryViewModel(category: animal))
    }
    
    func updateSelectedCategory() {
        if m_selectedIndex == m_previousSelectedIndex {
            return
        }
        
        var indexPaths = [IndexPath]()
        if m_selectedIndex >= 0 && m_selectedIndex < m_arrCategoryViewModels.count {
            AppUtils.log("update m_selectedIndex:", m_selectedIndex)
            m_arrCategoryViewModels[m_selectedIndex].isSelected = true
            indexPaths.append(IndexPath(row: m_selectedIndex, section: 0))
        }
        
        if m_previousSelectedIndex >= 0 && m_previousSelectedIndex < m_arrCategoryViewModels.count {
            AppUtils.log("update m_previousSelectedIndex:", m_previousSelectedIndex)
            m_arrCategoryViewModels[m_previousSelectedIndex].isSelected = false
            indexPaths.append(IndexPath(row: m_previousSelectedIndex, section: 0))
        }
        m_collectionView.reloadItems(at: indexPaths)
        m_collectionView.scrollToItem(at: IndexPath(row: m_selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func getNews(with selectedCategoryIndex: Int) {
        if m_selectedIndex == m_previousSelectedIndex {
            return
        }
        
        if selectedCategoryIndex < 0 || selectedCategoryIndex >= m_arrCategoryViewModels.count {
            return
        }
        
        guard let keyword = m_arrCategoryViewModels[selectedCategoryIndex].text else { return }
                
        AppUtils.log("getNews with keyword:", keyword)
        // create fake loading data while user waits for getting top headlines
        m_arrData.removeAll()
        m_arrData = m_arrFakeData
        m_tableView.isUserInteractionEnabled = false
        m_tableView.reloadData()
        ApiManager.getAllArticles(keyword: keyword, onSuccess: { (task, articles) in
            self.m_arrData = self.createArrayArticleViewModel(articles: articles)
            self.m_tableView.reloadData()
            self.m_tableView.isUserInteractionEnabled = true
            
            // scroll to top of table view
            if self.m_tableView.numberOfRows(inSection: 0) > 0 {
                AppUtils.log("scroll to top")
                self.m_tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
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
    
    func createFakeLoadingData() -> [ArticleViewModel] {
        var arr = [ArticleViewModel]()
        for _ in 0..<9 {
            let model = ArticleViewModel(article: Article())
            arr.append(model)
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
            
            // here app can crash because Out of index when user switches between categories fast
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
    
    func goToNewsDetailVC(index: Int) {
        print("goToNewsDetailVC")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NewsDetailVC") as! NewsDetailVC
        controller.m_articleViewModel = m_arrData[index]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        AppUtils.log("sizeForItemAt", indexPath.row)
        let width = collectionView.bounds.width
        var height = collectionView.bounds.height
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let heightToSubstract = layout.sectionInset.top + layout.sectionInset.bottom
            height -= heightToSubstract
        }
        AppUtils.log("width: \(width), height: \(height)")
        return CGSize(width: 130, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        m_arrCategoryViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as! CategoryCollectionCell
        cell.configure(with: m_arrCategoryViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        m_previousSelectedIndex = m_selectedIndex
        m_selectedIndex = indexPath.row
        updateSelectedCategory()
        getNews(with: m_selectedIndex)
    }
}

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        AppUtils.log("scrollViewDidEndScrollingAnimation");
        downloadImages(indexPaths: m_tableView.indexPathsForVisibleRows)
    }
}

extension CategoryVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            AppUtils.log("didSelect tab Category")
            getNews(with: m_selectedIndex)
        }
    }
}
