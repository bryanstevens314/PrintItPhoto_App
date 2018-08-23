//
//  ShoppingCartTVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 4/25/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "ShoppingCartTVC.h"

#import "AppDelegate.h"

#import "SWRevealViewController.h"

#import "OrderOverViewTVC.h"

@interface ShoppingCartTVC (){
    int cartTotal;
    BOOL edited;
}
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) NSIndexPath *editingImageIndexPath;
@property (nonatomic, retain) NSMutableArray *cellArray;
@property (nonatomic, retain) NSMutableArray *cellPriceArray;
@property (retain, nonatomic) UIToolbar* keyboardDoneButtonView;
@property (nonatomic) float originalOrigin;
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


+ (ShoppingCartTVC *)sharedShoppingCartTVC
{
    static ShoppingCartTVC *sharedInstance = nil;
    
    
    UIStoryboard *storyboard;
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    // detect the height of our screen
    //    int height = [UIScreen mainScreen].bounds.size.height;
    //
    //    if (height == 480) {
    //        storyboard = [UIStoryboard storyboardWithName:@"Main_3.5_inch" bundle:nil];
    //        // NSLog(@"Device has a 3.5inch Display.");
    //    }
    //    if (height == 568) {
    //        storyboard = [UIStoryboard storyboardWithName:@"Main_4_inch" bundle:nil];
    //        // NSLog(@"Device has a 4inch Display.");
    //    }
    //    if (height == 667) {
    //        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        // NSLog(@"Device has a 4inch Display.");
    //    }
    //    if (height == 736) {
    //        storyboard = [UIStoryboard storyboardWithName:@"Main_5.5_inch" bundle:nil];
    //        // NSLog(@"Device has a 4inch Display.");
    //    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = (ShoppingCartTVC*)[storyboard instantiateViewControllerWithIdentifier: @"Cart"];
    });
    return sharedInstance;
}

UIBarButtonItem *rightBarButtonItem6;

- (void)viewDidLoad {
    [super viewDidLoad];
//    rightBarButtonItem6 = [[UIBarButtonItem alloc] initWithTitle:@"Place Order" style:UIBarButtonItemStylePlain target:self action:@selector(EnterShipping)];
//    [self.navigationItem setRightBarButtonItem:rightBarButtonItem6];
    [self.navigationItem setTitle:@"Cart"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:0.6];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.alpha = 0.93;
    
    CGRect tableFrame = CGRectMake(0, 64, self.view.frame.size.width, self.view.bounds.size.height-64);
    self.tableView.frame = tableFrame;
    CGRect rect = self.toolBar.frame;
    rect.origin.y = MIN(0, [[self navigationController] navigationBar].bounds.size.height);
    self.toolBar.frame = rect;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    UIImage *background = [UIImage imageNamed:@"Hamburger_icon.svg.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(toggleReveal11) forControlEvents:UIControlEventTouchUpInside]; //adding action
    [button setBackgroundImage:background forState:UIControlStateNormal];
    button.frame = CGRectMake(0 ,0,35,30);
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    //[self.navigationController setToolbarHidden:NO animated:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self sharedAppDelegate].cartIsMainController = NO;
}
UIButton *proceedButton12;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    if ([self sharedAppDelegate].cartIsMainController == YES) {
        if (proceedButton12 == nil) {
            proceedButton12 = [UIButton buttonWithType:UIButtonTypeCustom];
            proceedButton12.frame = CGRectMake(0, 0, 353, 50);
            proceedButton12.layer.cornerRadius = 2;
            proceedButton12.clipsToBounds = YES;
            [proceedButton12 addTarget:self action:@selector(startShipping) forControlEvents:UIControlEventTouchUpInside];
            [proceedButton12 setTitle:@"Proceed with order" forState:UIControlStateNormal];
            proceedButton12.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:1];
            proceedButton12.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-35);
            self.originalOrigin = proceedButton12.frame.origin.y;
            [self.view insertSubview:proceedButton12 aboveSubview:self.view];
        }
        else{
            self.originalOrigin = proceedButton12.frame.origin.y;
            [self.view insertSubview:proceedButton12 aboveSubview:self.view];
        }
    }

    
    //self.tableView.contentInset = UIEdgeInsetsMake(64, 0, -64, 0);
}

// to make the button float over the tableView including tableHeader
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect tableBounds = self.tableView.bounds;
    CGRect floatingButtonFrame = proceedButton12.frame;
    floatingButtonFrame.origin.y = self.originalOrigin + tableBounds.origin.y;
    proceedButton12.frame = floatingButtonFrame;
    
    [self.view bringSubviewToFront:proceedButton12]; // float over the tableHeader
}



