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
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView* imgView ;
@property (retain, nonatomic) UIToolbar* keyboardDoneButtonView;
@property (nonatomic) int rowCount;
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
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add to Cart" style:UIBarButtonItemStylePlain target:self action:@selector(PlaceOrder)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [self.navigationItem setTitle:@"Details"];
    NSInteger integer = 0;
    if (self.selectedSection == 0) {
        self.rowCount = 6;
        
        integer = self.selectedRow;
        NSArray *array = [[self sharedAppDelegate].AluminumProductArray objectAtIndex:self.selectedRow];
        self.Product_Outlet.text = [array objectAtIndex:0];
    }
    if (self.selectedSection == 1) {
        [self.aluminumOptionsCell.contentView setAlpha:0.6];
        self.For_Aluminum_TextField.enabled = NO;
        self.For_Aluminum_TextField.text = @"";
        self.rowCount = 6;
//        self.aluminumOptionsCell.hidden = YES;
//        NSLog(@"Section 1");
        integer = self.selectedRow+10;
        NSArray *array = [[self sharedAppDelegate].WoodenProductArray objectAtIndex:self.selectedRow];
        self.Product_Outlet.text = [array objectAtIndex:0];
    }
    [[self Product_Outlet] setTintColor:[UIColor clearColor]];
    self.picker3 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 200)];
    [self.picker3 setDataSource: self];
    [self.picker3 setDelegate: self];
    self.picker3.showsSelectionIndicator = YES;
    [self.picker3 selectRow:integer inComponent:0 animated:NO];
    self.Product_Outlet.inputView = self.picker3;
    self.Product_Outlet.adjustsFontSizeToFitWidth = YES;
    self.Product_Outlet.textColor = [UIColor blackColor];
    
    self.Product_Outlet.inputAssistantItem.leadingBarButtonGroups = @[];
    self.Product_Outlet.inputAssistantItem.trailingBarButtonGroups = @[];
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
//        NSData *data = [[NSData alloc]initWithBase64EncodedString:[self.currentItemToEdit objectAtIndex:6] options:NSDataBase64DecodingIgnoreUnknownCharacters];
//        UIImage *image1 = [UIImage imageWithData:data];
//        if (self.image.size.width < self.image.size.height) {
//            NSLog(@"<");
//            self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(146, 40, 93.75, 125)];
//        }
//        if (self.image.size.width > self.image.size.height) {
//            NSLog(@">");
//            self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(108, 44, 158, 118.5)];
//        }
//        if (self.image.size.width == self.image.size.height) {
//            NSLog(@">");
//            self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(125, 41, 124, 124)];
//        }
        
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
                         self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, thumbImg.size.width/2, thumbImg.size.height/2)];
                         NSIndexPath *indePath = [NSIndexPath indexPathForRow:0 inSection:0];
                         UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indePath];
                         [self.imgView setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2-20)];
                         
                         [self.imgView setImage:thumbImg];
                         [self.view addSubview:self.imgView];
                         self.camera_outlet.hidden = YES;
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
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:[[self sharedAppDelegate].highlightedArray objectAtIndex:self.selectedImageIndex]
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
                     self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, thumbImg.size.width/2, thumbImg.size.height/2)];
                     NSIndexPath *indePath = [NSIndexPath indexPathForRow:0 inSection:0];
                     UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indePath];
                     [self.imgView setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2-20)];
                     
                     [self.imgView setImage:thumbImg];
                     [self.view addSubview:self.imgView];
                     self.camera_outlet.hidden = YES;
                 }
         
                failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];

    }
}




- (void)pickerDoneClicked:(id)sender {
    [self.keyboardDoneButtonView removeFromSuperview];
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
        NSInteger i = 0;
        for (NSArray *array in [self sharedAppDelegate].AluminumProductArray) {
            i++;
            if ([[array objectAtIndex:0] isEqualToString:self.Product_Outlet.text]) {
                price = [array objectAtIndex:1];
                NSLog(@"%@2",price);
            }
        }

        if ([price isEqualToString:@""]) {

            for (NSArray *array in [self sharedAppDelegate].WoodenProductArray) {
                i++;
                if ([[array objectAtIndex:0] isEqualToString:self.Product_Outlet.text]) {
                    price = [array objectAtIndex:1];
                }
            }
        }
        NSString *imageSizeType1;
        if (self.image.size.width < self.image.size.height) {
            NSLog(@"<");
            imageSizeType1 = @"<";
        }
        if (self.image.size.width > self.image.size.height) {
            NSLog(@">");
            imageSizeType1 = @">";
        }
        if (self.image.size.width == self.image.size.height) {
            NSLog(@"=");
            imageSizeType1 = @"=";
        }

        //[self.image setAccessibilityIdentifier:@"filename"] ;
        
        //NSString *imgString = [UIImageJPEGRepresentation(self.image, 0.0f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSArray *array = @[self.Product_Outlet.text,
                           self.Quantity_TextField.text,
                           price,
                           self.Retouching_TextField.text,
                           self.For_Aluminum_TextField.text,
                           self.textView.text,
                           self.selectedImageURL,imageSizeType1
                           ];
        if (self.selectedImageIndex != nil) {
            if (![self sharedAppDelegate].imagesInCartArray) {
                [self sharedAppDelegate].imagesInCartArray = [[NSMutableArray alloc] init];
            }
            
            [[self sharedAppDelegate].imagesInCartArray addObject:self.selectedImageIndex];
        }
        [self sharedAppDelegate].newCartItem = YES;
        [[self sharedAppDelegate].shoppingCart addObject:array];
        [NSKeyedArchiver archiveRootObject:[self sharedAppDelegate].shoppingCart toFile:[self archivePathShoppingCart]];
        [self.navigationController popViewControllerAnimated:YES];
        //[self performSegueWithIdentifier:@"PayForPrint" sender:self];
        // Dispose of any resources that can be recreated.
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowCount;
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
        rows = [self sharedAppDelegate].AluminumProductArray.count + [self sharedAppDelegate].WoodenProductArray.count;
    }
    return rows;
}


// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
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
        
        if (row <= 9) {
            
            NSArray *array = [[self sharedAppDelegate].AluminumProductArray objectAtIndex:row];
            string = [array objectAtIndex:0];
        }
        if (row >= 10) {
            NSArray *array = [[self sharedAppDelegate].WoodenProductArray objectAtIndex:row-10];
            string = [array objectAtIndex:0];
        }
    }
    return string;
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
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
        
        if (row <= 9) {
            if (!self.For_Aluminum_TextField.enabled) {
                self.aluminumOptionsCell.alpha = 1.0;
                self.For_Aluminum_TextField.enabled = YES;
            }

            NSArray *array = [[self sharedAppDelegate].AluminumProductArray objectAtIndex:row];
            string = [array objectAtIndex:0];
        }
        if (row >= 10) {
            if (self.For_Aluminum_TextField.enabled) {
                self.aluminumOptionsCell.alpha = 0.6;
                self.For_Aluminum_TextField.enabled = NO;
            }

            NSArray *array = [[self sharedAppDelegate].WoodenProductArray objectAtIndex:row-10];
            string = [array objectAtIndex:0];
        }
        self.Product_Outlet.text = string;
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
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    //self.imagePicker.allowsEditing = YES;
    self.imagePicker.delegate = self;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


-(void)handleTap:(UIGestureRecognizer *)sender{
    [self cropImage:self.imgView.image];
//    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@""preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo"
//                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                               [self camera1];
//                                                           }]; // 2
//    
//    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Choose Image"
//                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                                [self library];
//                                                            }]; // 2
//    [cameraAction setValue:[[UIImage imageNamed:@"camera.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
//    [libraryAction setValue:[[UIImage imageNamed:@"photo icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]   forKey:@"image"];
//    [alert2 addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        // Called when user taps outside
//    }]];
//    [alert2 addAction:cameraAction];
//    [alert2 addAction:libraryAction];
//    
//    [self presentViewController:alert2 animated:YES completion:nil];
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

    self.selectedImageURL = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    //self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(146, 40, self.image.size.width/22, self.image.size.height/22)];
    
    self.imgView.layer.cornerRadius = 6.0; // set cornerRadius as you want.
    if (self.image.size.width < self.image.size.height) {
        NSLog(@"Portrait");
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(146, 40, 93.75, 125)];
    }
    if (self.image.size.width > self.image.size.height) {

        NSLog(@"Landscape");
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(108, 44, 158, 118.5)];
        
    }
    if (self.image.size.width == self.image.size.height) {
        NSLog(@"Square");
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(125, 41, 124, 124)];
    }
    
    [self.imgView setCenter:CGPointMake(self.cell.bounds.size.width/2, self.cell.bounds.size.height/2)];
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
    
    
    //    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    //    tapGesture.numberOfTapsRequired = 1;
    //    tapGesture.cancelsTouchesInView = NO;
    //    self.Addimage.userInteractionEnabled = YES;
    //    [self.Addimage addGestureRecognizer:tapGesture];
    //chosePic = YES;
    [self.imgView setImage:self.image];
    [self.cell addSubview:self.imgView];
    
    self.camera_outlet.hidden = YES;
    //self.image_View.hidden = NO;
}



-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)cropImage:(UIImage *)image{
    ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:image];
    controller.delegate = self;
    controller.blurredBackground = YES;
    [controller setCropArea:CGRectMake(0, 0, image.size.width/2, image.size.height/2)];
    
    [[self navigationController] pushViewController:controller animated:YES];
}


- (void)ImageCropViewController:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{

    self.imgView.image = croppedImage;
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    //self.imgView.image = image;
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
