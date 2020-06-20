//
//  HomeViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 01/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class HomeViewController: BaseViewController ,HomePagerDelagate, HomeVcpageItemDelegate{
    
    
    @IBOutlet weak var menuBtnsStackview: UIStackView!
    
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var garmentsBtn: UIButton!
    @IBOutlet weak var shippingBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var contactBtn: UIButton!
    @IBOutlet weak var pagerContainerView: UIView!
    @IBOutlet weak var selectedViewHome: UIView!
    @IBOutlet weak var selectedgarmentsView: UIView!
    @IBOutlet weak var selectedShippingView: UIView!
    
    @IBOutlet weak var newsBtn: UIButton!
    @IBOutlet weak var selectedContactView: UIView!
    @IBOutlet weak var selectedSearchView: UIView!
    
    @IBOutlet weak var selectedNewsViews: UIView!
    
    @IBOutlet weak var moreButton: UIButton!
    
    var homePagerViewController:HomePagerViewController? = nil
    var homeItemVC : HomeVcPageItemViewController? = nil
    var garmentsVC : GarmentsPageViewController? = nil
    var shippingVC : ShippingPageViewController? = nil
//    var searchVC : SearchPageViewController? = nil
    var aboutVC    : AboutViewController? = nil
    var contatcUsVC : ContatcUsPageViewController? = nil
    var newsVC : NewsViewController? = nil

    
    var currentPage : NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
      setupHomePager(index: 0)
        Category.loadRemoteCategories()
    }
    
  func setupHomePager(index page: NSInteger)  {
//        currentPage = 0

        if (homePagerViewController != nil) {
            homePagerViewController?.view .removeFromSuperview()
            homePagerViewController?.removeFromParentViewController()
        }
        homePagerViewController = HomePagerViewController()
        homePagerViewController!.currentPage = page
        homePagerViewController!.allViewControllersPage = getAllHomeViewControllers()
        homePagerViewController!.delegate = self
        homePagerViewController!.view.frame = self.pagerContainerView.bounds
        homePagerViewController!.view.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        self.pagerContainerView .addSubview((homePagerViewController?.view)!)
        self .addChildViewController(homePagerViewController!)
        self.view.layoutIfNeeded()
        self.updateHeader(indexBtn:homePagerViewController!.currentPage)
        
    }
    func getAllHomeViewControllers() -> [UIViewController] {
         homeItemVC = HomeVcPageItemViewController.sharedInstance
      homeItemVC?.delegate = self
         garmentsVC = GarmentsPageViewController.sharedInstance
         shippingVC = ShippingPageViewController.sharedInstance
//         aboutVC = AboutViewController.sharedInstance
         contatcUsVC = ContatcUsPageViewController.sharedInstance
//         newsVC = NewsViewController.sharedInstance

        return [homeItemVC!,garmentsVC!,contatcUsVC!,shippingVC!]
    }
    func updateHeader(indexBtn:NSInteger) -> Void {
        for  subview:UIView in self.menuBtnsStackview!.subviews {
            
             if subview .isKind(of:UIView.self){
                for  subviewBtn:UIView in subview.subviews {
                    if subviewBtn .isKind(of:UIButton.self){
                        let currentbtn : UIButton = subviewBtn as! UIButton
                        if currentbtn.tag == indexBtn {
                            currentbtn.isSelected = true
                        }else{
                            currentbtn.isSelected = false
                        }
                        self.setBtnState(btn: currentbtn,indexbtnSelected: indexBtn)
                    }
                }
            }
            
        }
        
    }
    func setBtnState(btn:UIButton ,indexbtnSelected : NSInteger) {
        if btn.isSelected {
            btn.setTitleColor(UIColor.yellowApp(), for: .normal)
            if indexbtnSelected == btn.tag{
                switch indexbtnSelected {
                case 0:
                    self.selectedViewHome.isHidden = false
//                    self.selectedSearchView.isHidden = true
                    self.selectedgarmentsView.isHidden = true
//                    self.selectedNewsViews.isHidden = true
                    self.selectedContactView.isHidden = true
                    self.selectedShippingView.isHidden = true

                break
                case 1:
                    self.selectedViewHome.isHidden = true
//                    self.selectedSearchView.isHidden = false
                    self.selectedgarmentsView.isHidden = false
//                    self.selectedNewsViews.isHidden = true
                    self.selectedContactView.isHidden = true
                    self.selectedShippingView.isHidden = true

                    break
                case 2:
                    self.selectedViewHome.isHidden = true
//                    self.selectedSearchView.isHidden = true
                    self.selectedgarmentsView.isHidden = true
//                    self.selectedNewsViews.isHidden = false
                    self.selectedContactView.isHidden = false
                    self.selectedShippingView.isHidden = true

                    break
                case 3:
                    self.selectedViewHome.isHidden = true
//                    self.selectedSearchView.isHidden = true
                    self.selectedgarmentsView.isHidden = true
//                    self.selectedNewsViews.isHidden = true
                    self.selectedContactView.isHidden = true
                    self.selectedShippingView.isHidden = false

                    break
//                case 4:
//                    self.selectedViewHome.isHidden = true
////                    self.selectedSearchView.isHidden = true
//                    self.selectedgarmentsView.isHidden = true
//                    self.selectedNewsViews.isHidden = true
//                    self.selectedContactView.isHidden = true
//                    self.selectedShippingView.isHidden = false
//
//                    break
//                case 5:
//                    self.selectedViewHome.isHidden = true
//                    self.selectedSearchView.isHidden = true
//                    self.selectedgarmentsView.isHidden = true
//                    self.selectedNewsViews.isHidden = true
//                    self.selectedContactView.isHidden = true
//                    self.selectedShippingView.isHidden = false
//
//                    break
                    
                default:
                    break
                }
            }
        }else{
            btn.setTitleColor(UIColor.black, for: .normal)
        }
    }
  
    
    @IBAction func pageBtnPressed(_ sender: UIButton) {
      let pageItemClicked  =  homePagerViewController!.slideToIndex(index: sender.tag)
        print(pageItemClicked)
    }
  
    func didScrollToPage(index: NSInteger) {
        currentPage = index
        self.updateHeader(indexBtn: index)
    }
  
