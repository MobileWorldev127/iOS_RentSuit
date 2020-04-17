//
//  NewsViewController.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 23/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class NewsViewController:  BasepageViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    let cellidentfier  = "newsCellId"
    var listNews :[News]  = [News]()
    var pagerNews : PagerNews?
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    static let sharedInstance: NewsViewController = {
        let instance: NewsViewController = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
        instance.index = 3
        
        return instance
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListNewsWs()
        // Do any additional setup after loading the view.
    }
    
    func getListNewsWs() {
        PagerNews.getListNews(newsUrl: "news",paginated:false) { (pagerNewsRslt, errors) in
            if (pagerNewsRslt != nil){
                self.pagerNews = pagerNewsRslt
                self.listNews = (pagerNewsRslt!.listNews)!
                self.newsCollectionView .reloadData()
            }else{
                self.showAlertView(title: nil, message: "server_error".localized)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listNews.count
//        return 10

        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentfier, for: indexPath as IndexPath) as! NewsCollectionViewCell
        let news:News = listNews[indexPath.row]
        cell.setupCellWithNews(news: news)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellPhotoWidth  :CGFloat = (SCREEN_WIDTH - 20) / 2 ;
        let cellPhotoHeight :CGFloat = 256  ;
        return CGSize(width: cellPhotoWidth, height: cellPhotoHeight)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let ymaxOffset:CGFloat = scrollView.contentSize.height - scrollView.frame.height
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y >= ymaxOffset ){
            getMoreNews()
        }
    }

    func getMoreNews()  {
        if pagerNews?.nextPageUrl != nil {
            PagerNews.getListNews(newsUrl:(pagerNews?.nextPageUrl!)! ,paginated:true) { (pagerNewsRslt, errors) in
                if (pagerNewsRslt != nil){
                    self.pagerNews = pagerNewsRslt
                    self.listNews.append(contentsOf: pagerNewsRslt!.listNews!)
                    self.newsCollectionView .reloadData()
                }
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
