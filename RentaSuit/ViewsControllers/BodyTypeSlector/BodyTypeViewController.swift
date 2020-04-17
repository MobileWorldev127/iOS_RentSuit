//
//  BodyTypeViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 12/12/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

protocol BodyTypePopUpDelegate {
    func didRequestClose()
    func didSelectNewBodyTypeValue(_ value : Int)
}

class BodyTypeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var delegate : BodyTypePopUpDelegate?
    var selectedBodyType : Int = 1
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 40, height: 55)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        self.collectionView.register(UINib(nibName: "BodyTypeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BodyTypeCollectionCell")
        self.mainImage.setImageWith(URL.bodyImage(typeIndex: selectedBodyType)!)
    }
    
    
    @IBAction func didValidateBodyType(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.didSelectNewBodyTypeValue(self.selectedBodyType)
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapClosePopUp(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.didRequestClose()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BodyTypeCollectionCell", for: indexPath) as! BodyTypeCollectionCell
        cell.bodyImage.setImageWith(URL.bodyImage(typeIndex: indexPath.row + 1)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let CellWidth = 40
        let CellCount = 5
        let CellSpacing = 5
        
        let totalCellWidth = CellWidth * CellCount
        let totalSpacingWidth = CellSpacing * (CellCount - 1)
        
        let leftInset = (230 - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.mainImage.setImageWith(URL.bodyImage(typeIndex: indexPath.row + 1)!)
    }

}
