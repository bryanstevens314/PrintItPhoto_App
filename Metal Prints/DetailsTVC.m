//
//  DetailsTVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "DetailsTVC.h"
#import "AppDelegate.h"

@interface DetailsTVC ()
@property (retain, nonatomic) UIPickerView *picker1;
@property (retain, nonatomic) UIPickerView *picker2;
@property (retain, nonatomic) UIPickerView *picker3;
@property (retain, nonatomic) UIPickerView *picker4;
@property (retain, nonatomic) NSURL *selectedImageURL;
@property (retain, nonatomic) UIImage *selectedImage;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView* imgView ;
@property (retain, nonatomic) UIToolbar* keyboardDoneButtonView;
@property (nonatomic) NSInteger rowCount;
@end

@implementation DetailsTVC

- (NSString*)archivePathShoppingCart{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"Cart"];
}

- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


+ (DetailsTVC *)sharedDetailsTVCInstance
{
    static DetailsTVC *sharedInstance = nil;
    
    UIStoryboard *storyboard;
    
    // detect the height of our screen
    int height = [UIScreen mainScreen].bounds.size.height;
    
    if (height == 480) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_3.5_inch" bundle:nil];
        // NSLog(@"Device has a 3.5inch Display.");
    }
    if (height == 568) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_4_inch" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    if (height == 667) {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    if (height == 736) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_5.5_inch" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = (DetailsTVC*)[storyboard instantiateViewControllerWithIdentifier: @"details"];
    });
    return sharedInstance;
}



- (void)viewDidLoad {
    
    NSLog(@"!!");
    [super viewDidLoad];
    if (self.currentItemToEdit) {
        UIBarButtonItem *rightBarButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(PlaceOrder)];
        [self.navigationItem setRightBarButtonItem:rightBarButtonItem2];
    }
    else{
        UIBarButtonItem *rightBarButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"Add to Cart" style:UIBarButtonItemStylePlain target:self action:@selector(PlaceOrder)];
        [self.navigationItem setRightBarButtonItem:rightBarButtonItem2];
    }

    
    [self.navigationItem setTitle:@"Details"];
    self.Category_Outlet.text = [[self sharedAppDelegate].categoryArray objectAtIndex:self.selectedSection1];
    if (self.selectedSection1 == 0) {
        NSArray *array = [[self sharedAppDelegate].AluminumProductArray objectAtIndex:self.selectedRow];
        
        self.Product_Outlet.text = [array objectAtIndex:0];
        
        self.rowCount = [self sharedAppDelegate].AluminumProductArray.count;
    }
    if (self.selectedSection1 == 1) {
        [self.aluminumOptionsCell.contentView setAlpha:0.6];
        self.For_Aluminum_TextField.enabled = NO;
        self.For_Aluminum_TextField.text = @"";
//        self.aluminumOptionsCell.hidden = YES;
//        NSLog(@"Section 1");
        NSArray *array = [[self sharedAppDelegate].WoodenProductArray objectAtIndex:self.selectedRow];
        self.Product_Outlet.text = [array objectAtIndex:0];
        
        self.rowCount = [self sharedAppDelegate].WoodenProductArray.count;
    }
    if (self.selectedSection1 == 2) {
        [self.aluminumOptionsCell.contentView setAlpha:0.6];
        self.For_Aluminum_TextField.enabled = NO;
        self.For_Aluminum_TextField.text = @"";
        NSArray *array = [[self sharedAppDelegate].TileProductArray objectAtIndex:self.selectedRow];
        self.Product_Outlet.text = [array objectAtIndex:0];
        self.rowCount = [self sharedAppDelegate].TileProductArray.count;
    }
    if (self.selectedSection1 == 3) {
        [self.aluminumOptionsCell.contentView setAlpha:0.6];
        self.For_Aluminum_TextField.enabled = NO;
        self.For_Aluminum_TextField.text = @"";
        NSArray *array = [[self sharedAppDelegate].SlateProductArray objectAtIndex:self.selectedRow];
        self.Product_Outlet.text = [array objectAtIndex:0];
        self.rowCount = [self sharedAppDelegate].SlateProductArray.count;
    }
    [[self Product_Outlet] setTintColor:[UIColor clearColor]];
    self.picker3 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 200)];
    [self.picker3 setDataSource: self];
    [self.picker3 setDelegate: self];
    self.picker3.showsSelectionIndicator = YES;
    [self.picker3 selectRow:self.selectedRow inComponent:0 animated:NO];
    self.Product_Outlet.inputView = self.picker3;
    self.Product_Outlet.adjustsFontSizeToFitWidth = YES;
    self.Product_Outlet.textColor = [UIColor blackColor];
    self.Product_Outlet.inputAssistantItem.leadingBarButtonGroups = @[];
    self.Product_Outlet.inputAssistantItem.trailingBarButtonGroups = @[];
    
    self.picker4 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 200)];
    [self.picker4 setDataSource: self];
    [self.picker4 setDelegate: self];
    self.picker4.showsSelectionIndicator = YES;
    [self.picker4 selectRow:self.selectedSection1 inComponent:0 animated:NO];
    self.Category_Outlet.inputView = self.picker4;
    self.Category_Outlet.adjustsFontSizeToFitWidth = YES;
    self.Category_Outlet.textColor = [UIColor blackColor];
    self.Category_Outlet.inputAssistantItem.leadingBarButtonGroups = @[];
    self.Category_Outlet.inputAssistantItem.trailingBarButtonGroups = @[];
    
    self.keyboardDoneButtonView = [[UIToolbar alloc] init];
    self.keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    self.keyboardDoneButtonView.translucent = YES;
    self.keyboardDoneButtonView.tintColor = nil;
    [self.keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone target:self
                                                                   action:@selector(pickerDoneClicked:)];
    
    [self.keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexSpace,doneButton, nil]];
    self.Quantity_TextField.inputAccessoryView = self.keyboardDoneButtonView;
    self.textView.inputAccessoryView = self.keyboardDoneButtonView;
    self.Product_Outlet.inputAccessoryView = self.keyboardDoneButtonView;
    self.Category_Outlet.inputAccessoryView = self.keyboardDoneButtonView;
    
    [[self For_Aluminum_TextField] setTintColor:[UIColor clearColor]];
    self.picker1 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 200)];
    [self.picker1 setDataSource: self];
    [self.picker1 setDelegate: self];
    self.picker1.showsSelectionIndicator = YES;
    self.For_Aluminum_TextField.inputView = self.picker1;
    self.For_Aluminum_TextField.adjustsFontSizeToFitWidth = YES;
    self.For_Aluminum_TextField.textColor = [UIColor blackColor];
    self.For_Aluminum_TextField.text = @"Easel";
    self.For_Aluminum_TextField.inputAccessoryView = self.keyboardDoneButtonView;
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [[self Retouching_TextField] setTintColor:[UIColor clearColor]];
    self.picker2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 200)];
    [self.picker2 setDataSource: self];
    [self.picker2 setDelegate: self];
    self.picker2.showsSelectionIndicator = YES;
    self.Retouching_TextField.inputView = self.picker2;
    self.Retouching_TextField.adjustsFontSizeToFitWidth = YES;
    self.Retouching_TextField.textColor = [UIColor blackColor];
    self.Retouching_TextField.text = @"No retouching";
