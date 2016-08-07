//
//  ShoppingCartTVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 4/25/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsTVC.h"

@interface ShoppingCartTVC : UITableViewController <UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *total_Outlet;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end
