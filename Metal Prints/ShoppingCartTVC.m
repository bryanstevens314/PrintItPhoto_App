//
//  ShoppingCartTVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 4/25/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "ShoppingCartTVC.h"
#import "CartTVCCell.h"
#import "AppDelegate.h"

@interface ShoppingCartTVC (){
    int cartTotal;
}
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) NSIndexPath *editingImageIndexPath;
@property (nonatomic, retain) NSMutableArray *cellArray;
@property (nonatomic, retain) NSMutableArray *cellPriceArray;
@property (retain, nonatomic) UIToolbar* keyboardDoneButtonView;
@end

@implementation ShoppingCartTVC


- (NSString*)archivePathShoppingCart{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"Cart"];
}


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Check Out" style:UIBarButtonItemStylePlain target:self action:@selector(EnterShipping)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [self.navigationItem setTitle:@"ShoppingCart"];
    
    CGRect rect = self.toolBar.frame;
    rect.origin.y = MIN(0, [[self navigationController] navigationBar].bounds.size.height);
    self.toolBar.frame = rect;


    
    //[self.navigationController setToolbarHidden:NO animated:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear{
    NSLog(@"ViewWillAppear");
    int cartPrice1 = 0;
    for (NSArray *array in [self sharedAppDelegate].shoppingCart) {
        
        NSString *quan = [array objectAtIndex:1];
        
        NSString *price= [array objectAtIndex:2];
        int price1 = [quan intValue] * [price intValue];
        cartPrice1 = cartPrice1 + price1;
        NSLog(@"Total Price: $%i",cartPrice1);
    }
    self.total_Outlet.title = [NSString stringWithFormat:@"$%i",cartPrice1];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSLog(@"ViewDidAppear");
    self.cellPriceArray = nil;
    if ([self sharedAppDelegate].newCartItem == YES) {
        [self sharedAppDelegate].newCartItem = NO;
        [self.tableView reloadData];
    }
    //[self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)EnterShipping {
    BOOL edited = false;
    NSInteger i = 0;
    NSMutableArray *newShoppingCart = [[NSMutableArray alloc] init];
    //NSLog(@"%@",[self sharedAppDelegate].shoppingCart);
    for (NSArray *arr in [self sharedAppDelegate].shoppingCart) {

        NSString *prod = [arr objectAtIndex:0];

        NSString *quan = [arr objectAtIndex:1];

        NSString *price= [arr objectAtIndex:2];
//        int priceInt = [price intValue];
//        int quanInt = [quan intValue];
//        int total = priceInt * quanInt;
        NSString *alumOpt = [arr objectAtIndex:4];
        NSString *retouch = [arr objectAtIndex:3];
        NSString *instruct = [arr objectAtIndex:5];
        NSString *imgURL = [arr objectAtIndex:6];
        NSString *imgTypeFrame = [arr objectAtIndex:7];
        NSIndexPath *inPath = [NSIndexPath indexPathForRow:i inSection:0];
        CartTVCCell *cell = [self.tableView cellForRowAtIndexPath:inPath];
        if (![prod isEqualToString:cell.product_textField.text]) {
            if (!edited) {
                edited = true;
            }
            prod = cell.product_textField.text;
        }
        if (![alumOpt isEqualToString:cell.aluminum_textField.text]) {
            if (!edited) {
                edited = true;
            }
            alumOpt = cell.aluminum_textField.text;
        }
        if (![retouch isEqualToString:cell.retouch_textField.text]) {
            if (!edited) {
                edited = true;
            }
            retouch = cell.retouch_textField.text;
        }
        if (![instruct isEqualToString:cell.instructions_TextView.text]) {
            if (!edited) {
                edited = true;
            }
            instruct = cell.instructions_TextView.text;
        }
        if (![quan isEqualToString:cell.quantity_TextField.text]) {
            if (!edited) {
                edited = true;
            }
            quan = cell.quantity_TextField.text;
        }
        if (![price isEqualToString:cell.total_Price.text]) {
            if (!edited) {
                edited = true;
            }
            price = cell.total_Price.text;
        }
        //NSString *imgString1 = [UIImageJPEGRepresentation(cell.imgView.image, 0.0f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        if (![imgURL isEqualToString:cell.imgViewURL]) {
            if (!edited) {
                edited = true;
            }
            imgURL = cell.imgViewURL;
        }
        if (![imgTypeFrame isEqualToString:cell.imgType]) {
            if (!edited) {
                edited = true;
            }
            if (cell.imgView.frame.size.width < cell.imgView.frame.size.height) {
                NSLog(@"<");
                imgTypeFrame = @"<";
            }
            if (cell.imgView.frame.size.width > cell.imgView.frame.size.height) {
                NSLog(@">");
                imgTypeFrame = @">";
            }
            if (cell.imgView.frame.size.width == cell.imgView.frame.size.height) {
                NSLog(@"=");
                imgTypeFrame = @"=";
            }
        }
        

