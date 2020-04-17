//
//  NewsCollectionViewCell.swift
//  RentaSuit
//
//  Created by htrimech MacBook Pro on 23/10/2018.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var readMorebtn: UIButton!
    @IBOutlet weak var blogNumberLabel: UILabel!
    
    func setupCellWithNews(news:News)  {
        self.blogNumberLabel.text = news.title
        let placeHolder : UIImage? = UIImage.init(named: "placeholder-test")
        if (news.picture != nil) {
            let urlwithPercentEscapes =  (kBaseUrlImage + news.picture!).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url:URL = URL(string:urlwithPercentEscapes!)!
            self.newsImageView.setImageWith(url, placeholderImage: placeHolder)
                   }
    }
}
