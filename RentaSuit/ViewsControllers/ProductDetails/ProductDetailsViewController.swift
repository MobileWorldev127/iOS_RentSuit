//
//  ProductDetailsViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/15/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Cosmos

class ProductDetailsViewController: BaseViewController, UIScrollViewDelegate {

    @IBOutlet weak var ownerTitleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var pricePerHourLabel: UILabel!
    @IBOutlet weak var availableAtLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var designerKeyLabel: UILabel!
    @IBOutlet weak var seasonKeyLabel: UILabel!
    @IBOutlet weak var categoryKeyLabel: UILabel!
    @IBOutlet weak var locationKeyLabel: UILabel!
    @IBOutlet weak var sizeKeyLabel: UILabel!
    @IBOutlet weak var colorKeyLabel: UILabel!
    @IBOutlet weak var retailPriceKeyLabel: UILabel!
    
    @IBOutlet weak var designerValueLabel: UILabel!
    @IBOutlet weak var seasonValueLabel: UILabel!
    @IBOutlet weak var categoryValueLabel: UILabel!
    @IBOutlet weak var locationValueLabel: UILabel!
    @IBOutlet weak var sizeValueLabel: UILabel!
    @IBOutlet weak var colorValueLabel: UILabel!
    @IBOutlet weak var retailPriceValueLabel: UILabel!
    
    @IBOutlet weak var agencyNameLabel: UILabel!
    @IBOutlet weak var agencyLocationLabel: UILabel!
    @IBOutlet weak var agencyLogoImage: UIImageView!
    @IBOutlet weak var bodyTypeKeyLabel: UILabel!
    @IBOutlet weak var bodyTypeImage: UIImageView!
    
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var productTitleLbl: UILabel!
    
    @IBOutlet weak var onWishListButton: UIButton!
    var slides = [ProductSlide]()
    
    var item : Wish?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        let images = self.item?.images
        self.pageControl.numberOfPages = nil != images ? images!.count : 0
        createSlides()
        self.setUpSlidesScrollView(slides: slides)
        setUp()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didSelectShoppingButton(_ sender: UIButton) {
        let vc = getViewControllerInstance(sbId: "Rent", vcId: "for_rent_screen") as! ForRentViewController
        vc.product = self.item
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // info
    
    fileprivate func updateIsOnWisListButtonState(_ onWishList: Bool) {
        self.onWishListButton.setImage(UIImage(named:onWishList ? "ic_favorite_border" : "ic_favorite_border_not_selected"), for: UIControlState())
    }
    
    func setUp() {
        let placeHolder : UIImage? = UIImage.init(named: "placeholder-test")
         if ((item?.userDetail)!.photo! != nil) {
             let urlwithPercentEscapes =  ((item?.userDetail)!.photo!).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
             let url:URL = URL(string:urlwithPercentEscapes!)!
             self.agencyLogoImage.setImageWith(url, placeholderImage: placeHolder)
         }
        self.agencyNameLabel.text = item?.userDetail?.displayName()
        self.pricePerHourLabel.text = "$" + item!.price! + "/day"
        self.descriptionLabel.text = item?.detail
//        self.ownerTitleLabel.text = item?.userDetail?.displayName()
        self.ownerTitleLabel.text = item?.condition
        self.productTitleLbl.text = item?.name
        self.designerValueLabel.text = item?.designer
        self.sizeValueLabel.text = item?.size
        self.seasonValueLabel.text = item?.season
        self.locationValueLabel.text = item?.location
        self.colorValueLabel.text = item?.color
        self.categoryValueLabel.text = Category.categoryWithId((item?.category)!)
        self.retailPriceValueLabel.text = "$" + item!.retailPrice!
        self.contactLbl.text = item?.userDetail?.displayName()
        ratingView.rating = Double(exactly: (item?.avgProductReview)!)!
        self.availableAtLabel.text = item?.rentStartAt
        let onWishList = (item?.onWishlist)!
        updateIsOnWisListButtonState(onWishList)
    }
    
    // slides
    
    // prepare slides
    fileprivate func createSlides() {
        if nil == item?.images {
            return
        }
        for pic in (item?.images)! {
            let slide = ProductSlide.clone()
            slide.setUpSlide(pic)
            slides.append(slide)
        }
    }
    
    // set up the scrollView with its slides
    fileprivate func setUpSlidesScrollView(slides : [ProductSlide]) {
        scrollView.contentSize =  CGSize(width: CGFloat(slides.count) * SCREEN_WIDTH, height: self.scrollView.frame.height)
        for i in 0 ..< slides.count {
            let slide = slides[i]
            slide.frame = CGRect(x: SCREEN_WIDTH * CGFloat(i), y: 0, width: SCREEN_WIDTH, height: self.scrollView.frame.height)
            scrollView.addSubview(slide)
        }
    }
    
    // pagination setting & indicatior updates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/SCREEN_WIDTH)
        pageControl.currentPage = Int(pageIndex)
    }
    
    // automated page updates
    func animatePageTransition() {
        let pageIndex = pageControl.currentPage
        if pageIndex >= 0 && pageIndex < slides.count-1{
            moveToPage(pageIndex: pageIndex + 1)
        }else{
            moveToPage(pageIndex: 0)
        }
    }
    
    // move to page with index
    func moveToPage(pageIndex : Int) {
        self.scrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * CGFloat(pageIndex), y: 0), animated: true)
    }
    @IBAction func didTapWishedButton(_ sender: Any) {
        var onWishList = (item?.onWishlist)!
        if onWishList {
            item?.delete(callBack: { (msg) in})
        }else{
            item?.add(callBack: { (msg) in})
        }
        item?.onWishlist = !(item?.onWishlist)!
        onWishList = (item?.onWishlist)!
        updateIsOnWisListButtonState(onWishList)
    }
    
}
