//
//  ShoppingCartTVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 4/25/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsTVC.h"
#import "ShippingTVC.h"
#import "ShippingInfoVC.h"
#import "Sendpulse.h"
#import "CartTVCCell.h"

@class ShoppingCartTVC;

@protocol ShoppingCartTVCDelegate

- (void)SelectedRowWithData:(NSArray*)data;

@end

@interface ShoppingCartTVC : UITableViewController <DetailsTVCDelegate,CartTVCCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) id<ShoppingCartTVCDelegate> delegate;
+ (ShoppingCartTVC *)sharedShoppingCartTVC;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *total_Outlet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *totalPrints;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (nonatomic,retain) NSString *mainController;
@end
