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

@interface ShippingInfoVC : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource,ShippingTVCDelegate>

@property (weak, nonatomic) IBOutlet UIView *orderDataView;

- (IBAction)PresentNextView:(id)sender;
@end
