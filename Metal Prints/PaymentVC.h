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

@class PaymentVC;

@protocol PaymentVCDelegate

- (void)retirevedToken;
- (void)CardSuccessFullyCharged;
- (void)CardFailedToCharged;
-(void)UploadingImages;
-(void)ImagesSuccessFullyUploaded;
-(void)imageUploadFailure;

@end


@interface PaymentVC : UIViewController <STPPaymentContextDelegate>
@property (weak, nonatomic) id<PaymentVCDelegate> delegate;

+ (PaymentVC *)sharedPaymentVC;
- (void)retrieveStripeToken;
- (void)createBackendChargeWithToken:(STPToken *)token completion:(void (^)(PKPaymentAuthorizationStatus))completion;

@property (weak, nonatomic) IBOutlet UIView *tableContentView1;
@end
