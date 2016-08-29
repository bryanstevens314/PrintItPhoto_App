//
//  BillingVC.h
//  
//
//  Created by Bryan Stevens on 8/22/16.
//
//

#import <UIKit/UIKit.h>
#import "CCTVC.h"
@interface BillingVC : UIViewController <CCTVCDelegate>

@property (weak, nonatomic) IBOutlet UIView *tableContentView;
@end
