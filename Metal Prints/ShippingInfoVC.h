//
//  ShippingInfoVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 8/12/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShippingTVC.h"
#import "CCTVC.h"
#import "StateTableViewController.h"

@class ShippingInfoVC;

@protocol ShippingInfoVCDelegate

@optional
- (void)FinishedEnteringShippingInformationWithTaxPercent:(float)percent;
-(void)FinishedEnteringShippingInformation;

@end


@interface ShippingInfoVC : UIViewController <ShippingTVCDelegate,StateTableViewControllerDelegate>
@property (weak, nonatomic) id<ShippingInfoVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *orderDataView;
@property (retain, nonatomic) NSDictionary *addressDict;
@property (nonatomic) NSInteger selectedRow;
@property(nonatomic) BOOL savingAddress;
@property(nonatomic) BOOL editingAddress;
//@property (retain, nonatomic) STPPaymentContext *paymentContext;

@end
