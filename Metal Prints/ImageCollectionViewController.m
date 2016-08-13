//
//  ImageCollectionViewController.m
//  Metal Prints
//
//  Created by Bryan Stevens on 6/25/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "ImageCollectionViewController.h"
#import "AppDelegate.h"

@interface ImageCollectionViewController (){
    BOOL newSelection;
}
@property (retain, nonatomic)NSMutableArray *mutImageArray;
@property (retain, nonatomic)NSMutableArray *mutHighlightedArray;
@property (retain, nonatomic)NSArray *anImageArray;
@end

@implementation ImageCollectionViewController{
    ALAssetsLibrary *library;
    NSArray *imageArray;
    UIAlertController *newAlertController;
    BOOL displayingHighlightedImages;
}
- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
    

+ (ImageCollectionViewController *)sharedImageCollectionViewController
{
    static ImageCollectionViewController *sharedInstance = nil;
    
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
        sharedInstance = (ImageCollectionViewController*)[storyboard instantiateViewControllerWithIdentifier: @"ImageCollectionView"];
    });
    return sharedInstance;
}
    

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Image View did load");
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

    //[self.navigationItem setTitle:@"My Gallery"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.toggleOutlet.tintColor = [UIColor lightGrayColor];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self archiveHighlightedImages]]) {
        [self sharedAppDelegate].highlightedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiveHighlightedImages]];
    }
    int x = 0;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self archiveHighlightedImages]]) {
        self.mutableHighlightedArray = [[NSMutableArray alloc] init];
    }
    else{
        self.mutableHighlightedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiveHighlightedImages]];
    }
    if (self.mutableImageArray == nil){
        self.mutableImageArray = [[NSMutableArray alloc] init];
        loadingImages = YES;
        for (NSURL *imgURL in [self sharedAppDelegate].phoneImageArray) {
            
            
            x++;
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library assetForURL:imgURL
                     resultBlock:^(ALAsset *asset) {
                         if (x != [self sharedAppDelegate].phoneImageArray.count) {
                             
                             UIImage *thumbImg = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                             NSArray *anArray = @[thumbImg,imgURL, @""];
                             [self.mutableImageArray addObject:anArray];
                             [self.mutableHighlightedArray addObject:@""];
                         }
                         if (x == [self sharedAppDelegate].phoneImageArray.count) {
                             UIImage *thumbImg = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                             NSArray *anArray = @[thumbImg,imgURL,@""];
                             [self.mutableImageArray addObject:anArray];
                             [self.mutableHighlightedArray addObject:@""];
                             loadingImages = NO;
                             reloadView = YES;
                             [self.collectionView reloadData];
                             
                             [activityIndicator stopAnimating];
                             [activityIndicator removeFromSuperview];
                         }
                         
                         //UIImage *fullImg = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                         //                 if (self.collectionImgView) {
                         //                     self.collectionImgView = nil;
                         //                 }
                         
                     }
             
                    failureBlock:^(NSError *error){
                        NSLog(@"operation was not successfull!");
                    }];
        }
    }


    
}

UIActivityIndicatorView *activityIndicator;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if (loadingImages == YES) {
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40, 40.0);
        activityIndicator.center = self.view.center;
        CGAffineTransform transform = CGAffineTransformMakeScale(1.25f, 1.25f);
        activityIndicator.transform = transform;
        [self.view addSubview: activityIndicator];
        [activityIndicator startAnimating];
    }

}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
//    newAlertController = [UIAlertController alertControllerWithTitle:@""
//                                                             message:@""
//                                                      preferredStyle:UIAlertControllerStyleAlert]; // 1
//    
//    UIViewController *customVC     = [[UIViewController alloc] init];
//    [newAlertController.view setFrame:CGRectMake(0, 300, 320, 275)];
//    
//    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [spinner startAnimating];
//    [customVC.view addSubview:spinner];
//    [spinner setCenter:CGPointMake(100, 27)];
//    
//    [customVC.view addConstraint:[NSLayoutConstraint
//                                  constraintWithItem: spinner
//                                  attribute:NSLayoutAttributeCenterX
//                                  relatedBy:NSLayoutRelationEqual
//                                  toItem:customVC.view
//                                  attribute:NSLayoutAttributeCenterX
//                                  multiplier:1.0f
//                                  constant:0.0f]];
//    
//    
//    [newAlertController setValue:customVC forKey:@"contentViewController"];
//    [self presentViewController:newAlertController animated:YES completion:nil]; // 6
    
}