-(void)startShipping{
    [self performSegueWithIdentifier:@"StartOrder" sender:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if ([self sharedAppDelegate].newCartItem == YES) {
        [self sharedAppDelegate].newCartItem = NO;
        [self.tableView reloadData];
    }
    self.total_Outlet.title = [NSString stringWithFormat:@"$%li",(long)[self sharedAppDelegate].cartTotal];
    self.totalPrints.title = [NSString stringWithFormat:@"%li",(long)[self sharedAppDelegate].cartPrintTotal];


    //[self.tableView reloadData];
}



UITapGestureRecognizer *singleTap11;
-(void)toggleReveal11{
    //collView.collectionView.userInteractionEnabled = NO;
    singleTap11 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap11:)];
    singleTap11.numberOfTapsRequired = 1;
    [self.tableView  addGestureRecognizer:singleTap11];
    [self.revealViewController revealToggle];
}

-(void)SingleTap11:(UITapGestureRecognizer *)gesture{
    
    [self.revealViewController revealToggle];
    [self.tableView removeGestureRecognizer:singleTap11];
    singleTap11 = nil;
}

-(void)sendEmail
{
    
    Sendpulse* sendpulse = [[Sendpulse alloc] initWithUserIdandSecret:@"8663ca13cd9f05ef1f538f8d6295ff0e" :@"1af4a885aaaa45faa3ee21e763cc5667"];

    NSDictionary *from = [NSDictionary dictionaryWithObjectsAndKeys:@"Bryan Stevens", @"name", @"b.stevens.photo@gmail.com", @"email", nil];
    NSMutableArray* to = [[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Bryan Stevens", @"name", @"stevens_apps@yahoo.com", @"email", nil], nil];


    NSMutableDictionary *emaildata = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"html", @"", @"text",@"The Love Story Project",@"subject",from,@"from",to,@"to", nil];
    [sendpulse smtpSendMail:emaildata];
    
    
    
    
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
        [self sharedAppDelegate].cartPrintTotal = [self sharedAppDelegate].cartPrintTotal - beginningQuantity;
        [self sharedAppDelegate].cartPrintTotal = [self sharedAppDelegate].cartPrintTotal + quan;
        NSString *stringWithoutSpaces = [cell.total_Price.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
        [self sharedAppDelegate].cartTotal = [self sharedAppDelegate].cartTotal - [stringWithoutSpaces intValue];
        [self sharedAppDelegate].cartTotal = [self sharedAppDelegate].cartTotal + total;
        cell.total_Price.text = [NSString stringWithFormat:@"$%i",total];
        self.totalPrints.title = [NSString stringWithFormat:@"%li",(long)[self sharedAppDelegate].cartPrintTotal];
        self.total_Outlet.title = [NSString stringWithFormat:@"$%ld",(long)[self sharedAppDelegate].cartTotal];
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
        NSArray *array5 = @[[NSString stringWithFormat:@"%ld",(long)[self sharedAppDelegate].cartTotal], [NSString stringWithFormat:@"%ld",(long)[self sharedAppDelegate].cartPrintTotal]];
        [NSKeyedArchiver archiveRootObject:array5 toFile:[self archiveCartTotals]];

    }

    
    
    if (self.editingImageIndexPath) {
        self.editingImageIndexPath = nil;
    }

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%lu",(unsigned long)[self sharedAppDelegate].shoppingCart.count);
    NSInteger rows;
    if ([self sharedAppDelegate].shoppingCart.count > 3) {
        rows = [self sharedAppDelegate].shoppingCart.count + 1;
    }
    else{
        rows = [self sharedAppDelegate].shoppingCart.count;
    }
    return rows;
}

NSInteger numberOfPrints;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    CartTVCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row < [self sharedAppDelegate].shoppingCart.count ) {
        if (cell.img_View != nil) {
            [cell.img_View removeFromSuperview];
            cell.img_View = nil;
        }
        cell.img_View = [[UIImageView alloc] init];
        
        NSArray *array = [[self sharedAppDelegate].shoppingCart objectAtIndex:indexPath.row];

    //    array = @[product,
    //              self.Quantity_TextField.text,
    //              price,
    //              @"",
    //              self.For_Aluminum_TextField.text,
    //              self.textView.text,
    //              [self.selectedImageURL absoluteString],
    //              imgString,
    //              [NSString stringWithFormat:@"%li",(long)self.selectedRow],
    //              [NSString stringWithFormat:@"%li",(long)self.selectedSection1]
    //              ];
        cell.product.text = [array objectAtIndex:0];
        cell.quantity_TextField.text = [array objectAtIndex:1];
        cell.aluminum_Outlet.text = [array objectAtIndex:4];
        cell.retouch_Outlet.hidden = YES;
        cell.addOutlet.tag = indexPath.row;
        cell.subtractOutlet.tag = indexPath.row;
        cell.quantity_TextField.tag = indexPath.row;
        cell.addOutlet.layer.cornerRadius = 2;
        cell.addOutlet.clipsToBounds = YES;
        cell.subtractOutlet.layer.cornerRadius = 2;
        cell.subtractOutlet.clipsToBounds = YES;
        int price = [[array objectAtIndex:2] intValue];
        int quan = [[array objectAtIndex:1] intValue];
        
        int total = price * quan;
        cell.total_Price.text = [NSString stringWithFormat:@"$%i",total];
        
    //    NSData *data = [[NSData alloc]initWithBase64EncodedString:[array objectAtIndex:6] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //    UIImage *image1 = [UIImage imageWithData:data];
        
        NSArray *cartArray = [[self sharedAppDelegate].shoppingCart objectAtIndex:indexPath.row];

        NSData *data = [[NSData alloc]initWithBase64EncodedString:[cartArray objectAtIndex:7] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *thumbImg = [UIImage imageWithData:data];
        NSLog(@"%f",thumbImg.size.width);
        NSLog(@"%f",thumbImg.size.height);
        
        float division = thumbImg.size.width/thumbImg.size.height;
        
        if (thumbImg.size.width < thumbImg.size.height) {
            NSLog(@"portrait");
            float newWidth = cell.imgView.frame.size.height * division;
            cell.img_View.frame  = CGRectMake(0, 0, newWidth, 120);
            cell.img_View.center = CGPointMake(cell.imgView.center.x ,cell.imgView.center.y);
            cell.img_View.image = thumbImg;
            [cell.contentView addSubview:cell.img_View];
            cell.imgViewURL = [cartArray objectAtIndex:6];
        }
        if (thumbImg.size.width > thumbImg.size.height) {
            NSLog(@"landscape");
            int maxImageWidth = cell.product.frame.origin.x-20;
            float newHeight = maxImageWidth / division;
            NSLog(@"%f",newHeight);
            [cell.img_View setFrame:CGRectMake(0, 0, maxImageWidth, newHeight)];
            [cell.img_View setCenter:CGPointMake(cell.imgView.center.x ,cell.imgView.center.y)];
            cell.img_View.image = thumbImg;
            [cell.contentView addSubview:cell.img_View];
            cell.imgViewURL = [cartArray objectAtIndex:6];
        }
        if (thumbImg.size.width == thumbImg.size.height) {
            NSLog(@"square");
            [cell.img_View setFrame:CGRectMake(0, 0, 102, 102)];
            [cell.img_View setCenter:CGPointMake(cell.imgView.center.x ,cell.imgView.center.y)];
            cell.img_View.image = thumbImg;
            [cell.contentView addSubview:cell.img_View];
            cell.imgViewURL = [cartArray objectAtIndex:6];
        }

    }
        else{
            cell.product.text = @"";
            cell.total_Price.text = @"";
            cell.quantity_TextField.text = @"";
            cell.aluminum_Outlet.text = @"";
            cell.retouch_Outlet.hidden = YES;
            cell.addOutlet.hidden = YES;
            cell.subtractOutlet.hidden = YES;
        }

        
    return cell;
}

