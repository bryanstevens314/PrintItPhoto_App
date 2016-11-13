//
//  SavedInfoTVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 10/26/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShippingInfoVC.h"

@interface SavedInfoTVC : UITableViewController <ShippingInfoVCDelegate>

+ (SavedInfoTVC *)sharedSavedInfoTVC;
- (IBAction)AddAddress:(id)sender;
@end