//        NSArray *array = @[self.Product_Outlet.text,
//                           self.Quantity_TextField.text,
//                           price,
//                           self.Retouching_TextField.text,
//                           self.For_Aluminum_TextField.text,
//                           self.textView.text,
//                           imgString
//                           ];

//        [newShoppingCart addObject:newShopItem];
        
        i++;
        if (edited) {
            NSArray *newShopItem = @[prod,
                                     quan,
                                     price,
                                     retouch,
                                     alumOpt,
                                     instruct,
                                     imgURL,
                                     imgTypeFrame];

            [[self sharedAppDelegate].shoppingCart replaceObjectAtIndex:inPath.row withObject:newShopItem];
        }
    }
//    if (edited) {
//        //NSLog(@"%@",[self sharedAppDelegate].shoppingCart);
//        [self sharedAppDelegate].shoppingCart = nil;
//        [self sharedAppDelegate].shoppingCart = newShoppingCart;
//        
//    }

    
    [self performSegueWithIdentifier:@"StartShipping" sender:self];
}

- (void)pickerDoneClicked1:(id)sender {
    
    CartTVCCell *cell = [self.cellArray objectAtIndex:self.editingImageIndexPath.row];
    [self.keyboardDoneButtonView removeFromSuperview];
    
    
    if ([cell.quantity_TextField isFirstResponder]) {
        [cell.quantity_TextField resignFirstResponder];
        NSArray *array = [[self sharedAppDelegate].shoppingCart objectAtIndex:self.editingImageIndexPath.row];
        int price = [[array objectAtIndex:2] intValue];
        int quan = [cell.quantity_TextField.text intValue];
        NSLog(@"%i",quan);
        NSLog(@"%i",[[array objectAtIndex:1] intValue]);
        int total = price * quan;
        if (quan != [[array objectAtIndex:1] intValue]) {
            int sub = quan - [[array objectAtIndex:1] intValue];
            NSLog(@"%i",sub);

            if (sub < 0) {
                NSLog(@"subtracting");
                int x = abs(sub);
                int totalToSubtract = x * price;
                NSString *stringWithoutSpaces = [self.total_Outlet.title
                                                 stringByReplacingOccurrencesOfString:@"$" withString:@""];
                int newtotal = [stringWithoutSpaces intValue] - totalToSubtract;
                self.total_Outlet.title = [NSString stringWithFormat:@"$%i",newtotal];
            }
            if (sub >= 0) {
                NSLog(@"adding");
                int totalToSubtract = sub * price;
                NSString *stringWithoutSpaces = [self.total_Outlet.title
                                                 stringByReplacingOccurrencesOfString:@"$" withString:@""];
                int newtotal = [stringWithoutSpaces intValue] + totalToSubtract;
                self.total_Outlet.title = [NSString stringWithFormat:@"$%i",newtotal];
            }
        }
        cell.total_Price.text = [NSString stringWithFormat:@"$%i",total];
        
        [self.cellPriceArray replaceObjectAtIndex:self.editingImageIndexPath.row withObject:[NSString stringWithFormat:@"%i",total]];
        int cartTotal = 0;
        for (NSString *price in self.cellPriceArray){
            cartTotal = cartTotal + [price intValue];
        }
        cell.total_Price.text = [NSString stringWithFormat:@"$%i",total];
        NSArray *newArray = @[[array objectAtIndex:0],
                              cell.quantity_TextField.text,
                              [array objectAtIndex:2],
                              [array objectAtIndex:3],
                              [array objectAtIndex:4],
                              [array objectAtIndex:5],
                              [array objectAtIndex:6],
                              [array objectAtIndex:7]];
        
        [[self sharedAppDelegate].shoppingCart replaceObjectAtIndex:self.editingImageIndexPath.row withObject:newArray];
        [NSKeyedArchiver archiveRootObject:[self sharedAppDelegate].shoppingCart toFile:[self archivePathShoppingCart]];

    }

    
    
    self.editingImageIndexPath = nil;

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%lu",(unsigned long)[self sharedAppDelegate].shoppingCart.count);
    return [self sharedAppDelegate].shoppingCart.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartTVCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell" forIndexPath:indexPath];
    NSArray *array = [[self sharedAppDelegate].shoppingCart objectAtIndex:indexPath.row];
    if (!self.cellArray) {
        self.cellArray = [[NSMutableArray alloc] init];
        self.cellPriceArray = [[NSMutableArray alloc] init];
    }

    if (!self.keyboardDoneButtonView) {
        self.keyboardDoneButtonView = [[UIToolbar alloc] init];
        self.keyboardDoneButtonView.barStyle = UIBarStyleDefault;
        self.keyboardDoneButtonView.translucent = YES;
        self.keyboardDoneButtonView.tintColor = nil;
        [self.keyboardDoneButtonView sizeToFit];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(pickerDoneClicked1:)];
        
        [self.keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexSpace,doneButton, nil]];
    }