//    func setUpHomepage(index: NSInteger) {
//      print("12", index)
//     }
  
    @IBAction func didSelectMoreButton(_ sender: UIButton) {
        let vc = getViewControllerInstance(sbId: "HomeStoryboard", vcId: "pop_up_scene") as! PopUpSelectorViewController
        vc.delegate = self
        self.addChildViewController(vc)
        view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
}

extension HomeViewController : PopUpSelectorDelegate {
    func didTapAtIndex(index: Int) {
        switch index {
        case 0:
            goToProfile()
            break
        case 1:
//            goToChat()
            goToRented()
            break
        case 2:
//            goToBilling()
            goToForRent()
            break
        case 3:
            goToMap()
            break
        case 4:
            goToWishList()
            break
        case 5:
            goToCartList()
            break
        case 6:
            logout()
            break
        default:
            break
        }
    }
    
    func goToProfile() {
        self.startLoading()
        UserProfile.loadRemoteProfile(callBack: { (profile, code) in
            self.stopLoading()
            if nil != profile {
                let vc = self.getViewControllerInstance(sbId: "Profile",
                                                        vcId: "profile_screen") as! ProfileViewController
                vc.profile = profile;
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                print(String(format: "error code %d", code != nil ? code! : 666))
            }
            
        })
    }
    
    
//    func goToChat(){
//        self.pushViewController(sbId: "Chat",
//                                vcId: "chat_screen",
//                                animated: true)
//    }
    
    func goToRented(){
      self.startLoading()
      RentedProduct.myRentedList {(rentedProducts, code) in
        self.stopLoading()
        let vc  = self.getViewControllerInstance(sbId: "RentedList",vcId: "rented_list_screen") as! RentedListViewController
          vc.rentedList = rentedProducts
        self.navigationController?.pushViewController(vc, animated: true)
      }
    }
    
//    func goToBilling(){
//        self.pushViewController(sbId: "BillingMethods",
//                                vcId: "billing_screen",
//                                animated: true)
//    }
  
  func goToForRent() {
    self.startLoading()
    AddedProduct.myAddedProductList {(rentedProducts, code) in
      self.stopLoading()
      let vc  = self.getViewControllerInstance(sbId: "ForRentList",vcId: "for_rent_list_screen") as! ForRentListViewController
        vc.forRentAddedProductList = rentedProducts
      self.navigationController?.pushViewController(vc, animated: true)
    }
    
  }
    
    func goToMap(){
        self.pushViewController(sbId: "Map",
                                vcId: "map_screen",
                                animated: true)
    }
    
    func goToWishList(){
        
        self.startLoading()
        Wish.myWishList { (products, code) in
            self.stopLoading()
//            if products != nil {
                let vc  = self.getViewControllerInstance(sbId: "Wishlist",vcId: "wish_list_scene") as! WishListViewController
                vc.wishList = products
                self.navigationController?.pushViewController(vc, animated: true)
//            }else{
//                
//            }
        }
        
    }
    
    func goToCartList() {
        self.startLoading()
        Cart.cartList(callBack:{ (products, code) in
            self.stopLoading()
            let vc  = self.getViewControllerInstance(sbId: "Cartlist",vcId: "cart_list_scene") as! CartListViewController
            vc.cartList = products
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    func logout(){
        self.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.stopLoading()
            APP_DELEGATE.logout()
        }
    }
    
}
