//
//  Front_EndVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 4/24/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsTVC.h"
#import "ProductCollectionViewController.h"

@interface Front_EndVC : UIViewController <ProductDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

+ (Front_EndVC *)sharedFrontEnd_VC;
- (IBAction)ShoppingCartSelected:(id)sender;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *Shopping_Cart_Outlet;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
