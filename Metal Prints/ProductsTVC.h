//
//  ProductsTVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductsTVC;

@protocol ProductDelegate

@optional
- (void)ProductSelectedWithRow:(NSInteger)row andSection:(NSInteger)section;

@end

@interface ProductsTVC : UITableViewController
@property (weak, nonatomic) id<ProductDelegate> delegate;
@end