self.Retouching_TextField.inputAccessoryView = self.keyboardDoneButtonView;


}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSLog(@"will appear");
    if (self.currentItemToEdit != nil) {
        NSLog(@"current Item");
        self.Product_Outlet.text = [self.currentItemToEdit objectAtIndex:0];
        self.Quantity_TextField.text = [self.currentItemToEdit objectAtIndex:1];
        self.Retouching_TextField.text = [self.currentItemToEdit objectAtIndex:3];
        self.For_Aluminum_TextField.text = [self.currentItemToEdit objectAtIndex:4];
        self.textView.text = [self.currentItemToEdit objectAtIndex:5];
        NSString *selectedRowString = [self.currentItemToEdit objectAtIndex:8];
        self.selectedRow = [selectedRowString integerValue];
        [self.picker3 selectRow:self.selectedRow inComponent:0 animated:NO];
        
        NSString *selectedSectionString = [self.currentItemToEdit objectAtIndex:9];
        self.selectedSection1 = [selectedSectionString integerValue];
        
        [self.picker4 selectRow:self.selectedSection1 inComponent:0 animated:NO];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSURL *newImgURL = [NSURL URLWithString:[self.currentItemToEdit objectAtIndex:6]];
            [library assetForURL:newImgURL
                     resultBlock:^(ALAsset *asset) {
                         UIImage *thumbImg = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                         UIImage *fullImg = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                         self.image = fullImg;
                         //                 if (self.collectionImgView) {
                         //                     self.collectionImgView = nil;
                         //                 }
                         NSLog(@"%@",thumbImg);
                         if (self.imgView) {
                             self.imgView = nil;
                         }
                         NSIndexPath *indePath = [NSIndexPath indexPathForRow:0 inSection:0];
                         UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indePath];
                         float division = self.image.size.width/self.image.size.height;
                         self.imgView = [[UIImageView alloc] init];
                         if (self.image.size.width < self.image.size.height) {
                             NSLog(@"portrait");
                             
                             float newWidth = (cell.bounds.size.height - 39) * division;
                             [self.imgView setFrame:CGRectMake(0, 0, newWidth, cell.bounds.size.height - 39)];
                             int centerY = cell.bounds.size.height/2 + 10;
                             [self.imgView setCenter:CGPointMake(cell.bounds.size.width/2,centerY)];
                             self.imgView.image = self.image;
                         }
                         if (self.image.size.width > self.image.size.height) {
                             NSLog(@"landscape");
                             float newWidth = (cell.bounds.size.height - 65) * division;
                             [self.imgView setFrame:CGRectMake(0, 0, newWidth, cell.bounds.size.height - 65)];
                             int centerY = cell.bounds.size.height/2 + 10;
                             [self.imgView setCenter:CGPointMake(cell.bounds.size.width/2,centerY)];
                             self.imgView.image = self.image;
                         }
                         if (self.image.size.width == self.image.size.height) {
                             NSLog(@"square");
                             [self.imgView setFrame:CGRectMake(0, 0, cell.bounds.size.height - 65, cell.bounds.size.height - 65)];
                             [self.imgView setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2 + 7)];
                             self.imgView.image = self.image;
                         }
                         [self.view addSubview:self.imgView];
                         self.camera_outlet.hidden = YES;
                         if (self.imgView.gestureRecognizers == 0) {
                             UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                             
                             
                             tapGesture.numberOfTapsRequired = 1;
                             tapGesture.cancelsTouchesInView = NO;
                             self.imgView.userInteractionEnabled = YES;
                             [self.imgView addGestureRecognizer:tapGesture];
                         }
                     }
             
                    failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];

        //
        //        NSArray *array = @[self.Product_Outlet.text,
        //                           self.Quantity_TextField.text,
        //                           price,
        //                           self.Retouching_TextField.text,
        //                           self.For_Aluminum_TextField.text,
        //                           self.textView.text,
        //                           imgString,
        //                           imageSizeType1
        //                           ];
    }
    if (self.startingFromHighlightedImage == YES) {
        NSLog(@"got here");
        self.selectedImageURL = [self.currentImageArray objectAtIndex:0];
        if (self.currentImage) {
            self.image = self.currentImage;
        }
        else{
            self.image = [self.currentImageArray objectAtIndex:1];
        }
        NSLog(@"url:%@",self.selectedImageURL);
        NSLog(@"image: %@",self.image);
        //                 if (self.collectionImgView) {
        //                     self.collectionImgView = nil;
        //                 }
        if (self.imgView) {
            self.imgView = nil;
        }
        NSIndexPath *indePath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indePath];
        float division = self.image.size.width/self.image.size.height;
        if (self.imgView) {
            [self.imgView removeFromSuperview];
            self.imgView = nil;
        }
        self.imgView = [[UIImageView alloc] init];
        if (self.image.size.width < self.image.size.height) {
            NSLog(@"portrait");
            
            float newWidth = (cell.bounds.size.height - 39) * division;
            [self.imgView setFrame:CGRectMake(0, 0, newWidth, cell.bounds.size.height - 39)];
            int centerY = cell.bounds.size.height/2 + 10;
            [self.imgView setCenter:CGPointMake(cell.bounds.size.width/2,centerY)];
            self.imgView.image = self.image;
        }
        if (self.image.size.width > self.image.size.height) {
            NSLog(@"landscape");
            float newWidth = (cell.bounds.size.height - 65) * division;
            [self.imgView setFrame:CGRectMake(0, 0, newWidth, cell.bounds.size.height - 65)];
            int centerY = cell.bounds.size.height/2 + 10;
            [self.imgView setCenter:CGPointMake(cell.bounds.size.width/2,centerY)];
            self.imgView.image = self.image;
        }
        if (self.image.size.width == self.image.size.height) {
            NSLog(@"square");
            [self.imgView setFrame:CGRectMake(0, 0, cell.bounds.size.height - 65, cell.bounds.size.height - 65)];
            [self.imgView setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2 + 7)];
            self.imgView.image = self.image;
        }
        [self.view addSubview:self.imgView];
        NSLog(@"ImageView %@",self.imgView);
        self.camera_outlet.hidden = YES;
        
        if (self.imgView.gestureRecognizers == 0) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            
            
            tapGesture.numberOfTapsRequired = 1;
            tapGesture.cancelsTouchesInView = NO;
            self.imgView.userInteractionEnabled = YES;
            [self.imgView addGestureRecognizer:tapGesture];
        }

    }
}




