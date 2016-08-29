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

@class DetailsTVC;

@protocol DetailsTVCDelegate

- (void)editedCartItem;
-(void)addedCartItem;

@end

@interface DetailsTVC : UITableViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,ImageCropViewControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) id<DetailsTVCDelegate> delegate;

+ (DetailsTVC *)sharedDetailsTVCInstance;
- (IBAction)camera:(id)sender;
@property (weak, nonatomic) IBOutlet UITableViewCell *aluminumOptionsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *instructionsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell;
@property (weak, nonatomic) IBOutlet UIButton *camera_outlet;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) NSArray *currentItemToEdit;
@property (retain,nonatomic) NSIndexPath *selectedImageIndex;
@property (retain,nonatomic) UIImage *currentImage;
@property (retain,nonatomic) NSArray *currentImageArray;
@property (retain,nonatomic) NSArray *currentProductArray1;
@property (nonatomic) BOOL startingFromHighlightedImage;
@property (nonatomic)NSInteger selectedRow;
@property (nonatomic)NSInteger selectedSection1;
@property (weak, nonatomic) IBOutlet NonCopyPasteTextField *Retouching_TextField;
@property (weak, nonatomic) IBOutlet UITextField *Instructions_TextField;
@property (weak, nonatomic) IBOutlet NonCopyPasteTextField *For_Aluminum_TextField;
@property (weak, nonatomic) IBOutlet NonCopyPasteTextField *Product_Outlet;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NonCopyPasteTextField *Quantity_TextField;
@end
