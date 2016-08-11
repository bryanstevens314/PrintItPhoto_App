//
//  ProductCollectionViewController.h
//  Metal Prints
//
//  Created by Bryan Stevens on 8/10/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCollectionViewCell.h"
#import "ProductCategorySelectionCollection.h"

@interface ProductCollectionViewController : UICollectionViewController

+ (ProductCollectionViewController *)sharedProductCollectionVC;


@property (strong,nonatomic) NSArray *currentProductArray;
@end
