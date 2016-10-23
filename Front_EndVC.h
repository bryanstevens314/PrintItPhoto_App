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
#import "ProductCategorySelectionCollection.h"
#import "DetailsTVC.h"
#import "ImageCollectionViewController.h"

@interface Front_EndVC : UIViewController <ImageCollectionViewControllerDelegate,ProductDelegate,DetailsTVCDelegate, ProductCategoryDelegate,ProductCollectionDelegate,UICollectionViewDelegate,UICollectionViewDataSource>


+ (Front_EndVC *)sharedFrontEnd_VC;
- (void)FinishedLoadingImages;

- (IBAction)ShoppingCartSelected:(id)sender;
-(void)cellClickedWithRow:(NSInteger)clickedCell;
- (IBAction)moveCollectionView:(id)sender;
- (IBAction)SwitchViews:(id)sender;
//@property (nonatomic)  BOOL *collectionContainer;
//@property (nonatomic)  BOOL *collectionContainer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *switchViewsOutlet;

@property (weak, nonatomic) IBOutlet UIView *collectionContainer;


@property (weak, nonatomic) IBOutlet UIView *collectionViewView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Shopping_Cart_Outlet;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
