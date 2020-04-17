//
//  WebImageView.m
//  i-wantit
//
//  Created by BACEM Ben Afia on 5/17/18.
//  Copyright © 2018 Octopepper. All rights reserved.
//


#import "WebImageView.h"
static NSCache * imageCache;
static NSOperationQueue *imageOperationQueue;

// WS GENERIC CALLBACKS
typedef void (^WSSuccessBlock)(id);
typedef void (^WSFailBlock)(NSError *);

@implementation WebImageView{
    NSString *url;
}
+(void)load{
    imageCache = [[NSCache alloc] init];
    imageCache.countLimit = 20;
    imageCache.totalCostLimit = 10 * 1024;
    imageOperationQueue = [[NSOperationQueue alloc]init];
    imageOperationQueue.maxConcurrentOperationCount = 20;
    [[NSNotificationCenter defaultCenter] addObserver:[WebImageView class] selector:@selector(purgeCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}
    
+(void) purgeCache{
    [imageCache removeAllObjects];
}
    
-(void) setImageFromUrl:(NSString *)imageurl placeHolder:(UIImage *)placeholder{
    if(imageurl == nil ||imageurl.length == 0){
        self.image = placeholder;
        return;
    }
    
    url = imageurl;
    self.image = nil;
    __block NSString *threadIdentifier = imageurl;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
        
        NSString *strImgName = [[[imageurl stringByAddingPercentEncodingWithAllowedCharacters:set] componentsSeparatedByString:@"/"] lastObject];
        
        UIImage *imageFromCache = [UIImage imageWithData:[imageCache objectForKey:strImgName]];
        
        if(imageFromCache == nil){
            if(placeholder != nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = placeholder;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
                
            }
            NSURL *imageUrl = [NSURL URLWithString:imageurl];
            
            
            __weak WebImageView * weakSelf = self;
            
            
            [imageOperationQueue addOperationWithBlock:^{
                
                __block NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if(imageData != nil){
                        
                        
                        UIImage * downloadedImage = [UIImage imageWithData:imageData];
                        imageData = UIImageJPEGRepresentation(downloadedImage, 0.8);
                        
                        
                        if(downloadedImage != nil){
                            if (imageData) {
                                [imageCache setObject:imageData forKey:strImgName];
                            }
                            
                            if(weakSelf != nil){
                                WebImageView * strongSelf = weakSelf;
                                if([threadIdentifier isEqualToString:self->url]){
                                    strongSelf.image = downloadedImage;
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                }];
            }];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if([threadIdentifier isEqualToString:self->url]){
                    self.image = imageFromCache;
                }
            });
        }
    });
}
    
@end
