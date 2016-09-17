//
//  TaxTVCCell.h
//  Metal Prints
//
//  Created by Bryan Stevens on 9/15/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaxTVCCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tax_Percent;
@property (weak, nonatomic) IBOutlet UILabel *total_Tax;
@property (weak, nonatomic) IBOutlet UILabel *tax_Label;

@property (weak, nonatomic) IBOutlet UILabel *enter_Address;
@end
