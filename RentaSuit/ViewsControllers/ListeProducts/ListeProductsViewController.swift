//
//  ListeProductsViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 21/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class ListeProductsViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout ,SearchProductDelegate {
  
   
    
    @IBOutlet weak var productsCollectionsView: UICollectionView!
    
    @IBOutlet weak var nameCategoryLabel: UILabel!
    
    let resueCellId = "HomeCellId"
    var listProducts :[Product]  = [Product]()
    var category  :CategoryProduct?
    
    var productsObject:HomeProduct?
    var currentPageProducts : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getListProducts()
        self.nameCategoryLabel.text = category?.name
    }

    @IBAction func filterBtnPressed(_ sender: Any) {
        let vc = getViewControllerInstance(sbId: "HomeStoryboard", vcId: "SearchPageViewController") as! SearchPageViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.category = category
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func filterProducts(homeProduct:HomeProduct) {
        self.productsObject = homeProduct
        self.listProducts = (homeProduct.listProducts)!
        self.productsCollectionsView .reloadData()

    }
    
    func getListProducts()  {
        var params : Dictionary<String, String> = [:]
        params ["category_id"] = (category?.id)! as String
        params ["page"] = "1" as String
        params ["results_per_page"] = "50" as String
      
        Product.filtreProduitWs(credentials:  params as! Dictionary<String, String>) { (listProducts, error) in
            if (listProducts != nil){
                self.productsObject = listProducts
                self.listProducts = (listProducts?.listProducts)!
            }
            else{
                self.showAlertView(title: nil, message: "server_error".localized)
            }
            self.productsCollectionsView .reloadData()
        }
      
      
      
//        let urlProduct = "product-list-filter" + "?category_id=" + (category?.id)!
//        HomeProduct.getListProducts(productsUrl: urlProduct, page: 0) { (homeProduct, err) in
//            if homeProduct != nil {
//                self.productsObject = homeProduct
//                self.listProducts = (homeProduct?.listProducts)!
//            }else{
//                self.showAlertView(title: nil, message: "server_error".localized)
//            }
//            self.productsCollectionsView .reloadData()
//        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return  listProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resueCellId, for: indexPath as IndexPath) as! HomeCollectionViewCell
        
        let product:Product = self.listProducts[indexPath.row]
        cell.productSelected = product
        cell.setupCellWithProduct(product: product)
        cell.removeOrAddWishListBlock = {
            (isSelected) -> Void in
            if isSelected {
                self.removeFromWishlitList(product: product , incell:cell ,index: indexPath.row)
            }else{
                self.addInWishlitList(product: product , incell:cell,index: indexPath.row  )
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellPhotoWidth :CGFloat = (SCREEN_WIDTH - 60) / 2;
        let ratio :CGFloat = 1.4
        let cellPhotoHeight :CGFloat = cellPhotoWidth * ratio  ;
       
        return CGSize(width: cellPhotoWidth, height: cellPhotoHeight)
        
    }
    @IBAction func backBtnPressed(_ sender: Any) {
         APP_DELEGATE.mainNavigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let product:Product = self.listProducts[indexPath.row]
            if product.id != nil{
                self.goToItemDetails(product.id!)
                
            }
        
    }
    func removeFromWishlitList(product:Product ,incell:HomeCollectionViewCell ,index:Int)  {
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
    func addInWishlitList(product:Product ,incell:HomeCollectionViewCell ,index:Int)   {
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let ymaxOffset:CGFloat = scrollView.contentSize.height - scrollView.frame.height
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y >= ymaxOffset ){
            getMoreProducts()
        }
    }
    
    func getMoreProducts()  {
        if (productsObject?.hasMorePage(currentpage: currentPageProducts)) == true {
            currentPageProducts = currentPageProducts + 1
             let urlProduct = "product-list-filter" + "?category_id=" + (category?.id)!
            HomeProduct.getListProducts(productsUrl: urlProduct,page:currentPageProducts) { (homeProduct, err) in
                if homeProduct != nil {
                    self.productsObject = homeProduct
                    self.listProducts.append(contentsOf: homeProduct!.listProducts!)
                    
                }else{
                    self.currentPageProducts = self.currentPageProducts - 1
                }
                self.productsCollectionsView .reloadData()
                
            }
        }
        
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
