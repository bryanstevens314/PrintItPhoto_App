//
//  ProductCollectionViewController.m
//  Metal Prints
//
//  Created by Bryan Stevens on 8/10/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "ProductCollectionViewController.h"

#import "AppDelegate.h"

@interface ProductCollectionViewController ()

@end

@implementation ProductCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (ProductCollectionViewController *)sharedProductCollectionVC
{
    static ProductCollectionViewController *sharedInstance = nil;
    
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
        sharedInstance = (ProductCollectionViewController*)[storyboard instantiateViewControllerWithIdentifier: @"productDisplayCollection"];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    UISwipeGestureRecognizer *swipeLeftGreen = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeLeftGreen.direction = UISwipeGestureRecognizerDirectionRight;
    [self.collectionView addGestureRecognizer:swipeLeftGreen];
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer:)];
//    [self.collectionView addGestureRecognizer:panGestureRecognizer];
    
    // Do any additional setup after loading the view.
}



-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.2 animations:^{
        self.collectionView.frame = CGRectOffset(self.collectionView.frame, self.view.frame.size.width, 0.0);
    }];
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
    NSLog(@"Number of items");
    return self.currentProductArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productCell" forIndexPath:indexPath];
    NSArray *productArray = [self.currentProductArray objectAtIndex:indexPath.row];
    cell.productName.text = [productArray objectAtIndex:0];
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"got to here");
//    DetailsTVC *details = [DetailsTVC sharedDetailsTVCInstance];
//    details.currentProductArray1 = self.currentProductArray;
//    details.selectedSection1 = self.selectedSection;
//    details.selectedRow = indexPath.row;
    
    [self.delegate ProductSelectedWithRow:indexPath.row Section:self.selectedSection andArray:self.currentProductArray];
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
