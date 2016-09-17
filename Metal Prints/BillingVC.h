//
//  BillingVC.h
//  
//
//  Created by Bryan Stevens on 8/22/16.
//
//

#import <UIKit/UIKit.h>
#import "CCTVC.h"
#import "PaymentVC.h"

@class BillingVC;

@protocol BillingVCDelegate

- (void)FinishedEnteringBillingInformation;

@end

@interface BillingVC : UIViewController <CCTVCDelegate,PaymentVCDelegate>
@property (weak, nonatomic) id<BillingVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *tableContentView;
@end
