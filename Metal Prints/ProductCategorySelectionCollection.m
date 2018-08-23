//
//  ProductCategorySelectionCollection.m
//  Metal Prints
//
//  Created by Bryan Stevens on 8/9/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "ProductCategorySelectionCollection.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "ProductCollectionViewController.h"

@interface ProductCategorySelectionCollection ()
@property(nonatomic) NSInteger selectedProduct;
@property(nonatomic) NSInteger selectedProductSection;
@property(nonatomic) NSArray* currentArray1;
@property(nonatomic, retain) ShoppingCartTVC *cartVC;
@property(nonatomic, retain) UIButton *proceedButton;
@property(nonatomic) BOOL imagesPresenting;
@end

@implementation ProductCategorySelectionCollection

static NSString * const reuseIdentifier = @"Cell";


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

-(void)dealloc
{
    NSLog(@"viewcontroller is being deallocated");
}

+ (ProductCategorySelectionCollection *)sharedProductCategorySelectionCollection
{
    static ProductCategorySelectionCollection *sharedInstance = nil;
    
    
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
        sharedInstance = (ProductCategorySelectionCollection*)[storyboard instantiateViewControllerWithIdentifier: @"productCategoryCollection"];
    });
    return sharedInstance;
}

- (void)PanGestureInitiated:(id)sender{
    NSLog(@"Panned");
//    if (displayingProducts == YES) {
//        finished = NO;
//        displayingProducts = NO;
//        ProductCollectionViewController *prodColl = [ProductCollectionViewController sharedProductCollectionVC];
//        CGRect finalFrame = CGRectMake(self.view.frame.size.width + prodColl.collectionView.frame.size.width, prodColl.collectionView.frame.origin.y, prodColl.collectionView.frame.size.width, prodColl.collectionView.frame.size.height);
//        [UIView animateWithDuration:0.6 animations:^{
//            prodColl.collectionView.frame = finalFrame;
//            
//        } completion:^(BOOL finished1) {
//            finished = YES;
//            [prodColl.collectionView removeFromSuperview];
//            //[self.view removeGestureRecognizer:swipeUpRecognizer];
//        }];
//    }


    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    finished = YES;

    UIImage *background = [UIImage imageNamed:@"Hamburger_icon.svg.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(toggleReveal1) forControlEvents:UIControlEventTouchUpInside]; //adding action
    [button setBackgroundImage:background forState:UIControlStateNormal];
    button.frame = CGRectMake(0 ,0,35,30);
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    
    
    // Do any additional setup after loading the view.
}


UIImageView *launchImageView;
ProductCategorySelectionCollection *collView;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSLog(@"View will appear");
    finished = YES;

    //self.tabBarController.tabBar.alpha = 0.9;
    if ([self sharedAppDelegate].loadingImages == YES) {
        NSLog(@"Loading Images");
        LaunchController *launchControl = [LaunchController sharedLaunchController];
        [[self sharedAppDelegate].window addSubview:launchControl.view];
        [[self sharedAppDelegate].window bringSubviewToFront:launchControl.view];
    }
    [self.navigationItem setTitle:@"Store"];
    
    if (singleTap) {
        [collView.collectionView removeGestureRecognizer:singleTap];
        singleTap = nil;
    }
    
    self.cartVC = [ShoppingCartTVC sharedShoppingCartTVC];
    self.cartVC.delegate = self;
    self.proceedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.proceedButton.frame = CGRectMake(0, 0, 353, 50);
    self.proceedButton.layer.cornerRadius = 2;
    self.proceedButton.clipsToBounds = YES;
    [self.proceedButton addTarget:self action:@selector(EnterShipping) forControlEvents:UIControlEventTouchUpInside];
    [self.proceedButton setTitle:@"Proceed with order" forState:UIControlStateNormal];
    self.proceedButton.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:1];
    self.proceedButton.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-35);
    
    if ([self sharedAppDelegate].displayingCart == YES) {
        [self sharedAppDelegate].displayingCart = YES;
        [self.navigationItem setTitle:@"Cart"];
        
        //self.switchViewsOutlet.image = [UIImage imageNamed:@"Home Icon.png"];
        [self.view addSubview:self.cartVC.view];
        [self.view addSubview:self.proceedButton];
        [self.view bringSubviewToFront:self.proceedButton];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
//    cell.contentView.layer.borderWidth = 1.0;
//    cell.contentView.layer.borderColor = [[UIColor blackColor] CGColor];
    if (indexPath.row == 0) {
        cell.label.text = @"Aluminum";
//        cell.backgroundColor = [UIColor grayColor];
        //cell.productImage.image = [UIImage imageNamed:@"aluminum-tin-cans.jpg"];
    }
    if (indexPath.row == 1) {
        cell.label.text = @"Wood";
        //cell.backgroundColor = [UIColor grayColor];
        //cell.productImage.image = [UIImage imageNamed:@"wildtextures-old-wood-original-file.jpg"];
    }
    if (indexPath.row == 2) {
        cell.label.text = @"Tile";
        //cell.backgroundColor = [UIColor grayColor];
        //cell.productImage.image = [UIImage imageNamed:@"broadway-coffee-mug.jpg"];
    }
    if (indexPath.row == 3) {
        cell.label.text = @"Slate";
        //cell.backgroundColor = [UIColor grayColor];
        //cell.productImage.image = [UIImage imageNamed:@"d4e7cb05ecf41db9a0b4cafccae2c4a0.jpg"];
    }
    if (indexPath.row == 4) {
        cell.label.text = @"Other Goodies";
        //cell.backgroundColor = [UIColor grayColor];
        //cell.productImage.image = [UIImage imageNamed:@"d4e7cb05ecf41db9a0b4cafccae2c4a0.jpg"];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

NSInteger selectedSection1;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Selected");
    displayingProducts = YES;
    if (finished == YES) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        NSLog(@"Selected1");
        selectedSection1 = indexPath.row;
        [self performSegueWithIdentifier:@"showProducts" sender:self];
    }

}


