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

@interface BillingVC : UIViewController <CCTVCDelegate,PaymentVCDelegate>

@property (weak, nonatomic) IBOutlet UIView *tableContentView;
@end
