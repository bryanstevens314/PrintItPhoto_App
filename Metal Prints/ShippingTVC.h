//
//  ShippingTVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>
#import "StateTableViewController.h"

@class ShippingTVC;

@protocol ShippingTVCDelegate

- (void) zipIsFirstResponderMoveViewUp;
- (void) zipResignedFirstResponderMoveViewDown;
-(void)displayStateController;
@end


@interface ShippingTVC : UITableViewController 
@property (weak, nonatomic) id<ShippingTVCDelegate> delegate;
+ (ShippingTVC *)sharedShippingTVC;

@property (nonatomic)BOOL ShippingPresenting;

@property (retain, nonatomic) UIToolbar* keyboardDoneButtonView1;
@property (weak, nonatomic) IBOutlet UITextField *name_TextField;

@property (weak, nonatomic) IBOutlet UITextField *street_TextField;
@property (weak, nonatomic) IBOutlet UITextField *apt_TextField;
@property (weak, nonatomic) IBOutlet UITextField *city_TextField;
@property (weak, nonatomic) IBOutlet UITextField *state_TextField;
@property (weak, nonatomic) IBOutlet UITextField *zip_TextField;
@property (weak, nonatomic) IBOutlet UITextField *country_Textfield;

@end
