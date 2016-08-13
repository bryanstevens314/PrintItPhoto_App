//
//  CCTVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCTVC : UITableViewController
+ (CCTVC *)sharedCCTVC;
- (IBAction)BillingSameAsShipping:(id)sender;

@property (nonatomic)BOOL BillingPresenting;
@property (weak, nonatomic) IBOutlet UISwitch *BillingSameAsShippingOutlet;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *LastName;
@property (weak, nonatomic) IBOutlet UITextField *streetAddress;
@property (weak, nonatomic) IBOutlet UITextField *apt;
@property (weak, nonatomic) IBOutlet UITextField *City;
@property (weak, nonatomic) IBOutlet UITextField *zip;
@property (weak, nonatomic) IBOutlet UITextField *state;
@end
