//
//  CCTVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCTVC;

@protocol CCTVCDelegate

-(void)moveViewUp;
-(void)moveViewDown;

@end


@interface CCTVC : UITableViewController <UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) id<CCTVCDelegate> delegate;
+ (CCTVC *)sharedCCTVC;
@property (weak, nonatomic) IBOutlet UIView *tableContentView1;
- (IBAction)BillingSameAsShipping:(id)sender;

@property (nonatomic)BOOL BillingPresenting;

@property (retain, nonatomic) UIToolbar* keyboardDoneButtonView2;
@property (retain, nonatomic) NSString *currentYear;
@property (retain, nonatomic) NSString *currentMonth;
@property (weak, nonatomic) IBOutlet UISwitch *BillingSameAsShippingOutlet;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *ccn;
@property (weak, nonatomic) IBOutlet UITextField *expMonth;
@property (weak, nonatomic) IBOutlet UITextField *cvc;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *LastName;
@property (weak, nonatomic) IBOutlet UITextField *streetAddress;
@property (weak, nonatomic) IBOutlet UITextField *apt;
@property (weak, nonatomic) IBOutlet UITextField *City;
@property (weak, nonatomic) IBOutlet UITextField *zip;
@property (weak, nonatomic) IBOutlet UITextField *state;
@end