//    NSArray *array = @[self.Product_Outlet.text,
//                       self.Quantity_TextField.text,
//                       price,
//                       self.Retouching_TextField.text,
//                       self.For_Aluminum_TextField.text,
//                       self.textView.text,
//                       imgString
//                       ];
    cell.product.text = [array objectAtIndex:0];
    cell.quantity_TextField.text = [array objectAtIndex:1];
    cell.retouch_Outlet.text = [array objectAtIndex:3];
    cell.aluminum_Outlet.text = [array objectAtIndex:4];
    cell.instructions_TextView.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    cell.instructions_TextView.layer.borderWidth = 1.0; // set borderWidth as you want.
    cell.instructions_TextView.editable = NO;
    if ([[array objectAtIndex:5] isEqualToString:@""]) {
        
        cell.instructions_TextView.text = @"No Instructions";
    }
    else{
        cell.instructions_TextView.text = [array objectAtIndex:5];
    }
    
    int price = [[array objectAtIndex:2] intValue];
    int quan = [[array objectAtIndex:1] intValue];
    int total = price * quan;
    cartTotal = cartTotal + total;
    cell.total_Price.text = [NSString stringWithFormat:@"$%i",total];
    NSLog(@"%i",total);
    if ([self sharedAppDelegate].shoppingCart.count == indexPath.row+1) {
        NSLog(@"Done loading table");
        self.total_Outlet.title = [NSString stringWithFormat:@"$%i",cartTotal];
    }
    
    
    
