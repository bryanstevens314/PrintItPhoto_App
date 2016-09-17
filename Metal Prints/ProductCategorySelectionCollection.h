//
//  ProductCategorySelectionCollection.h
//  Metal Prints
//
//  Created by Bryan Stevens on 8/9/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCategoryCell.h"

@class ProductCategorySelectionCollection;

@protocol ProductCategoryDelegate

- (void)selectedCategoryWithSection:(NSInteger)section;

@end

@interface ProductCategorySelectionCollection : UICollectionViewController <UIGestureRecognizerDelegate>{
    BOOL displayingProducts;
    BOOL finished;
}
@property (weak, nonatomic) id<ProductCategoryDelegate> delegate;

+ (ProductCategorySelectionCollection *)sharedProductCategorySelectionCollection;


@property (weak, nonatomic) IBOutlet UILabel *label;
@end
