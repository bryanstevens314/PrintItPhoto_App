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
#import "Front_EndVC.h"

@interface ProductCategorySelectionCollection : UICollectionViewController

+ (ProductCategorySelectionCollection *)sharedProductCategorySelectionCollection;
-(void)cellClickedWithRow:(NSInteger)clickedCell;

@property (weak, nonatomic) IBOutlet UILabel *label;
@end