- (void)pickerDoneClicked:(id)sender {
    [self.keyboardDoneButtonView removeFromSuperview];
    if ([self.Category_Outlet isFirstResponder]) {
        [self.Category_Outlet  resignFirstResponder];
    }
    if ([self.Product_Outlet isFirstResponder]) {
        [self.Product_Outlet  resignFirstResponder];
    }
    if ([self.Quantity_TextField isFirstResponder]) {
        [self.Quantity_TextField  resignFirstResponder];
    }
    if ([self.Retouching_TextField isFirstResponder]) {
        [self.Retouching_TextField  resignFirstResponder];
    }
    if ([self.For_Aluminum_TextField isFirstResponder]) {
        [self.For_Aluminum_TextField  resignFirstResponder];
    }
    if ([self.textView isFirstResponder]) {
        [self.textView  resignFirstResponder];
    }
    
}

- (void)PlaceOrder {
    if (!self.imgView.image) {
        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"Please Select a Photo"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [alert2 dismissViewControllerAnimated:YES completion:nil];
                                                               }]; // 2

        [alert2 addAction:cameraAction];
        
        [self presentViewController:alert2 animated:YES completion:nil];
    }
    else{
        NSString *price = @"";
        NSString *product = @"";
        NSArray *array;
        NSString *imgString = [UIImageJPEGRepresentation(self.image, 0.0f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        if (self.selectedSection1 == 0) {
            product = [NSString stringWithFormat:@"%@ %@",self.Product_Outlet.text, @"Aluminum"];
            NSInteger i = 0;
            for (NSArray *array in [self sharedAppDelegate].AluminumProductArray) {
                i++;
                if ([[array objectAtIndex:0] isEqualToString:self.Product_Outlet.text]) {
                    price = [array objectAtIndex:1];
                    [self sharedAppDelegate].cartTotal = [self sharedAppDelegate].cartTotal + ([price integerValue] * [self.Quantity_TextField.text integerValue]);
                    NSLog(@"%@2",price);
                }
            }
            if ([self.Retouching_TextField.text isEqualToString:@"Crop to fit product"]) {
                array = @[product,
                          self.Quantity_TextField.text,
                          price,
                          self.Retouching_TextField.text,
                          self.For_Aluminum_TextField.text,
                          self.textView.text,
                          [self.selectedImageURL absoluteString],
                          imgString,
                          [NSString stringWithFormat:@"%li",(long)self.selectedRow],
                          [NSString stringWithFormat:@"%li",(long)self.selectedSection1]
                          ];
            }
            else{
                array = @[product,
                          self.Quantity_TextField.text,
                          price,
                          @"",
                          self.For_Aluminum_TextField.text,
                          self.textView.text,
                          [self.selectedImageURL absoluteString],
                          imgString,
                          [NSString stringWithFormat:@"%li",(long)self.selectedRow],
                          [NSString stringWithFormat:@"%li",(long)self.selectedSection1]
                          ];
            }

        }
        
        if (self.selectedSection1 == 1) {
            product = [NSString stringWithFormat:@"%@ %@",self.Product_Outlet.text, @"Wood"];
            NSInteger i = 0;
            for (NSArray *array in [self sharedAppDelegate].WoodenProductArray) {
                i++;
                if ([[array objectAtIndex:0] isEqualToString:self.Product_Outlet.text]) {
                    price = [array objectAtIndex:1];
                    [self sharedAppDelegate].cartTotal = [self sharedAppDelegate].cartTotal + ([price integerValue] * [self.Quantity_TextField.text integerValue]);
                    NSLog(@"Price:%li",(long)[price integerValue]);
                    NSLog(@"Quantity:%li",[self.Quantity_TextField.text integerValue]);
                    NSLog(@"%@2",price);
                }
            }
            if ([self.Retouching_TextField.text isEqualToString:@"Crop to fit product"]) {
                array = @[product,
                          self.Quantity_TextField.text,
                          price,
                          self.Retouching_TextField.text,
                          @"",
                          self.textView.text,
                          [self.selectedImageURL absoluteString],
                          imgString,
                          [NSString stringWithFormat:@"%li",(long)self.selectedRow],
                          [NSString stringWithFormat:@"%li",(long)self.selectedSection1]
                          ];
            }
            else{
                array = @[product,
                          self.Quantity_TextField.text,
                          price,
                          @"",
                          @"",
                          self.textView.text,
                          [self.selectedImageURL absoluteString],
                          imgString,
                          [NSString stringWithFormat:@"%li",(long)self.selectedRow],
                          [NSString stringWithFormat:@"%li",(long)self.selectedSection1]
                          ];
            }
        }
        
        if (self.selectedSection1 == 2) {
            product = [NSString stringWithFormat:@"%@ %@",self.Product_Outlet.text, @"Tile"];
            NSInteger i = 0;
            for (NSArray *array in [self sharedAppDelegate].TileProductArray) {
                i++;
                if ([[array objectAtIndex:0] isEqualToString:self.Product_Outlet.text]) {
                    price = [array objectAtIndex:1];
                    [self sharedAppDelegate].cartTotal = [self sharedAppDelegate].cartTotal + ([price integerValue] * [self.Quantity_TextField.text integerValue]);
                    NSLog(@"%@2",price);
                }
            }
            if ([self.Retouching_TextField.text isEqualToString:@"Crop to fit product"]) {
                array = @[product,
                          self.Quantity_TextField.text,
                          price,
                          self.Retouching_TextField.text,
                          @"",
                          self.textView.text,
                          [self.selectedImageURL absoluteString],
                          imgString,
                          [NSString stringWithFormat:@"%li",(long)self.selectedRow],
                          [NSString stringWithFormat:@"%li",(long)self.selectedSection1]
                          ];
            }
            else{
                array = @[product,
                          self.Quantity_TextField.text,
                          price,
                          @"",
                          @"",
                          self.textView.text,
                          [self.selectedImageURL absoluteString],
                          imgString,
                          [NSString stringWithFormat:@"%li",(long)self.selectedRow],
                          [NSString stringWithFormat:@"%li",(long)self.selectedSection1]
                          ];
            }
        }
        
        
        
        if (self.selectedSection1 == 3) {
            product = [NSString stringWithFormat:@"%@ %@",self.Product_Outlet.text, @"Slate"];
            NSInteger i = 0;
            for (NSArray *array in [self sharedAppDelegate].SlateProductArray) {
                i++;
                if ([[array objectAtIndex:0] isEqualToString:self.Product_Outlet.text]) {
                    price = [array objectAtIndex:1];
                    [self sharedAppDelegate].cartTotal = [self sharedAppDelegate].cartTotal + ([price integerValue] * [self.Quantity_TextField.text integerValue]);
                    NSLog(@"%@2",price);
                }
            }
            if ([self.Retouching_TextField.text isEqualToString:@"Crop to fit product"]) {
                array = @[product,
                          self.Quantity_TextField.text,
                          price,
                          self.Retouching_TextField.text,
                          @"",
                          self.textView.text,
                          [self.selectedImageURL absoluteString],
                          imgString,
                          [NSString stringWithFormat:@"%li",(long)self.selectedRow],
                          [NSString stringWithFormat:@"%li",(long)self.selectedSection1]
                          ];
            }
            else{
                array = @[product,
                          self.Quantity_TextField.text,
                          price,
                          @"",
                          @"",
                          self.textView.text,
                          [self.selectedImageURL absoluteString],
                          imgString,
                          [NSString stringWithFormat:@"%li",(long)self.selectedRow],
                          [NSString stringWithFormat:@"%li",(long)self.selectedSection1]
                          ];
            }
        }
        
        if (self.selectedSection1 == 4) {
            product = [NSString stringWithFormat:@"%@",self.Product_Outlet.text];
            NSInteger i = 0;
            for (NSArray *array in [self sharedAppDelegate].OtherProductArray) {
                i++;
                if ([[array objectAtIndex:0] isEqualToString:self.Product_Outlet.text]) {
                    price = [array objectAtIndex:1];
                    [self sharedAppDelegate].cartTotal = [self sharedAppDelegate].cartTotal + ([price integerValue] * [self.Quantity_TextField.text integerValue]);
                    NSLog(@"%@2",price);
                }
            }
            if ([self.Retouching_TextField.text isEqualToString:@"Crop to fit product"]) {
                array = @[product,
                          self.Quantity_TextField.text,
                          price,
                          self.Retouching_TextField.text,
                          @"",
                          self.textView.text,
                          [self.selectedImageURL absoluteString],
                          imgString,
                          [NSString stringWithFormat:@"%li",(long)self.selectedRow],
                          [NSString stringWithFormat:@"%li",(long)self.selectedSection1]
                          ];
            }
            else{
                array = @[product,
                          self.Quantity_TextField.text,
                          price,
                          @"",
                          @"",
                          self.textView.text,
                          [self.selectedImageURL absoluteString],
                          imgString,
                          [NSString stringWithFormat:@"%li",(long)self.selectedRow],
                          [NSString stringWithFormat:@"%li",(long)self.selectedSection1]
                          ];
            }
        }
        
        [self sharedAppDelegate].cartPrintTotal = [self sharedAppDelegate].cartPrintTotal + [self.Quantity_TextField.text integerValue];

        if (self.selectedImageIndex != nil) {
            if (![self sharedAppDelegate].imagesInCartArray) {
                [self sharedAppDelegate].imagesInCartArray = [[NSMutableArray alloc] init];
            }
            
            [[self sharedAppDelegate].imagesInCartArray addObject:self.selectedImageIndex];
        }
        [self sharedAppDelegate].newCartItem = YES;
        if (self.currentItemToEdit != nil) {
            [[self sharedAppDelegate].shoppingCart replaceObjectAtIndex:self.selectedRow withObject:array];
            [NSKeyedArchiver archiveRootObject:[self sharedAppDelegate].shoppingCart toFile:[self archivePathShoppingCart]];
            
            [self.delegate editedCartItem];
        }
        else{
            [[self sharedAppDelegate].shoppingCart addObject:array];
            [NSKeyedArchiver archiveRootObject:[self sharedAppDelegate].shoppingCart toFile:[self archivePathShoppingCart]];
            [self.delegate addedCartItem];
        }
        
        
        
        
        //[self performSegueWithIdentifier:@"PayForPrint" sender:self];
        // Dispose of any resources that can be recreated.
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.For_Aluminum_TextField) {
        if ([self.For_Aluminum_TextField.text isEqualToString:@""]) {
            self.For_Aluminum_TextField.text = @"Easel";
        }
        
    }
    if (textField == self.Retouching_TextField) {
        if ([self.Retouching_TextField.text isEqualToString:@""]) {
            self.Retouching_TextField.text = @"No retouching";
        }
    }
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger rows = 0;
    if (self.For_Aluminum_TextField.inputView == pickerView) {
        
        rows = 2;
    }
    if (self.Retouching_TextField.inputView == pickerView) {
        
        rows = 4;
        
    }
    if (self.Product_Outlet.inputView == pickerView) {
        if (self.selectedSection1 == 0) {
            rows = [self sharedAppDelegate].AluminumProductArray.count;
        }
        if (self.selectedSection1 == 1) {
            rows = [self sharedAppDelegate].WoodenProductArray.count;
        }
        if (self.selectedSection1 == 2) {
            rows = [self sharedAppDelegate].TileProductArray.count;
        }
        if (self.selectedSection1 == 3) {
            rows = [self sharedAppDelegate].SlateProductArray.count;
        }
    }
    if (self.Category_Outlet.inputView == pickerView) {
        rows = 5;
    }
    return rows;
}


// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"Title For row");
    NSString *string;
    if (self.For_Aluminum_TextField.inputView == pickerView) {
        
        if (row == 0) {
            string = @"Easel";
        }
        if (row == 1) {
            string = @"Wall mount";
        }
    }
    if (self.Retouching_TextField.inputView == pickerView) {
        
        if (row == 0) {
            string = @"No retouching";
        }
        if (row == 1) {
            string = @"Crop to fit product";
        }
        if (row == 2) {
            string = @"Improve it for me";
        }
        if (row == 3) {
            string = @"Follow my instructions";
        }

    }
    
    if (self.Product_Outlet.inputView == pickerView) {
        if (self.selectedSection1 == 0) {
            NSArray *array = [[self sharedAppDelegate].AluminumProductArray objectAtIndex:row];
            self.currentProductArray = array;
            string = [array objectAtIndex:0];
        }
        if (self.selectedSection1 == 1) {
            NSArray *array = [[self sharedAppDelegate].WoodenProductArray objectAtIndex:row];
            self.currentProductArray = array;
            string = [array objectAtIndex:0];
        }
        if (self.selectedSection1 == 2) {
            NSArray *array = [[self sharedAppDelegate].TileProductArray objectAtIndex:row];
            self.currentProductArray = array;
            string = [array objectAtIndex:0];
        }
        if (self.selectedSection1 == 3) {
            NSArray *array = [[self sharedAppDelegate].SlateProductArray objectAtIndex:row];
            self.currentProductArray = array;
            string = [array objectAtIndex:0];
        }
        if (self.selectedSection1 == 4) {
            NSArray *array = [[self sharedAppDelegate].OtherProductArray objectAtIndex:row];
            self.currentProductArray = array;
            string = [array objectAtIndex:0];
        }
        
    }
    
    if (pickerView == self.Category_Outlet.inputView) {
        
        string = [[self sharedAppDelegate].categoryArray objectAtIndex:row];
        
    }
    return string;
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Selected");
    
    NSString *string;
    if (self.For_Aluminum_TextField.inputView == pickerView) {
        
        if (row == 0) {
            string = @"Easel";
        }
        if (row == 1) {
            string = @"Wall mount";
        }
        self.For_Aluminum_TextField.text = string;
    }
    if (self.Retouching_TextField.inputView == pickerView) {
        
        if (row == 0) {
            string = @"No retouching";
        }
        if (row == 1) {
            string = @"Crop to fit product";
        }
        if (row == 2) {
            string = @"Improve it for me";
        }
        if (row == 3) {
            string = @"Follow my instructions";
        }
        self.Retouching_TextField.text = string;
    }
    
    if (self.Product_Outlet.inputView == pickerView) {
        
        if (self.selectedSection1 == 0) {
            NSArray *array = [[self sharedAppDelegate].AluminumProductArray objectAtIndex:row];
            self.currentProductArray = array;
            self.Product_Outlet.text = [array objectAtIndex:0];
        }
        if (self.selectedSection1 == 1) {
            NSArray *array = [[self sharedAppDelegate].WoodenProductArray objectAtIndex:row];
            self.currentProductArray = array;
            self.Product_Outlet.text = [array objectAtIndex:0];
        }
        if (self.selectedSection1 == 2) {
            NSArray *array = [[self sharedAppDelegate].TileProductArray objectAtIndex:row];
            self.currentProductArray = array;
            self.Product_Outlet.text = [array objectAtIndex:0];
        }
        if (self.selectedSection1 == 3) {
            NSArray *array = [[self sharedAppDelegate].SlateProductArray objectAtIndex:row];
            self.currentProductArray = array;
            self.Product_Outlet.text = [array objectAtIndex:0];
        }
        
    }
    
    if (self.Category_Outlet.inputView == pickerView) {
        self.Category_Outlet.text = [[self sharedAppDelegate].categoryArray objectAtIndex:row];

        self.selectedSection1 = row;
        
        if (row == 0) {
            NSArray *prodArray = [[self sharedAppDelegate].AluminumProductArray objectAtIndex:0];
            self.Product_Outlet.text = [prodArray objectAtIndex:0];
            if (self.aluminumOptionsCell.contentView.alpha == 0.6) {
                [self.aluminumOptionsCell.contentView setAlpha:1];
            }
        }
        
        if (row == 1) {
            NSArray *prodArray = [[self sharedAppDelegate].WoodenProductArray objectAtIndex:0];
            self.Product_Outlet.text = [prodArray objectAtIndex:0];
            if (self.aluminumOptionsCell.contentView.alpha == 1) {
                [self.aluminumOptionsCell.contentView setAlpha:0.6];
            }
        }
        
        if (row == 2) {
            NSArray *prodArray = [[self sharedAppDelegate].TileProductArray objectAtIndex:0];
            self.Product_Outlet.text = [prodArray objectAtIndex:0];
            if (self.aluminumOptionsCell.contentView.alpha == 1) {
                [self.aluminumOptionsCell.contentView setAlpha:0.6];
            }
        }
        
        if (row == 3) {
            NSArray *prodArray = [[self sharedAppDelegate].SlateProductArray objectAtIndex:0];
            self.Product_Outlet.text = [prodArray objectAtIndex:0];
            if (self.aluminumOptionsCell.contentView.alpha == 1) {
                [self.aluminumOptionsCell.contentView setAlpha:0.6];
            }
        }
        if (row == 4) {
            NSArray *prodArray = [[self sharedAppDelegate].OtherProductArray objectAtIndex:0];
            self.Product_Outlet.text = [prodArray objectAtIndex:0];
            if (self.aluminumOptionsCell.contentView.alpha == 1) {
                [self.aluminumOptionsCell.contentView setAlpha:0.6];
            }
        }
        
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.

     if ([segue.identifier isEqualToString:@"PayForPrint"]) {
         UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", returnbuttontitle) style:     UIBarButtonItemStyleBordered target:nil action:nil];
         self.navigationItem.backBarButtonItem = backButton;
     }
 }

- (IBAction)camera:(id)sender {
    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@""preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               [self camera1];
                                                           }]; // 2
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Choose Image"
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                [self library];
                                                            }]; // 2
    [cameraAction setValue:[[UIImage imageNamed:@"camera.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [libraryAction setValue:[[UIImage imageNamed:@"photo icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]   forKey:@"image"];
    
    [alert2 addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Called when user taps outside
    }]];
    [alert2 addAction:cameraAction];
    [alert2 addAction:libraryAction];
    
    [self presentViewController:alert2 animated:YES completion:nil];
    

}