-(void)allPhotosCollected:(NSMutableArray*)imgArray
{


    
    
    
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

NSInteger numberOfCells = 100;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"number of items");
    
//    if (reloadView == YES) {
//       numberOfCells = numberOfCells + 100;
//        if (numberOfCells > [self sharedAppDelegate].phoneImageArray.count) {
//            NSInteger sub = numberOfCells - [self sharedAppDelegate].phoneImageArray.count;
//            numberOfCells = numberOfCells - sub;
//        }
//    }
    if (loadingImages == YES) {
        numberOfCells = 0;
    }
    else{
        numberOfCells = self.mutableImageArray.count;
    }
    return numberOfCells;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSArray *thumbArray = [self.mutableImageArray objectAtIndex:indexPath.row];
    UIImage *thumbImg = [thumbArray objectAtIndex:0];
    NSURL *thumbURL = [thumbArray objectAtIndex:1];
//    long division = thumbImg.size.width/thumbImg.size.height;
//    NSLog(@"Image ratio %f",division);
//    if (division == 0.742690) {
//        NSLog(@"portrait");
//        float newWidth = (cell.bounds.size.height - 20) * 0.742690;
//        [cell.cellImageView setFrame:CGRectMake(0, 0, newWidth, cell.bounds.size.height - 20)];
//        [cell.cellImageView setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
//        cell.cellImageView.image = thumbImg;
//    }
//    if (division == 1.328125) {
//        NSLog(@"landscape");
//        float newHeight = (cell.bounds.size.height - 20) * 1.328125;
//        [cell.cellImageView setFrame:CGRectMake(0, 0, cell.bounds.size.width - 20, newHeight)];
//        [cell.cellImageView setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
//        cell.cellImageView.image = thumbImg;
//        
//    }
//    if (division == 1) {
//        NSLog(@"square");
//        [cell.cellImageView setFrame:CGRectMake(0, 0, cell.bounds.size.height - 20, cell.bounds.size.height - 20)];
//        [cell.cellImageView setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
//        cell.cellImageView.image = thumbImg;
//        
//        
//    }
//    if (division == 0.561404) {
//        NSLog(@"screenshot");
//        float newWidth = (cell.bounds.size.height - 20) * 0.561404;
//        [cell.cellImageView setFrame:CGRectMake(0, 0, newWidth, cell.bounds.size.height - 20)];
//        [cell.cellImageView setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
//        cell.cellImageView.image = thumbImg;
//    }
//    cell.contentView.layer.borderWidth = 1;
//    cell.contentView.layer.borderColor = [[UIColor blackColor] CGColor];
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
    
    
    //                     [cell.contentView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    //                     [cell.contentView.layer setBorderWidth: 1];
    NSString *selected = [self.mutableHighlightedArray objectAtIndex:indexPath.row];
            if ([selected isEqualToString:@"Selected"]) {
                
                [cell.cellImageView.layer setBorderColor: [[UIColor blueColor] CGColor]];
                [cell.cellImageView.layer setBorderWidth: 3];
            }
            else{
                [cell.cellImageView.layer setBorderColor: [[UIColor clearColor] CGColor]];
                [cell.cellImageView.layer setBorderWidth: 3];
            }



    if ([self sharedAppDelegate].imagesInCartArray.count != 0) {
        NSIndexPath *iPath = [[self sharedAppDelegate].imagesInCartArray objectAtIndex:indexPath.row];
        if (iPath.row == indexPath.row) {
            
            [cell.inCartCheck setFrame:CGRectMake(0, 0, 30, 30)];
            [cell.inCartCheck setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
            UIImage *img = [UIImage imageNamed:@"MW-Icon-CheckMark.svg.png"];
            cell.inCartCheck.image = img;
        }
    }
    return cell;

}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


