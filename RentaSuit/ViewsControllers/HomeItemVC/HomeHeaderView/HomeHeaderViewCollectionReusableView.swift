//
//  HomeHeaderViewCollectionReusableView.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 14/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class HomeHeaderViewCollectionReusableView: UICollectionReusableView, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIScrollViewDelegate{
    
        
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var sliderpageControl: UIPageControl!
    var highlightsArray = [[String : AnyObject]]()
    var indexScroll = 0

    let reuseSliderIdentifier  =  "ProductSliderId"
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        print(highlightsArray.count)
//        self.sliderpageControl.numberOfPages = highlightsArray.count
//        return highlightsArray.count
        self.sliderpageControl.numberOfPages = 1
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sliderCollectionView.dequeueReusableCell(withReuseIdentifier: reuseSliderIdentifier, for: indexPath as IndexPath) as! ProductSliderCollectionViewCell
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let ip = self.sliderCollectionView.indexPathForItem(at: center) {
            self.sliderpageControl.currentPage = ip.first!
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellPhotoWidth :CGFloat = SCREEN_WIDTH ;
        let cellPhotoHeight :CGFloat = 275  ;
        return CGSize(width: cellPhotoWidth, height: cellPhotoHeight)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        print("begin scroll");
       
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        print("end scroll");
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.sliderCollectionView.frame.width, height: self.sliderCollectionView.frame.height)
    }
    
}