//    NSData *data = [[NSData alloc]initWithBase64EncodedString:[array objectAtIndex:6] options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    UIImage *image1 = [UIImage imageWithData:data];
    
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSArray *cartArray = [[self sharedAppDelegate].shoppingCart objectAtIndex:indexPath.row];
    [library assetForURL:[cartArray objectAtIndex:6]
             resultBlock:^(ALAsset *asset) {
                 UIImage *thumbImg = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                 //UIImage *fullImg = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                 //                 if (self.collectionImgView) {
                 //                     self.collectionImgView = nil;
                 //                 }
//                 int setNewWidth = 0;
//                 int setNewHeight = 0;
//                 if (thumbImg.size.width/3 < cell.contentView.frame.size.width-10) {
//                     setNewWidth = thumbImg.size.width/3 - 10;
//                 }
//                 else{
//                     setNewWidth = thumbImg.size.width/3;
//                 }
//                 if (thumbImg.size.height/3 < cell.contentView.frame.size.height-10) {
//                     setNewHeight = thumbImg.size.height/3 - 10;
//                 }
//                 else{
//                     setNewHeight = thumbImg.size.height/3;
//                 }
                 

                 if (thumbImg.size.width < thumbImg.size.height) {
                     NSLog(@"<");
                     cell.imgType = @"<";
                 }
                 if (thumbImg.size.width > thumbImg.size.height) {
                     NSLog(@">");
                     cell.imgType = @">";
                 }
                 if (thumbImg.size.width == thumbImg.size.height) {
                     NSLog(@"=");
                     cell.imgType = @"=";
                 }

                 cell.imgViewURL = [cartArray objectAtIndex:6];
                 [cell.imgView setFrame:CGRectMake(10, 29, thumbImg.size.width/3, thumbImg.size.height/3)];
                 cell.imgView.layer.cornerRadius = 6.0; // set cornerRadius as you want.
                 //[cell.imgView setCenter:CGPointMake(cell.imgView.frame.origin.x, cell.bounds.size.height/3)];
                 [cell.imgView setImage:thumbImg];
//                 UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//                 
//                 
//                 tapGesture.numberOfTapsRequired = 1;
//                 tapGesture.cancelsTouchesInView = NO;
//                 cell.imgView.userInteractionEnabled = YES;
//                 [cell.imgView addGestureRecognizer:tapGesture];

                 [cell.contentView addSubview:cell.imgView];
                 
                 NSLog(@"Got to here %@",thumbImg);
             }
     
            failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
    
    int instuctionCenterY = cell.imgView.frame.origin.x + cell.imgView.frame.size.height + 30;
    [cell.instructions_TextView setFrame:CGRectMake(0, instuctionCenterY, cell.frame.size.width - 38, 55)];
    [cell.instructions_TextView setCenter:CGPointMake(cell.bounds.size.width/2, instuctionCenterY + cell.instructions_TextView.bounds.size.height/2)];
    cell.instructions_TextView.inputAccessoryView = self.keyboardDoneButtonView;
    cell.instructions_TextView.tag = indexPath.row;
    cell.instructions_TextView.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    cell.instructions_TextView.layer.borderWidth = 1.0; // set borderWidth as you want.
    [cell.instructionsOutlet setFrame:CGRectMake(cell.frame.size.width - 120 , cell.instructions_TextView.frame.origin.y - 21, 91, 21)];
    [cell.instructionsOutlet setTextColor:[UIColor blackColor]];
    cell.instructionsOutlet.text = @"Instructions";
    
    [cell.contentView addSubview:cell.instructionsOutlet];
    [cell.contentView addSubview:cell.instructions_TextView];
    
    cell.quantity_TextField.inputAccessoryView = self.keyboardDoneButtonView;
    cell.quantity_TextField.tag = indexPath.row;

        [self.cellArray addObject:cell];
//    if ([self sharedAppDelegate].shoppingCart.count == indexPath.row+1) {
//        self.total_Outlet.title = [NSString stringWithFormat:@"%i",cartTotal];
//    }
//    if (image1.size.width < image1.size.height) {
//        NSLog(@"<");
//        cell.imageSizeType = @"<";
//        cell.instructions_TextView = [[UITextView alloc] initWithFrame:CGRectMake(23, 159, 337, 55)];
//        cell.instructions_TextView.inputAccessoryView = self.keyboardDoneButtonView;
//        cell.instructions_TextView.tag = indexPath.row;
//        cell.instructions_TextView.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
//        cell.instructions_TextView.layer.borderWidth = 1.0; // set borderWidth as you want.
//        cell.instructionsOutlet = [[UILabel alloc] initWithFrame:CGRectMake(269, 124, 91, 55)];
//        [cell.instructionsOutlet setTextColor:[UIColor blackColor]];
//        cell.instructionsOutlet.text = @"Instructions";
//
//        [cell addSubview:cell.instructionsOutlet];
//        [cell addSubview:cell.instructions_TextView];
//        cell.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 93.75, 125)];
//    }
//    if (image1.size.width > image1.size.height) {
//        NSLog(@">");
//        cell.imageSizeType = @">";
//        cell.instructions_TextView = [[UITextView alloc] initWithFrame:CGRectMake(23, 125, 337, 55)];
//        cell.instructions_TextView.inputAccessoryView = self.keyboardDoneButtonView;
//        cell.instructions_TextView.tag = indexPath.row;
//        cell.instructions_TextView.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
//        cell.instructions_TextView.layer.borderWidth = 1.0; // set borderWidth as you want.
//        cell.instructionsOutlet = [[UILabel alloc] initWithFrame:CGRectMake(269, 85, 91, 55)];
//        [cell.instructionsOutlet setTextColor:[UIColor blackColor]];
//        cell.instructionsOutlet.text = @"Instructions";
//        
//        [cell addSubview:cell.instructionsOutlet];
//        [cell addSubview:cell.instructions_TextView];
//        cell.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 36, 101, 76)];
//    }
//    if (image1.size.width == image1.size.height) {
//        NSLog(@"=");
//        cell.imageSizeType = @"=";
//        
//        cell.instructions_TextView = [[UITextView alloc] initWithFrame:CGRectMake(19, 160, 337, 55)];
//        cell.instructions_TextView.inputAccessoryView = self.keyboardDoneButtonView;
//        cell.instructions_TextView.tag = indexPath.row;
//        cell.instructions_TextView.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
//        cell.instructions_TextView.layer.borderWidth = 1.0; // set borderWidth as you want.
//        cell.instructionsOutlet = [[UILabel alloc] initWithFrame:CGRectMake(269, 116, 91, 55)];
//        [cell.instructionsOutlet setTextColor:[UIColor blackColor]];
//        cell.instructionsOutlet.text = @"Instructions";
//        
//        [cell addSubview:cell.instructionsOutlet];
//        [cell addSubview:cell.instructions_TextView];
//        cell.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 31, 100, 100)];
//    }
    //Initialization

    
    
    //    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    //    tapGesture.numberOfTapsRequired = 1;
    //    tapGesture.cancelsTouchesInView = NO;
    //    self.Addimage.userInteractionEnabled = YES;
    //    [self.Addimage addGestureRecognizer:tapGesture];
    //chosePic = YES;
    //[cell.imgView setImage:image1];
    
    //[cell.contentView addSubview:cell.imgView];
    
//    if (self.selectedSection == 0) {
//        self.rowCount = 6;
//        
//        integer = self.selectedRow;
//        NSArray *array = [[self sharedAppDelegate].AluminumProductArray objectAtIndex:self.selectedRow];
//        self.Product_Outlet.text = [array objectAtIndex:0];
//    }
//    if (self.selectedSection == 1) {
//        self.rowCount = 5;
//        self.aluminumOptionsCell.hidden = YES;
//        //        NSLog(@"Section 1");
//        integer = self.selectedRow+10;
//        NSArray *array = [[self sharedAppDelegate].WoodenProductArray objectAtIndex:self.selectedRow];
//        self.Product_Outlet.text = [array objectAtIndex:0];
//    }

///////////Product Picker///////////
//    [[cell product_textField] setTintColor:[UIColor clearColor]];
//    cell.productPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 200)];
//    cell.productPicker.tag = indexPath.row;
//    [cell.productPicker setDataSource: self];
//    [cell.productPicker setDelegate: self];
//    cell.productPicker.showsSelectionIndicator = YES;
//    //[cell.productPicker selectRow:integer inComponent:0 animated:NO];
//    cell.product_textField.inputView = cell.productPicker;
//    cell.product_textField.adjustsFontSizeToFitWidth = YES;
//    cell.product_textField.textColor = [UIColor blackColor];
//    cell.product_textField.inputAssistantItem.leadingBarButtonGroups = @[];
//    cell.product_textField.inputAssistantItem.trailingBarButtonGroups = @[];
//    cell.product_textField.inputAccessoryView = self.keyboardDoneButtonView;
//    cell.product_textField.text = [array objectAtIndex:0];
//    

//
///////////Instructions Input//////////
//    cell.instructions_TextView.layer.borderWidth = 1.0f;
//    cell.instructions_TextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    cell.instructions_TextView.inputAccessoryView = self.keyboardDoneButtonView;
//    if ([[array objectAtIndex:5] isEqualToString:@""]) {
//        
//        cell.instructions_TextView.text = @"No Instructions";
//    }
//    else{
//        cell.instructions_TextView.text = [array objectAtIndex:5];
//    }
//    
///////////Aluminum Options Picker/////////
//    [[cell aluminum_textField] setTintColor:[UIColor clearColor]];
//    cell.easelPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 200)];
//    
//    [cell.easelPicker setDataSource: self];
//    [cell.easelPicker setDelegate: self];
//    cell.easelPicker.showsSelectionIndicator = YES;
//    cell.easelPicker.tag = indexPath.row;
//    cell.aluminum_textField.inputView = cell.easelPicker;
//    cell.aluminum_textField.adjustsFontSizeToFitWidth = YES;
//    cell.aluminum_textField.textColor = [UIColor blackColor];
//    cell.aluminum_textField.text = [array objectAtIndex:4];
//    if ([[array objectAtIndex:4] isEqualToString:@"Easel"]) {
//        [cell.easelPicker selectRow:0 inComponent:0 animated:NO];
//    }
//    if ([[array objectAtIndex:4] isEqualToString:@"Wall mount"]) {
//        [cell.easelPicker selectRow:1 inComponent:0 animated:NO];
//    }
//
//    cell.aluminum_textField.inputAccessoryView = self.keyboardDoneButtonView;
//
////////////Retouching Options Picker/////////
//    [[cell retouch_textField] setTintColor:[UIColor clearColor]];
//    cell.retouchPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 200)];
//    cell.retouchPicker.tag = indexPath.row;
//    [cell.retouchPicker  setDataSource: self];
//    [cell.retouchPicker  setDelegate: self];
//    cell.retouchPicker .showsSelectionIndicator = YES;
//    cell.retouch_textField.inputView = cell.retouchPicker ;
//    cell.retouch_textField.adjustsFontSizeToFitWidth = YES;
//    cell.retouch_textField.textColor = [UIColor blackColor];
//    
//    cell.retouch_textField.text = [array objectAtIndex:3];
//    if ([[array objectAtIndex:3] isEqualToString:@"No retouching"]) {
//        [cell.retouchPicker selectRow:0 inComponent:0 animated:NO];
//    }
//    if ([[array objectAtIndex:3] isEqualToString:@"Crop to fit product"]) {
//        [cell.retouchPicker selectRow:1 inComponent:0 animated:NO];
//    }
//    if ([[array objectAtIndex:3] isEqualToString:@"Improve it for me"]) {
//        [cell.retouchPicker selectRow:2 inComponent:0 animated:NO];
//    }
//    if ([[array objectAtIndex:3] isEqualToString:@"Follow my instructions"]) {
//        [cell.retouchPicker selectRow:3 inComponent:0 animated:NO];
//    }
//    
//    cell.retouch_textField.inputAccessoryView = self.keyboardDoneButtonView;
//cell.retouch_textField.text = [NSString stringWithFormat:@"%@",[array objectAtIndex:3]];

    


    
    

    
    return cell;
}

