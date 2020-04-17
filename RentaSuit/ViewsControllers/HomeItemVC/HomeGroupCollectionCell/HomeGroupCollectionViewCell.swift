//
//  HomeGroupCollectionViewCell.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 21/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class HomeGroupCollectionViewCell: UICollectionViewCell ,UICollectionViewDelegate,UICollectionViewDataSource{
   
    let reuseSliderGroupIdentifier  =  "GroupitemID"
    var listGroupsProducts : Array<CategoryProduct>  = [CategoryProduct]()

    @IBOutlet weak var sliderGroupCollectionView: UICollectionView!
    
    
    
    func setupCellWith(groups : Array<CategoryProduct>)  {
        listGroupsProducts = groups
        self.sliderGroupCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listGroupsProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = sliderGroupCollectionView.dequeueReusableCell(withReuseIdentifier: reuseSliderGroupIdentifier, for: indexPath as IndexPath) as! GroupCollectionViewCell
        cell.setupCellWithcategory(category: listGroupsProducts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let ratio :CGFloat = 1.4

        return CGSize(width: SCREEN_WIDTH, height: SCREEN_WIDTH * ratio)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ListeProducts", bundle: nil)
        let vc:ListeProductsViewController = storyboard.instantiateViewController(withIdentifier: "liste_products") as! ListeProductsViewController
        let category = listGroupsProducts[indexPath.row]
        vc.category = category
        APP_DELEGATE.mainNavigationController!.pushViewController(vc, animated: true)
    }
}