NSIndexPath *selectedIndex;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Collection selected");
    ImageCollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
    BOOL stop = NO;

        if (cell.cellIsHighlighted == YES) {
            newSelection = YES;
            stop = YES;
            NSLog(@"highlighted");
            [cell.cellImageView.layer setBorderColor: [[UIColor clearColor] CGColor]];
            [cell.cellImageView.layer setBorderWidth: 3];
            cell.cellIsHighlighted = NO;
            [self.mutableHighlightedArray replaceObjectAtIndex:indexPath.row withObject:@""];
            [NSKeyedArchiver archiveRootObject:self.mutableHighlightedArray toFile:[self archiveHighlightedImages]];
            NSArray *cellArray = [self.mutableImageArray objectAtIndex:indexPath.row];
            NSArray *newArray = @[[cellArray objectAtIndex:0],[cellArray objectAtIndex:1], @"",];
            [self.mutableImageArray replaceObjectAtIndex:indexPath.row withObject:newArray];
            
        }
        if (cell.cellIsHighlighted == NO && stop == NO) {
            NSLog(@"not highlighted");
            newSelection = YES;
            [cell.cellImageView.layer setBorderColor: [[UIColor blueColor] CGColor]];
            [cell.cellImageView.layer setBorderWidth: 3];
            cell.cellIsHighlighted = YES;
            if ([self sharedAppDelegate].highlightedArray.count == 0) {
                cell.highlightedArrayIndex = 0;
            }
            else{
                cell.highlightedArrayIndex = [self sharedAppDelegate].highlightedArray.count;
            }
            if (![self sharedAppDelegate].highlightedArray) {
                [self sharedAppDelegate].highlightedArray = [[NSMutableArray alloc] init];
            }
            NSArray *cellArray = [self.mutableImageArray objectAtIndex:indexPath.row];
            NSArray *highlightedImageArray = @[[cellArray objectAtIndex:0],[cellArray objectAtIndex:1],];
            [self.mutableHighlightedArray replaceObjectAtIndex:indexPath.row withObject:@"Selected"];
            [NSKeyedArchiver archiveRootObject:self.mutableHighlightedArray toFile:[self archiveHighlightedImages]];
            [[self sharedAppDelegate].highlightedArray addObject:highlightedImageArray];
            [self.mutableImageArray replaceObjectAtIndex:indexPath.row withObject:highlightedImageArray];
        }


}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//     ImageCollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
//    cell.cellImageView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor clearColor]);
}

HighlightedImageCVC *imagevc;
- (IBAction)ToggleSelectedImages:(id)sender {
    if (loadingImages == NO) {
        if ([self sharedAppDelegate].highlightedArray.count != 0) {
            if (displayingHighlightedImages == NO) {
                displayingHighlightedImages = YES;
                if (imagevc) {
                    if (newSelection == YES) {
                        imagevc.highlightedImageArray = [self sharedAppDelegate].highlightedArray;
                        [imagevc.collectionView reloadData];
                    }
                    
                }
                else{
                    imagevc = [HighlightedImageCVC sharedHighlightedImageCVC];
                    imagevc.highlightedImageArray = [self sharedAppDelegate].highlightedArray;
                    int offset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
                    CGRect newFrame = CGRectOffset(imagevc.collectionView.frame, 0, offset);
                    
                    imagevc.collectionView.frame = newFrame;
                    [imagevc.collectionView reloadData];
                }
                
                newSelection = NO;
                [self.view addSubview:imagevc.collectionView];
                
            }
            else{
                displayingHighlightedImages = NO;
                [imagevc.collectionView removeFromSuperview];
            }
        }
    }


}




-(void)cellSelectedAtIndex:(NSIndexPath*)selectedImagePath{
    NSLog(@"here");
    selectedIndex = selectedImagePath;
    [self performSegueWithIdentifier:@"StartOrder1" sender:self];
}


-(void)removeHighlightedImagesFromView{
    
}
    
    
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Preparing for segue");
    
    if ([segue.identifier isEqualToString:@"StartOrder1"]) {
NSLog(@"Segueing");
        
//        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", returnbuttontitle) style:UIBarButtonItemStyleBordered target:nil action:nil];
//        self.navigationItem.backBarButtonItem = backButton;
        DetailsTVC *details = segue.destinationViewController;
        details.selectedImageIndex = selectedIndex;
        details.startingFromHighlightedImage = YES;
    }
}


- (NSString*)archiveHighlightedImages{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"highlighted"];
}


- (NSString*)archiveImageArray{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"ImageArray"];
}


@end