UITapGestureRecognizer *singleTap;
BOOL revealed = NO;
-(void)toggleReveal1{
    
    //if (revealed == NO) {
        revealed = YES;
        //collView.collectionView.userInteractionEnabled = NO;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        //singleTap.cancelsTouchesInView = true;
        [self.collectionView  addGestureRecognizer:singleTap];
        [self.revealViewController revealToggle];
//    }
//    else{
//        revealed = NO;
//        [self.revealViewController revealToggle];
//        //self.collectionView.userInteractionEnabled = YES;
//        [self.collectionView removeGestureRecognizer:singleTap];
//        singleTap = nil;
//    }

}

-(void)SingleTap:(UITapGestureRecognizer *)gesture{
    
    NSLog(@"SingleTapFunc");
    [self.revealViewController revealToggle];
    //self.collectionView.userInteractionEnabled = YES;
    [self.collectionView removeGestureRecognizer:singleTap];
    singleTap = nil;
}





-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    if (self.imagesPresenting == YES) {
        self.imagesPresenting = NO;
        [self.navigationItem setTitle:@"Store"];
        [self.proceedButton removeFromSuperview];
        //self.switchViewsOutlet.image = [UIImage imageNamed:@"Cart Icon.png"];
        [self.cartVC.view removeFromSuperview];
        
    }
    
}

- (void)FinishedLoadingImages {
    NSLog(@"Finished");
    
    [[LaunchController sharedLaunchController].view removeFromSuperview];

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"ProductContainer"]) {
//        ProductsTVC *tvc = segue.destinationViewController;
//        tvc.delegate = self;
//    }

    if ([segue.identifier isEqualToString:@"showProducts"]) {
        ProductCollectionViewController *tvc = segue.destinationViewController;
        tvc.delegate = self;
        if (selectedSection1 == 0) {
            NSLog(@"Aluminum");
            
            tvc.currentProductArray = [self sharedAppDelegate].AluminumProductArray;
            
            tvc.selectedSection = selectedSection1;
            tvc.navigationItem.title = @"Aluminum";
            UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            [[self navigationItem] setBackBarButtonItem:newBackButton];
            
        }
        if (selectedSection1 == 1) {
            tvc.currentProductArray = [self sharedAppDelegate].WoodenProductArray;
            tvc.selectedSection = selectedSection1;
            tvc.navigationItem.title = @"Wood";
            UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            [[self navigationItem] setBackBarButtonItem:newBackButton];
            
        }
        if (selectedSection1 == 2) {
            tvc.currentProductArray = [self sharedAppDelegate].TileProductArray;
            tvc.selectedSection = selectedSection1;
            tvc.navigationItem.title = @"Tile";
            UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            [[self navigationItem] setBackBarButtonItem:newBackButton];
            
        }
        if (selectedSection1 == 3) {

            tvc.currentProductArray = [self sharedAppDelegate].SlateProductArray;
            tvc.selectedSection = selectedSection1;
            tvc.navigationItem.title = @"Slate";
            UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            [[self navigationItem] setBackBarButtonItem:newBackButton];
            
        }
        if (selectedSection1 == 4) {
            tvc.currentProductArray = [self sharedAppDelegate].OtherProductArray;
            tvc.selectedSection = selectedSection1;
            tvc.navigationItem.title = @"Other Goodies";
            UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            [[self navigationItem] setBackBarButtonItem:newBackButton];
            
        }
        
    }
    
    if ([segue.identifier isEqualToString:@"StartOrder"]) {
        if (imageSelectionData == nil) {
            NSLog(@"preparing segue");
            DetailsTVC *order = segue.destinationViewController;
            order.selectedRow = self.selectedProduct;
            order.selectedSection1 = self.selectedProductSection;
            order.currentProductArray1 = self.currentArray1;
            order.delegate = self;
            if (self.navigationItem.backBarButtonItem == nil) {
                UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"", returnbuttontitle) style:     UIBarButtonItemStylePlain target:nil action:nil];
                self.navigationItem.backBarButtonItem = backButton;
            }
            
            NSLog(@"initiating segue");
        }
        else{
            if (self.navigationItem.backBarButtonItem == nil) {
                UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"", returnbuttontitle) style:     UIBarButtonItemStylePlain target:nil action:nil];
                self.navigationItem.backBarButtonItem = backButton;
            }
            DetailsTVC *details = segue.destinationViewController;
            details.delegate = self;
            details.editingCartItem = YES;
            details.selectedCartRow = [[imageSelectionData objectAtIndex:2] integerValue];
            details.selectedImageIndex = [imageSelectionData objectAtIndex:1];
            imageSelectionData = nil;
            
            
        }
    }
    if ([segue.identifier isEqualToString:@"presentPhotos"]) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"", returnbuttontitle) style:     UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
    }

    
}


