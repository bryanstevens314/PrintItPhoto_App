//
//  HighlightedImageCVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 7/29/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "HighlightedImageCVC.h"
#import "AppDelegate.h"

@interface HighlightedImageCVC (){
    NSIndexPath *selectedIndex;
}

@end

@implementation HighlightedImageCVC

static NSString * const reuseIdentifier = @"Cell";


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

    
+ (HighlightedImageCVC *)sharedHighlightedImageCVC
{
    static HighlightedImageCVC *sharedInstance = nil;
    
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
        sharedInstance = (HighlightedImageCVC*)[storyboard instantiateViewControllerWithIdentifier: @"HighlightImage"];
    });
    return sharedInstance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
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

    return self.highlightedImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"HighlightedCell";
    
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSArray *anArray = [self.highlightedImageArray objectAtIndex:indexPath.row];
    UIImage *thumbImg = [anArray objectAtIndex:0];
    NSURL *imgURL = [anArray objectAtIndex:1];
                     //UIImage *fullImg = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                     //                 if (self.collectionImgView) {
                     //                     self.collectionImgView = nil;
                     //                 }
                     float division = thumbImg.size.width/thumbImg.size.height;
                     if (thumbImg.size.width < thumbImg.size.height) {
                         NSLog(@"portrait");
                         
                         float newWidth = (cell.bounds.size.height - 5) * division;
                         [cell.cellImageView setFrame:CGRectMake(0, 0, newWidth, cell.bounds.size.height - 5)];
                         [cell.cellImageView setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
                         cell.cellImageView.image = thumbImg;
                     }
                     if (thumbImg.size.width > thumbImg.size.height) {
                         NSLog(@"landscape");
                         float newHeight = (cell.bounds.size.width - 5) / division;
                         [cell.cellImageView setFrame:CGRectMake(0, 0, cell.bounds.size.width - 5, newHeight)];
                         [cell.cellImageView setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
                         cell.cellImageView.image = thumbImg;
                     }
                     if (thumbImg.size.width == thumbImg.size.height) {
                         NSLog(@"square");
                         [cell.cellImageView setFrame:CGRectMake(0, 0, cell.bounds.size.height - 20, cell.bounds.size.height - 20)];
                         [cell.cellImageView setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
                         cell.cellImageView.image = thumbImg;
                     }
                     
                     //                     if (thumbImg.size.width == thumbImg.size.height) {
                     //                         [cell.cellImageView setFrame:CGRectMake(0, 0, thumbImg.size.width/2.2, thumbImg.size.height/2.2)];
                     //                     }
                     //                     else{
                     //                         [cell.cellImageView setFrame:CGRectMake(0, 0, thumbImg.size.width/3.1, thumbImg.size.height/3.1)];
                     //                     }
                     
                     [cell.cellImageView setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
                     //                     [cell.contentView.layer setBorderColor: [[UIColor blackColor] CGColor]];
                     //                     [cell.contentView.layer setBorderWidth: 1];
                     cell.cellImageView.image = thumbImg;

                     [cell.cellImageView.layer setBorderColor: [[UIColor blueColor] CGColor]];
                     [cell.cellImageView.layer setBorderWidth: 4];
                     
                     if ([self sharedAppDelegate].imagesInCartArray.count != 0) {
                         NSURL *highlightedImageURL = [[self sharedAppDelegate].highlightedArray objectAtIndex:indexPath.row];
                         NSURL *cartImageURL = [[self sharedAppDelegate].imagesInCartArray objectAtIndex:indexPath.row];
                         if ([[cartImageURL absoluteString] isEqualToString:[highlightedImageURL absoluteString]]) {
                             [cell.inCartCheck setFrame:CGRectMake(0, 0, 30, 30)];
                             [cell.inCartCheck setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
                             UIImage *img = [UIImage imageNamed:@"MW-Icon-CheckMark.svg.png"];
                             cell.inCartCheck.image = img;
                         }

                     }
                     
                 


    
    

    
    NSLog(@"creating cell");
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Selected image");
    
    //[[ImageCollectionViewController sharedImageCollectionViewController] cellSelectedAtIndex:indexPath];
    selectedIndex = indexPath;
    [self performSegueWithIdentifier:@"StartOrderFromHighlightedImage" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Preparing for segue");
    if ([segue.identifier isEqualToString:@"StartOrderFromHighlightedImage"]) {
        NSLog(@"Segueing");
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", returnbuttontitle) style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        DetailsTVC *details = segue.destinationViewController;
        details.selectedImageIndex = selectedIndex;
        details.startingFromHighlightedImage = YES;
    }
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
