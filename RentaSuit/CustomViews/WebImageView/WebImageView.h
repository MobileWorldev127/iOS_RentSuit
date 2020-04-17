//
//  WebImageView.h
//  i-wantit
//
//  Created by BACEM Ben Afia on 5/17/18.
//  Copyright © 2018 Octopepper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebImageView : UIImageView
    
-(void) setImageFromUrl : (NSString *) imageurl placeHolder :(UIImage *) placeholder;

@end