NSArray *currentItem;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.editingImageIndexPath = indexPath;
    currentItem = [[self sharedAppDelegate].shoppingCart objectAtIndex:indexPath.row];

    [self performSegueWithIdentifier:@"EditCartItem" sender:self];
    NSLog(@"");
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == [self sharedAppDelegate].shoppingCart.count-1){
        
        //end of loading
//        int cartTotal = 0;
//        for (NSString *price in self.cellPriceArray){
//            cartTotal = cartTotal + [price intValue];
//            
//        }
//        self.total_Outlet.title = [NSString stringWithFormat:@"$%i",cartTotal];
//        [self sharedAppDelegate].cartTotal = [NSString stringWithFormat:@"%i",cartTotal];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat x = 0;
    //NSLog(@"%@",self.cellArray);
    NSArray *cart = [[self sharedAppDelegate].shoppingCart objectAtIndex:indexPath.row];
    if ([[cart objectAtIndex:7] isEqualToString:@"<"]) {
        x = 221;
    }
    if ([[cart objectAtIndex:7] isEqualToString:@">"]) {
        x = 191;
    }
    if ([[cart objectAtIndex:7] isEqualToString:@"="]) {
        x = 205;
    }
    return x;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *array = [[self sharedAppDelegate].shoppingCart objectAtIndex:indexPath.row];
        int price2 = [[array objectAtIndex:2] intValue];
        int newTotal = [self.total_Outlet.title intValue] - price2;
        self.total_Outlet.title = [NSString stringWithFormat:@"$%i",newTotal];
        [[self sharedAppDelegate].shoppingCart removeObjectAtIndex:indexPath.row];
        [NSKeyedArchiver archiveRootObject:[self sharedAppDelegate].shoppingCart toFile:[self archivePathShoppingCart]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    NSLog(@"Deleted row.");
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSIndexPath *path = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    self.editingImageIndexPath = path;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"!!");
    NSIndexPath *path = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    CartTVCCell *cell = [self.tableView cellForRowAtIndexPath:path];
    if (textField == cell.quantity_TextField) {
        NSArray *array = [[self sharedAppDelegate].shoppingCart objectAtIndex:self.editingImageIndexPath.row];
        int price = [[array objectAtIndex:2] intValue];
        int quan = [cell.quantity_TextField.text intValue];
        int total = price * quan;
        cell.total_Price.text = [NSString stringWithFormat:@"$%i",total];
        [self.cellPriceArray replaceObjectAtIndex:path.row withObject:[NSString stringWithFormat:@"%i",total]];
        int cartTotal = 0;
        for (NSString *price in self.cellPriceArray){
            cartTotal = cartTotal + [price intValue];
        }
        self.total_Outlet.title = [NSString stringWithFormat:@"$%i",cartTotal];
        [self sharedAppDelegate].cartTotal = [NSString stringWithFormat:@"%i",cartTotal];
        NSArray *newArray = @[[array objectAtIndex:0],
                              cell.quantity_TextField.text,
                              [array objectAtIndex:2],
                              [array objectAtIndex:3],
                              [array objectAtIndex:4],
                              [array objectAtIndex:5],
                              [array objectAtIndex:6]];
        
        [[self sharedAppDelegate].shoppingCart replaceObjectAtIndex:self.editingImageIndexPath.row withObject:newArray];
        [cell.quantity_TextField resignFirstResponder];
    }
    return YES;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:pickerView.tag inSection:0];
    CartTVCCell *cell = [self.tableView cellForRowAtIndexPath:path];
    
    NSInteger rows = 0;
    if (cell.aluminum_textField.inputView == pickerView) {
        NSLog(@"alum rows");
        rows = 2;
    }
    if (cell.retouchPicker.inputView == pickerView) {
        NSLog(@"retouch rows");
        rows = 4;
        
    }
    if (cell.productPicker.inputView == pickerView) {
        NSLog(@"product rows");
        rows = [self sharedAppDelegate].AluminumProductArray.count + [self sharedAppDelegate].WoodenProductArray.count;
    }
    return rows;
}


// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
    CartTVCCell *cell = [self.tableView cellForRowAtIndexPath:path];
    NSString *string;
    if (cell.aluminum_textField.inputView == pickerView) {
        
        if (row == 0) {
            string = @"Easel";
            NSLog(@"alum row 1");
        }
        if (row == 1) {
            string = @"Wall mount";
            NSLog(@"alum row 2");
        }
    }
    if (cell.retouchPicker.inputView == pickerView) {
        
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
    
    if (cell.productPicker.inputView == pickerView) {
        
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
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
    CartTVCCell *cell = [self.tableView cellForRowAtIndexPath:path];
    NSString *string;
    if (cell.aluminum_textField.inputView == pickerView) {
        
        if (row == 0) {
            string = @"Easel";
        }
        if (row == 1) {
            string = @"Wall mount";
        }
        cell.aluminum_textField.text = string;
    }
    if (cell.retouch_textField.inputView == pickerView) {
        
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
        cell.retouch_textField.text = string;
    }
    
    if (cell.product_textField.inputView == pickerView) {
        
        if (row <= 9) {
            
            NSArray *array = [[self sharedAppDelegate].AluminumProductArray objectAtIndex:row];
            string = [array objectAtIndex:0];
        }
        if (row >= 10) {
            
            NSArray *array = [[self sharedAppDelegate].WoodenProductArray objectAtIndex:row-10];
            string = [array objectAtIndex:0];
        }
        cell.product_textField.text = string;
    }
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
    
    [alert2 addAction:cameraAction];
    [alert2 addAction:libraryAction];
    [alert2 addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Called when user taps outside
    }]];
    [self presentViewController:alert2 animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",self.editingImageIndexPath);
    CartTVCCell *cell = [self.tableView cellForRowAtIndexPath:self.editingImageIndexPath];
    self.editingImageIndexPath = nil;
    UIImage *image;
    if (cell.imgView) {
        [cell.imgView removeFromSuperview];
        cell.imgView = nil;
    }
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    if (image.size.width < image.size.height) {
        NSLog(@"<");
        cell.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 40, 93.75, 125)];
    }
    if (image.size.width > image.size.height) {
        NSLog(@">");
        cell.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 48, 93, 70)];
    }
    if (image.size.width == image.size.height) {
        NSLog(@">");
        cell.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 44, 124, 124)];
    }
    //Initialization
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    cell.imgView.userInteractionEnabled = YES;
    [cell.imgView addGestureRecognizer:tapGesture];
    
    
    //    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    //    tapGesture.numberOfTapsRequired = 1;
    //    tapGesture.cancelsTouchesInView = NO;
    //    self.Addimage.userInteractionEnabled = YES;
    //    [self.Addimage addGestureRecognizer:tapGesture];
    //chosePic = YES;
    [cell.imgView setImage:image];
    [cell addSubview:cell.imgView];

    //self.image_View.hidden = NO;
}



-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditCartItem"]) {
        DetailsTVC *VC = segue.destinationViewController;
        if (currentItem != nil) {
            VC.currentItemToEdit = currentItem;
        }
        
    }
}


@end
