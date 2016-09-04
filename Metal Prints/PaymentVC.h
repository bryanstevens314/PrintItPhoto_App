//
//  PaymentVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 8/22/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

@import Stripe;
#import <UIKit/UIKit.h>
#import "Sendpulse.h"

@interface PaymentVC : UIViewController <STPPaymentContextDelegate>

@property (weak, nonatomic) IBOutlet UIView *tableContentView1;
@end
