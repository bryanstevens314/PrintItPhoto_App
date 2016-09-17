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

@class ShippingInfoVC;

@protocol ShippingInfoVCDelegate

- (void)FinishedEnteringShippingInformation;

@end


@interface ShippingInfoVC : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource,ShippingTVCDelegate>
@property (weak, nonatomic) id<ShippingInfoVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *orderDataView;
//@property (retain, nonatomic) STPPaymentContext *paymentContext;
- (IBAction)PresentNextView:(id)sender;
@end
