//
//  ActualCCTVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 5/8/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActualCCTVC : UITableViewController<UIPickerViewDelegate,UIPickerViewDataSource>
+ (ActualCCTVC *)sharedActualCCTVC;
@property (weak, nonatomic) IBOutlet UIView *tableContentsView;

@property (nonatomic)BOOL CCPresenting;
@property (weak, nonatomic) IBOutlet UITextField *CCN;
@property (weak, nonatomic) IBOutlet UITextField *securityCode;
@property (weak, nonatomic) IBOutlet UITextField *expMonth;
@property (weak, nonatomic) IBOutlet UITextField *expYear;
@end