-(void)cropImage{
    [self cropImage:self.imgView.image];
}

- (void)camera1
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePicker= [[UIImagePickerController alloc] init];
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //self.imagePicker.allowsEditing = YES;
        self.imagePicker.delegate = self;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
}



- (void)library{
    self.imagePicker = [[UIImagePickerController alloc] init];
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    //self.imagePicker.allowsEditing = YES;
    self.imagePicker.delegate = self;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


-(void)handleTap:(UIGestureRecognizer *)sender{
    
    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@""preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cropAction = [UIAlertAction actionWithTitle:@"Crop Image"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               [self cropImage];
                                                           }]; // 2
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               [self camera1];
                                                           }]; // 2
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Choose Image"
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                [self library];
                                                            }]; // 2
    
    [cropAction setValue:[[UIImage imageNamed:@"camera.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [cameraAction setValue:[[UIImage imageNamed:@"camera.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [libraryAction setValue:[[UIImage imageNamed:@"photo icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]   forKey:@"image"];
    [alert2 addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Called when user taps outside
    }]];
    
    [alert2 addAction:cropAction];
    [alert2 addAction:cameraAction];
    [alert2 addAction:libraryAction];
    
    [self presentViewController:alert2 animated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.image) {
        self.image =  nil;
    }
    if (self.imgView) {
        [self.imgView removeFromSuperview];
        self.imgView = nil;
    }
    if (self.selectedImageURL) {
        self.selectedImageURL = nil;
    }

    self.selectedImageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    //self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(146, 40, self.image.size.width/22, self.image.size.height/22)];
    
    NSIndexPath *indePath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indePath];
    
    float division = self.image.size.width/self.image.size.height;
    self.imgView = [[UIImageView alloc] init];
    if (self.image.size.width < self.image.size.height) {
        NSLog(@"portrait");
        
        float newWidth = (cell.bounds.size.height - 39) * division;
        [self.imgView setFrame:CGRectMake(0, 0, newWidth, cell.bounds.size.height - 39)];
        int centerY = cell.bounds.size.height/2 + 10;
        [self.imgView setCenter:CGPointMake(cell.bounds.size.width/2,centerY)];
        self.imgView.image = self.image;
    }
    if (self.image.size.width > self.image.size.height) {
        NSLog(@"landscape");
        float newWidth = (cell.bounds.size.height - 65) * division;
        [self.imgView setFrame:CGRectMake(0, 0, newWidth, cell.bounds.size.height - 65)];
        int centerY = cell.bounds.size.height/2 + 10;
        [self.imgView setCenter:CGPointMake(cell.bounds.size.width/2,centerY)];
        self.imgView.image = self.image;
    }
    if (self.image.size.width == self.image.size.height) {
        NSLog(@"square");
        [self.imgView setFrame:CGRectMake(0, 0, cell.bounds.size.height - 65, cell.bounds.size.height - 65)];
        [self.imgView setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2 + 7)];
        self.imgView.image = self.image;
    }
    [self.cell addSubview:self.imgView];
//    // Get size of current image
//    CGSize size = [self.image size];
//
//    // Create rectangle that represents a cropped image
//    // from the middle of the existing image
//    CGRect rect = CGRectMake(size.width / 4, size.height / 4 ,
//                             (size.width / 2), (size.height / 2));
//
//    // Create bitmap image from original image data,
//    // using rectangle to specify desired crop area
//    CGImageRef imageRef = CGImageCreateWithImageInRect([self.image CGImage], rect);
//    UIImage *img = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    
//    // Create and show the new image from bitmap data
//    self.imgView = [[UIImageView alloc] initWithImage:img];
//    [self.imgView setFrame:CGRectMake(0, 200, (size.width / 2), (size.height / 2))];
//    [[self view] addSubview:self.imgView];
    //Initialization

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        
        
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.cancelsTouchesInView = NO;
        self.imgView.userInteractionEnabled = YES;
        [self.imgView addGestureRecognizer:tapGesture];


    
    self.camera_outlet.hidden = YES;
}



-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)cropImage:(UIImage *)image{
    ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:image];
    controller.delegate = self;
    controller.blurredBackground = YES;
    UIImage *productImage = [self.currentProductArray objectAtIndex:2];
    float ratio1 = productImage.size.width/productImage.size.height;
    controller.ratio = ratio1;
    
    

    int cropHeight = self.view.frame.size.width*ratio1;
    [controller setCropArea:CGRectMake(0, 0, self.view.frame.size.width, cropHeight)];
    
    [[self navigationController] pushViewController:controller animated:YES];
}




- (void)ImageCropViewControllerSuccess:(UIViewController* )controller didFinishCroppingImage:(UIImage *)croppedImage{
    self.imgView.image = croppedImage;
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    //self.imgView.image = image;
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