-(void)addedCartItem{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)ShoppingCartSelected:(id)sender {
    
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://print-it-photo-stevens-apps.c9users.io/recieve_data.php"]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Bryan Stevens",@"name",
                          @"1930 10th st",@"shipping_address",
                          @"bryan@yahoo.com",@"email", nil];
    
    NSError *error;
    
    NSData *jsonData =[NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    
    NSError *err;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    
    
    if(responseString)
    {
        NSLog(@"got response==%@", responseString);
    }
    else
    {
        NSLog(@"faield to connect");
    }
    
}


- (void)ProductSelectedWithRow:(NSInteger)row Section:(NSInteger)section andArray:(NSArray*)curArray {
    NSLog(@"Product selected");
    self.selectedProduct = row;
    self.selectedProductSection = section;
    self.currentArray1 = curArray;
    [self performSegueWithIdentifier:@"StartOrder" sender:self];
}

-(void)cellClickedWithRow:(NSInteger)clickedCell{
    NSLog(@"CellClicked");
    //ProductCategorySelectionCollection *collView = [ProductCategorySelectionCollection sharedProductCategorySelectionCollection];
    //[collView.collectionView removeFromSuperview];
    
}


//-(void)backClicked{
//    ProductCollectionViewController *productCollectionVC = [ProductCollectionViewController sharedProductCollectionVC];
//    [UIView animateWithDuration:0.2f animations:^{
//        productCollectionVC.collectionView.frame = CGRectOffset(productCollectionVC.collectionView.frame, self.view.frame.size.width, 0);
//        
//        self.navigationItem.leftBarButtonItem = nil;
//        self.navigationItem.title = @"Store";
//    }];
//}


-(void)userSlideViewAway{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"Store";
}

