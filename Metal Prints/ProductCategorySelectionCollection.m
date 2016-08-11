//
//  ProductCategorySelectionCollection.m
//  Metal Prints
//
//  Created by Bryan Stevens on 8/9/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "ProductCategorySelectionCollection.h"
#import "AppDelegate.h"

@interface ProductCategorySelectionCollection ()

@end

@implementation ProductCategorySelectionCollection

static NSString * const reuseIdentifier = @"Cell";


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


+ (ProductCategorySelectionCollection *)sharedProductCategorySelectionCollection
{
    static ProductCategorySelectionCollection *sharedInstance = nil;
    
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
        sharedInstance = (ProductCategorySelectionCollection*)[storyboard instantiateViewControllerWithIdentifier: @"productCategoryCollection"];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    cell.contentView.layer.borderWidth = 1.0;
    cell.contentView.layer.borderColor = [[UIColor blackColor] CGColor];
    if (indexPath.row == 0) {
        cell.label.text = @"Aluminum";
    }
    if (indexPath.row == 1) {
        cell.label.text = @"Wood";
    }
    if (indexPath.row == 2) {
        cell.label.text = @"Mug";
    }
    if (indexPath.row == 3) {
        cell.label.text = @"Tile";
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ProductCollectionViewController *productCollectionVC = [ProductCollectionViewController sharedProductCollectionVC];
        productCollectionVC.currentProductArray = [self sharedAppDelegate].AluminumProductArray;

        [self.view addSubview:productCollectionVC.collectionView];
    }
    if (indexPath.row == 1) {
        ProductCollectionViewController *productCollectionVC = [ProductCollectionViewController sharedProductCollectionVC];
        productCollectionVC.currentProductArray = [self sharedAppDelegate].WoodenProductArray;
        [self.view addSubview:productCollectionVC.collectionView];
    }
    if (indexPath.row == 2) {
        ProductCollectionViewController *productCollectionVC = [ProductCollectionViewController sharedProductCollectionVC];
        productCollectionVC.currentProductArray = [self sharedAppDelegate].MugProductArray;
        [self.view addSubview:productCollectionVC.collectionView];
    }
    if (indexPath.row == 3) {
        ProductCollectionViewController *productCollectionVC = [ProductCollectionViewController sharedProductCollectionVC];
        productCollectionVC.currentProductArray = [self sharedAppDelegate].TileProductArray;
        [self.view addSubview:productCollectionVC.collectionView];
    }
}

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/



@end
