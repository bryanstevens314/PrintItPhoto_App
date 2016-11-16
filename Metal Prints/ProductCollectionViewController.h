//
//  ProductCollectionViewController.h
//  Metal Prints
//
//  Created by Bryan Stevens on 8/10/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCollectionViewCell.h"
#import "DetailsTVC.h"
#import "TabController.h"

@class ProductCollectionViewController;

@protocol ProductCollectionDelegate <UIGestureRecognizerDelegate>

@optional
- (void)ProductSelectedWithRow:(NSInteger)row Section:(NSInteger)section andArray:(NSArray*)curArray;
-(void)userSlideViewAway;
@end

@interface ProductCollectionViewController : UICollectionViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) id<ProductCollectionDelegate> delegate;
+ (ProductCollectionViewController *)sharedProductCollectionVC;

@property (strong, nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong,nonatomic) NSArray *currentProductArray;
@property (nonatomic) NSInteger selectedSection;
@end
