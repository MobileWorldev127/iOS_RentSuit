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
    var homeObject:HomeProduct?
    var listCategoryProduct :[CategoryProduct]  = [CategoryProduct]()
    var listProducts :[Product]  = [Product]()
    var currentPageProducts : Int = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        getCategoriesProdcutsList()
        getListProducts()
    }
    
    func getListProducts()  {
        HomeProduct.getListProducts(productsUrl: "product-list" ,page: 0) { (homeProduct, err) in
            if homeProduct != nil {
                self.homeObject = homeProduct
                self.listProducts = (homeProduct?.listProducts)!
            }else{
                self.showAlertView(title: nil, message: "server_error".localized)
            }
            self.garmentsCollectionCell .reloadData()

        }
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
        instance.index = 1
        
        return instance
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listProducts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentfier, for: indexPath as IndexPath) as! GarmentsCollectionViewCell
        let product:Product = self.listProducts[indexPath.row]
        cell.productSelected = product
        cell.setupCellWithProduct(product: product)
        cell.removeOrAddWishListBlock = {
            (isSelected) -> Void in
            if isSelected {
                self.removeFromWishlitList(product: product , incell:cell ,index: indexPath.row )
            }else{
                self.addInWishlitList(product: product , incell:cell,index: indexPath.row )
            }
        }
        return cell
    }
    func removeFromWishlitList(product:Product ,incell:GarmentsCollectionViewCell ,index:Int)  {
        var params : Dictionary<String , AnyObject> = [:]
        params["product_id"] = product.id as AnyObject
        params ["on_wishlist"] = 0 as AnyObject
        
        Product.addOrRemoveProductwishlist(credentials: params as! Dictionary<String, NSObject>) { (removed, err) in
            if (err == nil ){
                if (removed != nil){
                    if (removed! ){
                        incell.favoritetBtn.isSelected = false
                        product.onWishlist = false;
                        self.listProducts[index] = product
                    }else{
                        incell.favoritetBtn.isSelected = true
                    }
                }
            }
            
        }
    }
    func addInWishlitList(product:Product ,incell:GarmentsCollectionViewCell ,index:Int)   {
        var params : Dictionary<String , AnyObject> = [:]
        params["product_id"] = product.id as AnyObject
        params ["on_wishlist"] = 1 as AnyObject
        
        Product.addOrRemoveProductwishlist(credentials: params as! Dictionary<String, NSObject>) { (added, err) in
            if (err == nil ){
                if (added != nil){
                    if (added! ){
                        incell.favoritetBtn.isSelected = true
                        product.onWishlist = true;
                        self.listProducts[index] = product
                    }else{
                        incell.favoritetBtn.isSelected = false
                    }
                }
            }
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellPhotoWidth :CGFloat = (SCREEN_WIDTH - 60) / 2;
        let ratio :CGFloat = 1.4
        let cellPhotoHeight :CGFloat = cellPhotoWidth * ratio  ;
        return CGSize(width: cellPhotoWidth, height: cellPhotoHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product:Product = self.listProducts[indexPath.row]
        if product.id != nil{
            self.goToItemDetails(product.id!)

        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let ymaxOffset:CGFloat = scrollView.contentSize.height - scrollView.frame.height
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y >= ymaxOffset ){
            getMoreProducts()
        }
    }
    func getMoreProducts()  {
        if (homeObject?.hasMorePage(currentpage: currentPageProducts)) == true {
            currentPageProducts = currentPageProducts + 1
            HomeProduct.getListProducts(productsUrl: "product-list",page:currentPageProducts) { (homeProduct, err) in
                if homeProduct != nil {
                    self.homeObject = homeProduct
                    self.listProducts.append(contentsOf: homeProduct!.listProducts!)

                }else{
                    self.currentPageProducts = self.currentPageProducts - 1
                }
                self.garmentsCollectionCell .reloadData()
                
            }
        }

    }
  
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "ListeProducts", bundle: nil)
//        let vc:ListeProductsViewController = storyboard.instantiateViewController(withIdentifier: "liste_products") as! ListeProductsViewController
//        let category = listProducts[indexPath.row]
//        vc.category = category
//        APP_DELEGATE.mainNavigationController!.pushViewController(vc, animated: true)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
