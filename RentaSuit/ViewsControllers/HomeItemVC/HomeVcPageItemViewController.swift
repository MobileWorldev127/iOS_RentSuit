//
//  HomeVcPageItemViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 11/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class HomeVcPageItemViewController: BasepageViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let reuseGroupIdentifier = "HomeGroupId"
    let reuseHomeIdentifier = "HomeCellId"
    let reuseHomeHeaderIdentifier = "HomeHeaderCellId"
    var homeObject:HomeProduct?
    var listProducts :[Product]  = [Product]()
    var listGroupsProducts : Array<CategoryProduct>  = [CategoryProduct]()
    var currentPageProducts : Int = 0
    
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategoriesProdcutsList()
    }
    
    
    func getCategoriesProdcutsList()  {
        CategoryProduct.getListCategoriesProducts { (listCategories, err) in
            if listCategories != nil {
                self.listGroupsProducts = listCategories!
                self.getListProducts()
            }else{
                self.getListProducts()
            }
        }
    }
    func getListProducts()  {
        HomeProduct.getListProducts(productsUrl: "product-list" ,page: 0) { (homeProduct, err) in
            if homeProduct != nil {
                self.homeObject = homeProduct
                self.listProducts = (homeProduct?.listProducts)!
            }else{
                self.showAlertView(title: nil, message: "server_error".localized)
            }
            self.homeCollectionView .reloadData()

        }
    }
    
    static let sharedInstance: HomeVcPageItemViewController = {
        let instance: HomeVcPageItemViewController = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "HomeVcPageItemViewController") as! HomeVcPageItemViewController
        instance.index = 0
        return instance
    }()
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: reuseHomeHeaderIdentifier,
                                                                             for: indexPath) as! HomeHeaderViewCollectionReusableView
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return listProducts.count + 1
      return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCellTitleId", for: indexPath as IndexPath) as! HomeCollectionTitleViewCell
            return cell
        default :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseGroupIdentifier, for: indexPath as IndexPath) as! HomeGroupCollectionViewCell
                cell.setupCellWith(groups: listGroupsProducts)
            return cell
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseHomeIdentifier, for: indexPath as IndexPath) as! HomeCollectionViewCell
//
//            let product:Product = self.listProducts[indexPath.row - 1]
//            cell.productSelected = product
//            cell.setupCellWithProduct(product: product)
//            cell.removeOrAddWishListBlock = {
//                (isSelected) -> Void in
//                if isSelected {
//                    self.removeFromWishlitList(product: product , incell:cell ,index: indexPath.row - 1 )
//                }else{
//                    self.addInWishlitList(product: product , incell:cell,index: indexPath.row - 1 )
//                }
//            }
//
//            return cell
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0{
            let product:Product = self.listProducts[indexPath.row - 1]
            if product.id != nil{
                self.goToItemDetails(product.id!)

            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellPhotoWidth :CGFloat = (SCREEN_WIDTH - 60) / 2;
        let ratio :CGFloat = 1.4
        let cellPhotoHeight :CGFloat = cellPhotoWidth * ratio  ;
        switch indexPath.row {
        case  0 :
           return CGSize(width: (SCREEN_WIDTH - 60), height: 60)
        default:
           
            return CGSize(width: SCREEN_WIDTH, height: cellPhotoHeight)
        }
      
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: self.homeCollectionView.bounds.width, height: 275)
    }
    
    
    
    
    func removeFromWishlitList(product:Product ,incell:HomeCollectionViewCell ,index:Int)  {
        var params : Dictionary<String , String> = [:]
        params["product_id"] = product.id as! String
        
        Product.removeProductwishlist(credentials: params as! Dictionary<String, String>) { (removed, err) in
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
        
        Product.addProductwishlist(credentials: params as! Dictionary<String, NSObject>) { (added, err) in
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
    
    @IBAction func didTapCreateRent(_ sender: UIButton) {
        self.pushViewControllerOverMain(sbId: "Rent", vcId: "create_rent_screen", animated: true)
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
                self.homeCollectionView .reloadData()
                
            }
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
 */
    @IBAction func didTapSearchRent(_ sender: Any) {
        let customPopup :CustomPopupViewController = CustomPopupViewController.init(nibName: "CustomPopupViewController", bundle: nil)
        customPopup.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(customPopup, animated: false, completion: nil)
    }
}