- (void)selectedCategoryWithSection:(NSInteger)section{
    NSLog(@"Selected2");
    if (section == 0) {
        NSLog(@"Aluminum");
        
        ProductCollectionViewController *productCollectionVC = [ProductCollectionViewController sharedProductCollectionVC];
        productCollectionVC.delegate = self;
        productCollectionVC.currentProductArray = [self sharedAppDelegate].AluminumProductArray;
        productCollectionVC.selectedSection = section;
        productCollectionVC.navigationItem.title = @"Aluminum";
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
        [self.navigationController pushViewController:productCollectionVC animated:YES];
        
    }
    if (section == 1) {
        ProductCollectionViewController *productCollectionVC = [ProductCollectionViewController sharedProductCollectionVC];
        productCollectionVC.delegate = self;
        productCollectionVC.currentProductArray = [self sharedAppDelegate].WoodenProductArray;
        productCollectionVC.selectedSection = section;
        productCollectionVC.navigationItem.title = @"Wood";
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
        [self.navigationController pushViewController:productCollectionVC animated:YES];
        
    }
    if (section == 2) {
        ProductCollectionViewController *productCollectionVC = [ProductCollectionViewController sharedProductCollectionVC];
        productCollectionVC.delegate = self;
        productCollectionVC.currentProductArray = [self sharedAppDelegate].TileProductArray;
        productCollectionVC.selectedSection = section;
        productCollectionVC.navigationItem.title = @"Tile";
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
        [self.navigationController pushViewController:productCollectionVC animated:YES];
        
    }
    if (section == 3) {
        ProductCollectionViewController *productCollectionVC = [ProductCollectionViewController sharedProductCollectionVC];
        productCollectionVC.delegate = self;
        productCollectionVC.currentProductArray = [self sharedAppDelegate].SlateProductArray;
        productCollectionVC.selectedSection = section;
        productCollectionVC.navigationItem.title = @"Slate";
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
        [self.navigationController pushViewController:productCollectionVC animated:YES];
        
    }
    if (section == 4) {
        ProductCollectionViewController *productCollectionVC = [ProductCollectionViewController sharedProductCollectionVC];
        productCollectionVC.delegate = self;
        productCollectionVC.currentProductArray = [self sharedAppDelegate].OtherProductArray;
        productCollectionVC.selectedSection= section;
        productCollectionVC.navigationItem.title = @"Other Goodies";
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
        [self.navigationController pushViewController:productCollectionVC animated:YES];
        
    }
    
    [self.navigationItem setTitle:[[self sharedAppDelegate].categoryArray objectAtIndex:section]];
}



- (IBAction)SwitchViews:(id)sender {
    if (self.cartVC) {
        if ([self sharedAppDelegate].displayingCart == NO) {
            [self sharedAppDelegate].displayingCart = YES;
            [self.navigationItem setTitle:@"Cart"];
            
            //self.switchViewsOutlet.image = [UIImage imageNamed:@"Home Icon.png"];
            [self.view addSubview:self.cartVC.view];
            [self.view addSubview:self.proceedButton];
            [self.view bringSubviewToFront:self.proceedButton];
            
        }
        else{
            [self sharedAppDelegate].displayingCart = NO;
            [self.navigationItem setTitle:@"Store"];
            [self.proceedButton removeFromSuperview];
            //self.switchViewsOutlet.image = [UIImage imageNamed:@"Cart Icon.png"];
            [self.cartVC.view removeFromSuperview];
        }
    }
    else{
        [self sharedAppDelegate].displayingCart = YES;
        [self.navigationItem setTitle:@"Cart"];
        //self.switchViewsOutlet.image = [UIImage imageNamed:@"Home Icon.png"];
        self.cartVC = [ShoppingCartTVC sharedShoppingCartTVC];
        self.cartVC.delegate = self;
        [self.view addSubview:self.cartVC.view];
        if (self.proceedButton) {
            NSLog(@"!!!!!!!!!!!!");
            [self.view addSubview:self.proceedButton];
            [self.view bringSubviewToFront:self.proceedButton];
        }
        else{
            NSLog(@"?????????");
            self.proceedButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.proceedButton.frame = CGRectMake(0, 0, 353, 50);
            self.proceedButton.layer.cornerRadius = 10;
            self.proceedButton.clipsToBounds = YES;
            [self.proceedButton addTarget:self action:@selector(EnterShipping) forControlEvents:UIControlEventTouchUpInside];
            [self.proceedButton setTitle:@"Proceed with order" forState:UIControlStateNormal];
            self.proceedButton.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:1];
            self.proceedButton.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-30);
            [self.view addSubview:self.proceedButton];
            [self.view bringSubviewToFront:self.proceedButton];
        }
    }
    
    
}


- (void)editedCartItem{
    NSLog(@"Got here");
    [self.cartVC.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)EnterShipping {
    
    if ([self sharedAppDelegate].shoppingCart.count != 0) {
        [self performSegueWithIdentifier:@"StartCheckOut" sender:self];
    }
    else{
        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"You must add items to your cart before proceeding"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [alert2 dismissViewControllerAnimated:YES completion:nil];
                                                               }]; // 2
        
        [alert2 addAction:cameraAction];
        
        [self presentViewController:alert2 animated:YES completion:nil];
    }
    
    
    //[self sendEmail];
}

- (void)SelectedRowWithData:(NSArray*)data{
    imageSelectionData = data;
    [self performSegueWithIdentifier:@"StartOrder" sender:self];
    
}


NSArray *imageSelectionData;
- (void)SelectedImageWithData:(NSArray*)data{
    imageSelectionData = data;
    [self performSegueWithIdentifier:@"StartOrder" sender:self];
    
}



@end
