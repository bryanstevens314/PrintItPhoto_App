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

@interface ShoppingCartTVC : UITableViewController <DetailsTVCDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *total_Outlet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *totalPrints;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end
