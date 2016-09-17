//
//  CartItemTVCCell.h
//  Metal Prints
//
//  Created by Bryan Stevens on 9/15/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartItemTVCCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *quantity;
@property (weak, nonatomic) IBOutlet UILabel *product;
@property (retain, nonatomic) NSString *product_Image_String;
- (IBAction)view_Image:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *view_Image_Outlet;

@property (weak, nonatomic) IBOutlet UILabel *item_Price;
@end
