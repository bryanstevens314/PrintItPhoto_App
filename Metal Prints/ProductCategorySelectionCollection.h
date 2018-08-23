//
//  ProductCategorySelectionCollection.h
//  Metal Prints
//
//  Created by Bryan Stevens on 8/9/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCategoryCell.h"

#import "ProductCollectionViewController.h"
#import "DetailsTVC.h"
#import "ImageCollectionViewController.h"
#import "ShoppingCartTVC.h"
#import <QuartzCore/QuartzCore.h>

@class ProductCategorySelectionCollection;

@protocol ProductCategoryDelegate

@optional
- (void)selectedCategoryWithSection:(NSInteger)section;

@end

@interface ProductCategorySelectionCollection : UICollectionViewController <UIGestureRecognizerDelegate,ProductCollectionDelegate,ShoppingCartTVCDelegate,DetailsTVCDelegate>{
    BOOL displayingProducts;
    BOOL finished;
}

- (void)FinishedLoadingImages;
-(void)SlideOverView;
@property (weak, nonatomic) id<ProductCategoryDelegate> delegate;

+ (ProductCategorySelectionCollection *)sharedProductCategorySelectionCollection;


@property (weak, nonatomic) IBOutlet UILabel *label;
@end
