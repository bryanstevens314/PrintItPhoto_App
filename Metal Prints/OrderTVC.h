//
//  OrderTVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTVC : UITableViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)ChooseImage:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *image_View;
@property (weak, nonatomic) IBOutlet UITextField *Name_Outlet;
@property (weak, nonatomic) IBOutlet UITextField *Email_Outlet;
@property (weak, nonatomic) IBOutlet UITextField *Product_Outlet;
@property (weak, nonatomic) IBOutlet UIButton *Choose_Image_Outlet;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell;
@end
