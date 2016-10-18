//
//  CartTVCCell.h
//  Metal Prints
//
//  Created by Bryan Stevens on 4/25/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartTVCCell;

@protocol CartTVCCellDelegate

- (void)addedQuantity;

@end


@interface CartTVCCell : UITableViewCell
@property (weak, nonatomic) id<CartTVCCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *product_textField;
@property (weak, nonatomic) IBOutlet UILabel *product;
@property (weak, nonatomic) IBOutlet UILabel *retouch_Outlet;
@property (weak, nonatomic) IBOutlet UILabel *aluminum_Outlet;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (retain, nonatomic) UIImageView *img_View;
@property (weak, nonatomic) NSString *imgViewURL;
@property (weak, nonatomic) NSString *imgType;

@property (weak, nonatomic) IBOutlet UITextField *quantity_TextField;
@property (weak, nonatomic) IBOutlet UILabel *total_Price;
@property (weak, nonatomic) IBOutlet UITextField *retouch_textField;
@property (weak, nonatomic) IBOutlet UITextField *aluminum_textField;
@property (weak, nonatomic) IBOutlet UITextView *instructionsTextView;
- (IBAction)addToQuantity:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addOutlet;
- (IBAction)subtractFromQuantity:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *subtractOutlet;
@property (retain, nonatomic) UITextView *instructions_TextView;
@property (retain, nonatomic) UILabel *instructionsOutlet;
@property (retain, nonatomic) UILabel *instructions_Outlet;


@property (retain, nonatomic) UIPickerView *productPicker;
@property (retain, nonatomic) UIPickerView *retouchPicker;
@property (retain, nonatomic) UIPickerView *easelPicker;

@property (retain, nonatomic) NSString *imageSizeType;
@end