NSArray *currentItem;
NSInteger selectedRow;
NSInteger selectedSection;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    currentItem = [[self sharedAppDelegate].shoppingCart objectAtIndex:indexPath.row];
    if (self.editingImageIndexPath) {
        self.editingImageIndexPath = nil;
    }
    self.editingImageIndexPath = indexPath;
    selectedRow = indexPath.row;
    edited = YES;
    NSArray *array5 = @[currentItem,indexPath,[NSString stringWithFormat:@"%ld",(long)selectedRow],@"YES"];
    if ([self sharedAppDelegate].cartIsMainController == YES) {
        [self performSegueWithIdentifier:@"EditCartItem" sender:self];
    }
    else{
        [self.delegate SelectedRowWithData:array5];
    }
    
    //[self performSegueWithIdentifier:@"EditCartItem" sender:self];
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

    NSInteger cellHeight;
    if (indexPath.row+1 == [self sharedAppDelegate].shoppingCart.count+1) {
        cellHeight = 70;
    }
    else{
        cellHeight = 142;
    }
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *array = [[self sharedAppDelegate].shoppingCart objectAtIndex:indexPath.row];
        int price2 = [[array objectAtIndex:2] intValue];
        int quantity = [[array objectAtIndex:1] intValue];
        NSString *theTotal = [self.total_Outlet.title stringByReplacingOccurrencesOfString:@"$" withString:@""];
        int newTotal = [theTotal intValue] - (price2 * quantity);
        NSLog(@"New total:%i",newTotal);
        NSLog(@"price:%i",price2);
        NSLog(@"quan:%i",quantity);
        self.total_Outlet.title = [NSString stringWithFormat:@"$%i",newTotal];

        int totalPrints1 = [self.totalPrints.title intValue] - quantity;
        self.totalPrints.title = [NSString stringWithFormat:@"%i",totalPrints1];
        [self sharedAppDelegate].cartTotal = newTotal;
        [self sharedAppDelegate].cartPrintTotal = totalPrints1;
        [[self sharedAppDelegate].shoppingCart removeObjectAtIndex:indexPath.row];
        [NSKeyedArchiver archiveRootObject:[self sharedAppDelegate].shoppingCart toFile:[self archivePathShoppingCart]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    NSLog(@"Deleted row.");
}



