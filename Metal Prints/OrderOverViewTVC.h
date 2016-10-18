//
//  OrderOverViewTVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 9/15/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShippingInfoVC.h"
#import "BillingVC.h"
#import "PaymentVC.h"

@interface OrderOverViewTVC : UITableViewController <ShippingInfoVCDelegate, BillingVCDelegate,PaymentVCDelegate>

@property (weak, nonatomic) IBOutlet UIView *cartOverViewTalbe;
@property (weak, nonatomic) IBOutlet UILabel *shipping_Address;
@property (weak, nonatomic) IBOutlet UILabel *shipping_City;
@property (weak, nonatomic) IBOutlet UILabel *shipping_ZIP;
@property (weak, nonatomic) IBOutlet UILabel *billing_Name;
@property (weak, nonatomic) IBOutlet UILabel *billing_Card;
@property (weak, nonatomic) IBOutlet UILabel *billing_Exp;
@property (weak, nonatomic) IBOutlet UIImageView *shipping_Entered;
@property (weak, nonatomic) IBOutlet UIImageView *billing_Entered;
@property (weak, nonatomic) IBOutlet UILabel *cartTotal_Outlet;
@property (weak, nonatomic) IBOutlet UILabel *tax_Outlet;
@property (weak, nonatomic) IBOutlet UILabel *shipping_Outlet;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice_Outlet;
- (IBAction)PlaceTheOrder:(id)sender;
@end
