//
//  GarmentsPageViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 11/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class GarmentsPageViewController: BasepageViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   

//    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var garmentsCollectionCell: UICollectionView!
     let cellidentfier  = "garmentsCellId"
     var listCategoryProduct :[CategoryProduct]  = [CategoryProduct]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategoriesProdcutsList()

    }
    
    
   
    func getCategoriesProdcutsList()  {
        CategoryProduct.getListCategoriesProducts { (listCategories, err) in
            if listCategories != nil {
                self.listCategoryProduct = listCategories!
                self.garmentsCollectionCell.reloadData()
            }else{
                self.showAlertView(title: nil, message: "server_error".localized)
            }
        }
    }
    static let sharedInstance: GarmentsPageViewController = {
        let instance: GarmentsPageViewController = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "GarmentsPageViewController") as! GarmentsPageViewController
        instance.index = 2
        
        return instance
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listCategoryProduct.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentfier, for: indexPath as IndexPath) as! GarmentsCollectionViewCell
        cell.setTopStateBtnConstarint(index: indexPath.row)
        cell.setupCellWithcategory(category: listCategoryProduct[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellPhotoWidth :CGFloat = SCREEN_WIDTH ;
        let cellPhotoHeight :CGFloat = 256  ;
        return CGSize(width: cellPhotoWidth, height: cellPhotoHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ListeProducts", bundle: nil)
        let vc:ListeProductsViewController = storyboard.instantiateViewController(withIdentifier: "liste_products") as! ListeProductsViewController
        let category = listCategoryProduct[indexPath.row]
        vc.category = category
        APP_DELEGATE.mainNavigationController!.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
