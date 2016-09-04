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
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer1:)];
    _panGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:_panGestureRecognizer];
}




BOOL started1 = NO;
-(void)moveViewWithGestureRecognizer1:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
    NSLog(@"location: %f",touchLocation.x);
    if (touchLocation.x <= 40 && started1 == NO) {
        NSLog(@"started");
        started1 = YES;
        self.collectionView.frame = CGRectMake(touchLocation.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    }
    if (started1 == YES) {
        NSLog(@"Continueing");
        self.collectionView.frame = CGRectMake(touchLocation.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
        
    }
    
    if(UIGestureRecognizerStateEnded == panGestureRecognizer.state)
    {
        if (started1 == YES) {
            if (touchLocation.x >= 160) {
                [UIView animateWithDuration:0.2 animations:^{
                    
                    self.collectionView.frame = CGRectMake(self.view.bounds.size.width, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
                    
                }completion:^(BOOL finished) {
                    [self.collectionView removeFromSuperview];
                    started1 = NO;
                }];
                
                
            }
            else{
                [UIView animateWithDuration:0.3 animations:^{
                    self.collectionView.frame = CGRectMake(self.view.bounds.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
                    started1 = NO;
                }];
            }
        }

        
    }
    
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL simultaneous;
    if (started1 == YES) {
        simultaneous = NO;
    }
    if (started1 == NO) {
        simultaneous = YES;
    }
    return simultaneous;
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
    if (cell.theProductImage) {
        [cell.theProductImage removeFromSuperview];
        cell.theProductImage = nil;
    }
    cell.theProductImage = [[UIImageView alloc] init];
    UIImage *image = [productArray objectAtIndex:2];
    
    if (image.size.height/6 > 84) {
        float ratio = image.size.width/image.size.height;
        int theWidth = 84 * ratio;
        [cell.theProductImage setFrame:CGRectMake(0, 0, theWidth, 84)];
    }
    else if (image.size.width/6 > cell.bounds.size.width-10){
        float ratio = image.size.width/image.size.height;
        int theHeight = (cell.bounds.size.width-10)/ratio;
        [cell.theProductImage setFrame:CGRectMake(0, 0, (cell.bounds.size.width-10), theHeight)];
    }
    else{
        [cell.theProductImage setFrame:CGRectMake(0, 0, image.size.width/6, image.size.height/6)];
    }
    
    [cell.theProductImage setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
    cell.theProductImage.image = image;
    
    [cell.contentView addSubview:cell.theProductImage];
    [cell.theProductImage.layer setCornerRadius:7];
    cell.theProductImage.layer.masksToBounds = YES;
    if (indexPath.row == 4) {
        NSLog(@"image hieght:%f",image.size.height/6);
    }
//    float division = image.size.width/image.size.height;
//    
//    if (image.size.width < image.size.height) {
//        NSLog(@"portrait");
//        float newWidth = (cell.bounds.size.height - 20) * division;
//        cell.theProductImage.frame  = CGRectMake(0, 0, newWidth, cell.bounds.size.height - 20);
//        cell.theProductImage.center = CGPointMake(cell.bounds.size.width/2,cell.theProductImage.center.y);
//        cell.theProductImage.image = image;
//        
//        [cell.contentView addSubview:cell.theProductImage];
//        [cell.theProductImage.layer setCornerRadius:7];
//        cell.theProductImage.layer.masksToBounds = YES;
//    }
//    if (image.size.width > image.size.height) {
//        NSLog(@"landscape");
//        float newHeight = (cell.bounds.size.width - 10) / division;
//        [cell.theProductImage setFrame:CGRectMake(0, 0, cell.bounds.size.width - 10, newHeight)];
//        [cell.theProductImage setCenter:CGPointMake(cell.bounds.size.width/2,cell.theProductImage.center.y)];
//        cell.theProductImage.image = image;
//        [cell.contentView addSubview:cell.theProductImage];
//        [cell.theProductImage.layer setCornerRadius:4];
//        cell.theProductImage.layer.masksToBounds = YES;
//    }
//    if (image.size.width == image.size.height) {
//        NSLog(@"square");
//        [cell.theProductImage setFrame:CGRectMake(0, 0, cell.bounds.size.height - 20, cell.bounds.size.height - 20)];
//        [cell.theProductImage setCenter:CGPointMake(cell.bounds.size.width/2,cell.theProductImage.center.y)];
//        cell.theProductImage.image = image;
//        
//        [cell.contentView addSubview:cell.theProductImage];
//        [cell.theProductImage.layer setCornerRadius:7];
//        cell.theProductImage.layer.masksToBounds = YES;
//    }
    
    
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
