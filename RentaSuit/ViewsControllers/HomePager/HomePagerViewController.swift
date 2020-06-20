//
//  HomePagerViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 11/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
protocol HomePagerDelagate : AnyObject {
    func didScrollToPage(index:NSInteger)
}
class HomePagerViewController: UIViewController  ,UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    weak var delegate: HomePagerDelagate?
    
    var allViewControllersPage:[UIViewController]?;
    
    
    var currentPage : NSInteger = 0
    
    
    var pageVc:UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPager()
        // Do any additional setup after loading the view.
    }
    
    func setupPager() {
        self.pageVc = UIPageViewController.init(transitionStyle:.scroll, navigationOrientation: .horizontal, options: nil)
        self.pageVc?.dataSource = self
        self.pageVc?.delegate = self
        if ((self.allViewControllersPage) != nil) {
            self.pageVc?.setViewControllers( [self.allViewControllersPage![currentPage]], direction:.forward, animated: true, completion: nil)
            self.pageVc?.view.autoresizingMask = [ .flexibleWidth , .flexibleHeight]
            self.pageVc?.view.frame = self.view.bounds
            self.view .addSubview((self.pageVc?.view)!)
            self .addChildViewController(self.pageVc!)
            
        }
        //         homeVC = HomeVcPageItemViewController.sharedInstance
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let indexofVc : NSInteger = allViewControllersPage?.index(of: viewController) {
            let nextIndex: NSInteger = indexofVc - 1
            if nextIndex >= 0 && nextIndex < (allViewControllersPage?.count)!{
                return allViewControllersPage![nextIndex]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let indexofVc : NSInteger = allViewControllersPage?.index(of: viewController) {
            let nextIndex: NSInteger = indexofVc + 1
            if nextIndex >= 0 && nextIndex < (allViewControllersPage?.count)!{
                return allViewControllersPage![nextIndex]
            }
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
        let pager: BasepageViewController = pendingViewControllers[0] as! BasepageViewController
        currentPage =  pager.index
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if self.delegate != nil{
                self.delegate!.didScrollToPage(index: currentPage)
            }
        }
    }
    
    func nextpage() -> Bool {
        let nextpage: NSInteger = currentPage + 1
        
        return self.slideToIndex(index: nextpage)
    }
    func previousPage() -> Bool {
        let previousPg: NSInteger = currentPage - 1
        
        return  self.slideToIndex(index: previousPg)
        
    }
    func slideToIndex(index:NSInteger) -> Bool {
        if (index >= 0 && index < (allViewControllersPage?.count)! ){
            if(index != currentPage){
                let direction : UIPageViewControllerNavigationDirection = index > currentPage ? UIPageViewControllerNavigationDirection.forward : UIPageViewControllerNavigationDirection.reverse
                
                let viewControllerAtPage: UIViewController? = allViewControllersPage![index]
                
                if (viewControllerAtPage != nil ){
                    self.pageVc?.setViewControllers( [viewControllerAtPage!], direction:direction, animated: true, completion: nil)
                    currentPage = index
                    if self.delegate != nil{
                        self.delegate?.didScrollToPage(index: currentPage)
                    }
                    return true;
                }
                
            }
            return false
            
        }
        return false
    }
  
    func slideToIndex1(index:NSInteger) -> Bool {
        if (index >= 0 && index < (allViewControllersPage?.count)! ){
            if(index != currentPage){
                let direction : UIPageViewControllerNavigationDirection = index > currentPage ? UIPageViewControllerNavigationDirection.forward : UIPageViewControllerNavigationDirection.reverse
                
                let viewControllerAtPage: UIViewController? = allViewControllersPage![index]
                
                if (viewControllerAtPage != nil ){
                    self.pageVc?.setViewControllers( [viewControllerAtPage!], direction:direction, animated: true, completion: nil)
                    currentPage = index
                    self.delegate?.didScrollToPage(index: currentPage)
                    
                }
                
            }
            return false
            
        }
        return false
    }
    
    func  getCurrentPage() -> NSInteger {
        return currentPage
    }
    func setCurrentpage(_currentpage:NSInteger)  {
        currentPage = _currentpage
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
