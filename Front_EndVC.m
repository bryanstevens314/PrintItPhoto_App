//
//  Front_EndVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 4/24/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "Front_EndVC.h"

#import "AppDelegate.h"
#import "LaunchController.h"

@interface Front_EndVC (){

}
@property(nonatomic) NSInteger selectedProduct;
@property(nonatomic) NSInteger selectedProductSection;
@property(nonatomic) NSArray* currentArray1;
@end

@implementation Front_EndVC


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}



+ (Front_EndVC *)sharedFrontEnd_VC
{
    static Front_EndVC *sharedInstance = nil;
    
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
        sharedInstance = (Front_EndVC*)[storyboard instantiateViewControllerWithIdentifier: @"front_End"];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    UIBarButtonItem *rightBarButtonItem3 = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
//    [self.navigationItem setRightBarButtonItem:rightBarButtonItem3];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:0.6];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //[self.tabBarController.tabBar setBarTintColor:[UIColor clearColor]];
    //[self.tabBarController.tabBar setBackgroundImage:[UIImage new]];
    collView = [ProductCategorySelectionCollection sharedProductCategorySelectionCollection];
    
    collView.delegate = self;
    [self.view addSubview:collView.collectionView];


}


UIImageView *launchImageView;
ProductCategorySelectionCollection *collView;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //self.tabBarController.tabBar.alpha = 0.9;

    [self.navigationItem setTitle:@"Store"];
    if ([self sharedAppDelegate].loadingImages == YES) {
        NSLog(@"Loading Images");
        LaunchController *launchControl = [LaunchController sharedLaunchController];
        [[self sharedAppDelegate].window addSubview:launchControl.view];
        [[self sharedAppDelegate].window bringSubviewToFront:launchControl.view];
    }

}



-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}


- (void)FinishedLoadingImages {
    NSLog(@"Finished");
    [[LaunchController sharedLaunchController].view removeFromSuperview];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ProductContainer"]) {
        ProductsTVC *tvc = segue.destinationViewController;
        tvc.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"StartOrder"]) {
        if (imageSelectionData == nil) {
            NSLog(@"preparing segue");
            DetailsTVC *order = segue.destinationViewController;
            order.selectedRow = self.selectedProduct;
            order.selectedSection1 = self.selectedProductSection;
            order.currentProductArray1 = self.currentArray1;
            order.delegate = self;
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"", returnbuttontitle) style:     UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem = backButton;
            
            NSLog(@"initiating segue");
        }
        else{
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"", returnbuttontitle) style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem = backButton;
            DetailsTVC *details = segue.destinationViewController;
            details.delegate = self;
            
            details.selectedImageIndex = [imageSelectionData objectAtIndex:0];
            details.startingFromHighlightedImage = YES;
            details.selectedImageURL = [imageSelectionData objectAtIndex:1];
            details.thumbImg = [imageSelectionData objectAtIndex:2];
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



    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://final-project-order-viewer-stevens-apps.c9users.io/recieve_data.php"]];

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


-(void)backClicked{
    ProductCollectionViewController *productCollectionVC = [ProductCollectionViewController sharedProductCollectionVC];
    [UIView animateWithDuration:0.2f animations:^{
        productCollectionVC.collectionView.frame = CGRectOffset(productCollectionVC.collectionView.frame, self.view.frame.size.width, 0);
        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.title = @"Store";
    }];
}


-(void)userSlideViewAway{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"Store";
}

- (void)selectedCategoryWithSection:(NSInteger)section{
    
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
        productCollectionVC.selectedSection = section;
        productCollectionVC.navigationItem.title = @"Other Goodies";
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
        [self.navigationController pushViewController:productCollectionVC animated:YES];

    }
    
    [self.navigationItem setTitle:[[self sharedAppDelegate].categoryArray objectAtIndex:section]];
}


- (IBAction)moveCollectionView:(id)sender {
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}


ImageCollectionViewController *imageVC;
BOOL imagesPresenting;
- (IBAction)SwitchViews:(id)sender {
    
    if (imageVC) {
        if (imagesPresenting == NO) {
            imagesPresenting = YES;
            [self.navigationItem setTitle:@"My Photos"];
            [self.view addSubview:imageVC.view];
        }
        else{
            imagesPresenting = NO;
            [self.navigationItem setTitle:@"Store"];
            [imageVC.view removeFromSuperview];
        }
    }
    else{
        imagesPresenting = YES;
        [self.navigationItem setTitle:@"My Photos"];
        imageVC = [ImageCollectionViewController sharedImageCollectionViewController];
        imageVC.delegate = self;
        [self.view addSubview:imageVC.view];
    }
    
    
}


NSArray *imageSelectionData;
- (void)SelectedImageWithData:(NSArray*)data{
    imageSelectionData = data;
    [self performSegueWithIdentifier:@"StartOrder" sender:self];
    
}
@end
