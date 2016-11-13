//
//  SavedAddressTVCell.h
//  Metal Prints
//
//  Created by Bryan Stevens on 10/27/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedAddressTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *NameTextField;
@property (weak, nonatomic) IBOutlet UITextField *AddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *StateZIPTextField;
@property (weak, nonatomic) IBOutlet UIButton *addAddressButton;
@end
