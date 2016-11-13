//
//  ContactUSTVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 10/27/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ContactUSTVC : UITableViewController <UIPickerViewDelegate,UIPickerViewDataSource,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *problemTextField;
@end
