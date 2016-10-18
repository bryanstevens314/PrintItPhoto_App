//
//  StripeViewController.h
//  Metal Prints
//
//  Created by Bryan Stevens on 9/2/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

@import Stripe;
#import <UIKit/UIKit.h>


@interface StripeViewController : UIViewController <STPPaymentContextDelegate>

@property (retain, nonatomic) STPPaymentContext *paymentContext;
@end