- (void)addedQuantity{
    self.totalPrints.title = [NSString stringWithFormat:@"%li",(long)[self sharedAppDelegate].cartPrintTotal];
    self.total_Outlet.title = [NSString stringWithFormat:@"$%li",(long)[self sharedAppDelegate].cartTotal];
    
    NSArray *array2 = @[[NSString stringWithFormat:@"%ld",(long)[self sharedAppDelegate].cartTotal], [NSString stringWithFormat:@"%ld",(long)[self sharedAppDelegate].cartPrintTotal]];
    [NSKeyedArchiver archiveRootObject:array2 toFile:[self archiveCartTotals]];
    [NSKeyedArchiver archiveRootObject:[self sharedAppDelegate].shoppingCart toFile:[self archivePathShoppingCart]];
}


int beginningQuantity;
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSIndexPath *path = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    if (self.editingImageIndexPath) {
        self.editingImageIndexPath = nil;
    }
    self.editingImageIndexPath = path;
    CartTVCCell *cell = [self.tableView cellForRowAtIndexPath:path];
    if (textField == cell.quantity_TextField) {
        beginningQuantity = [cell.quantity_TextField.text intValue];
    }
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







- (void)library{
    self.imagePicker = [[UIImagePickerController alloc] init];
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    //self.imagePicker.allowsEditing = YES;
    self.imagePicker.delegate = self;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}





-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",self.editingImageIndexPath);
    CartTVCCell *cell = [self.tableView cellForRowAtIndexPath:self.editingImageIndexPath];
    if (self.editingImageIndexPath) {
        self.editingImageIndexPath = nil;
    }
    UIImage *image;
    if (cell.imgView) {
        [cell.imgView removeFromSuperview];
        cell.imgView = nil;
    }
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    if (image.size.width < image.size.height) {
        NSLog(@"<");
        cell.imgView.frame = CGRectMake(8, 40, 93.75, 125);
    }
    if (image.size.width > image.size.height) {
        NSLog(@">");
        cell.imgView.frame = CGRectMake(8, 48, 93, 70);
    }
    if (image.size.width == image.size.height) {
        NSLog(@">");
        cell.imgView.frame = CGRectMake(8, 44, 124, 124);
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
        VC.delegate = self;
        VC.editingCartItem = YES;
        VC.selectedCartRow = selectedRow;
        NSIndexPath *path = [NSIndexPath indexPathForRow:selectedRow inSection:0];
        VC.selectedImageIndex = path;
        
        if (self.navigationItem.backBarButtonItem == nil) {
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"", returnbuttontitle) style:     UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem = backButton;
        }

    }
    
    if ([segue.identifier isEqualToString:@"StartCheckOut"]) {
        if (self.navigationItem.backBarButtonItem == nil) {
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"", returnbuttontitle) style:     UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem = backButton;
        }
    }
    if ([segue.identifier isEqualToString:@"StartOrder"]) {
        OrderOverViewTVC *orderOverView = segue.destinationViewController;
        orderOverView.displayedIt = NO;
        if (self.navigationItem.backBarButtonItem == nil) {
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"", returnbuttontitle) style:     UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem = backButton;
        }
    }
}


- (void)editedCartItem{
    NSLog(@"Got here");
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (NSString*)archiveCartTotals{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"cartTotals"];
}

@end
