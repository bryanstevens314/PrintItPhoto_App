//
//  DetailsTVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NonCopyPasteTextField.h"
#import "ImageCropView.h"

@interface DetailsTVC : UITableViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,ImageCropViewControllerDelegate, UINavigationControllerDelegate>

+ (DetailsTVC *)sharedDetailsTVCInstance;
- (IBAction)camera:(id)sender;
@property (weak, nonatomic) IBOutlet UITableViewCell *aluminumOptionsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *instructionsCell;
@property (retain, nonatomic) NSString* selectedImageURL;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell;
@property (weak, nonatomic) IBOutlet UIButton *camera_outlet;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) NSArray *currentItemToEdit;
@property (retain,nonatomic) NSIndexPath *selectedImageIndex;
@property (nonatomic) BOOL startingFromHighlightedImage;
@property (nonatomic)NSInteger selectedRow;
@property (nonatomic)NSInteger selectedSection;
@property (weak, nonatomic) IBOutlet NonCopyPasteTextField *Retouching_TextField;
@property (weak, nonatomic) IBOutlet UITextField *Instructions_TextField;
@property (weak, nonatomic) IBOutlet NonCopyPasteTextField *For_Aluminum_TextField;
@property (weak, nonatomic) IBOutlet NonCopyPasteTextField *Product_Outlet;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NonCopyPasteTextField *Quantity_TextField;
@end
