// 
// CategoryVC.swift
// 
// Created on 2/29/20.
// 

import UIKit

class CategoryVC: UIViewController {

    let categoryCellId = "CategoryCollectionCell"
    
    var m_arrCategories = [Category]()
    var m_selectedIndex = 0
    var m_previousSelectedIndex = -1
    private var previousOffset: CGFloat = 0
    private var currentPage: Int = 0
    
    @IBOutlet weak var m_collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        setUpUI()
        createDataCategory()
        updateSelectedCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUpUI() {
        navigationItem.title = "Custom News"
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
        
        m_arrCategories.removeAll()
        m_arrCategories.append(bitcoin)
        m_arrCategories.append(apple)
        m_arrCategories.append(earthquake)
        m_arrCategories.append(animal)
    }
    
    func updateSelectedCategory() {
        if m_selectedIndex == m_previousSelectedIndex {
            return
        }
        
        var indexPaths = [IndexPath]()
        if m_selectedIndex >= 0 && m_selectedIndex < m_arrCategories.count {
            AppUtils.log("update m_selectedIndex:", m_selectedIndex)
            m_arrCategories[m_selectedIndex].isSelected = true
            indexPaths.append(IndexPath(row: m_selectedIndex, section: 0))
        }
        
        if m_previousSelectedIndex >= 0 && m_previousSelectedIndex < m_arrCategories.count {
            AppUtils.log("update m_previousSelectedIndex:", m_previousSelectedIndex)
            m_arrCategories[m_previousSelectedIndex].isSelected = false
            indexPaths.append(IndexPath(row: m_previousSelectedIndex, section: 0))
        }
        m_collectionView.reloadItems(at: indexPaths)
        m_collectionView.scrollToItem(at: IndexPath(row: m_selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        m_arrCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as! CategoryCollectionCell
        cell.configure(with: m_arrCategories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        m_previousSelectedIndex = m_selectedIndex
        m_selectedIndex = indexPath.row
        updateSelectedCategory()
    }
}
