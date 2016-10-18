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
#import "ActualCCTVC.h"
#import "StateTableViewController.h"

@class ShippingInfoVC;

@protocol ShippingInfoVCDelegate

- (void)FinishedEnteringShippingInformationWithTaxPercent:(float)percent;

@end


@interface ShippingInfoVC : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource,ShippingTVCDelegate,StateTableViewControllerDelegate>
@property (weak, nonatomic) id<ShippingInfoVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *orderDataView;
//@property (retain, nonatomic) STPPaymentContext *paymentContext;
- (IBAction)PresentNextView:(id)sender;
@end
