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


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"number of items");

    return [self sharedAppDelegate].mutableArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:[[self sharedAppDelegate].mutableArray objectAtIndex:indexPath.row]
                 resultBlock:^(ALAsset *asset) {
                     UIImage *thumbImg = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                     //UIImage *fullImg = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                     //                 if (self.collectionImgView) {
                     //                     self.collectionImgView = nil;
                     //                 }
                     if (thumbImg.size.width < thumbImg.size.height) {
                         NSLog(@"<");
                         [cell.cellImageView setFrame:CGRectMake(0, 0, thumbImg.size.width/2.9, thumbImg.size.height/2.9)];
                         if (cell.cellImageView.frame.size.width >= cell.contentView.frame.size.width || cell.cellImageView.frame.size.height >= cell.contentView.frame.size.height) {
                             [cell.cellImageView setFrame:CGRectMake(0, 0, thumbImg.size.width/3.4, thumbImg.size.height/3.4)];
                         }
                     }
                     if (thumbImg.size.width > thumbImg.size.height) {
                         NSLog(@">");
                         [cell.cellImageView setFrame:CGRectMake(0, 0, thumbImg.size.width/2.9, thumbImg.size.height/2.9)];
                         if (cell.cellImageView.frame.size.width >= cell.contentView.frame.size.width || cell.cellImageView.frame.size.height >= cell.contentView.frame.size.height) {
                             [cell.cellImageView setFrame:CGRectMake(0, 0, thumbImg.size.width/3.4, thumbImg.size.height/3.4)];
                         }
                     }
                     if (thumbImg.size.width == thumbImg.size.height) {
                         NSLog(@"==");
                         [cell.cellImageView setFrame:CGRectMake(0, 0, thumbImg.size.width/2.2, thumbImg.size.height/2.2)];
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
                     if ([self sharedAppDelegate].highlightedArray != nil) {
                         for (NSArray *anotherArray in [self sharedAppDelegate].highlightedArray) {


                                 NSURL *highlightedURL = [anotherArray objectAtIndex:0];
                                 NSURL *currentImageURL = [[self sharedAppDelegate].mutableArray objectAtIndex:indexPath.row];
                                 
                                 if ([[highlightedURL absoluteString] isEqualToString:[currentImageURL absoluteString]]) {

                                     [cell.cellImageView.layer setBorderColor: [[UIColor blueColor] CGColor]];
                                     [cell.cellImageView.layer setBorderWidth: 4];
                                 }
                             
                         }


                     }
                 }
         
                failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
    


    if ([self sharedAppDelegate].imagesInCartArray.count != 0) {
        NSIndexPath *iPath = [[self sharedAppDelegate].imagesInCartArray objectAtIndex:indexPath.row];
        if (iPath.row == indexPath.row) {
            
            [cell.inCartCheck setFrame:CGRectMake(0, 0, 30, 30)];
            [cell.inCartCheck setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
            UIImage *img = [UIImage imageNamed:@"MW-Icon-CheckMark.svg.png"];
            cell.inCartCheck.image = img;
        }
    }
    NSLog(@"creating cell");
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
            [cell.cellImageView.layer setBorderWidth: 4];
            cell.cellIsHighlighted = NO;
            NSIndexPath *removePath = [NSIndexPath indexPathForRow:cell.highlightedArrayIndex inSection:0];
            [[self sharedAppDelegate].highlightedArray removeObjectAtIndex:removePath.row];
            [NSKeyedArchiver archiveRootObject:[self sharedAppDelegate].highlightedArray toFile:[self archiveHighlightedImages]];
        }
        if (cell.cellIsHighlighted == NO && stop == NO) {
            NSLog(@"not highlighted");
            newSelection = YES;
            [cell.cellImageView.layer setBorderColor: [[UIColor blueColor] CGColor]];
            [cell.cellImageView.layer setBorderWidth: 4];
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
            NSURL *highlightedURL = [[self sharedAppDelegate].mutableArray objectAtIndex:indexPath.row];
            NSArray *objArray = @[highlightedURL, indexPath];
            [[self sharedAppDelegate].highlightedArray addObject:objArray];
            [NSKeyedArchiver archiveRootObject:[self sharedAppDelegate].highlightedArray toFile:[self archiveHighlightedImages]];
        }


}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//     ImageCollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
//    cell.cellImageView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor clearColor]);
}

HighlightedImageCVC *imagevc;
- (IBAction)ToggleSelectedImages:(id)sender {
    if ([self sharedAppDelegate].highlightedArray.count != 0) {
        if (displayingHighlightedImages == NO) {
            displayingHighlightedImages = YES;
            if (imagevc) {
                if (newSelection == YES) {
                    [imagevc.collectionView reloadData];
                }
                
            }
            else{
                imagevc = [HighlightedImageCVC sharedHighlightedImageCVC];
                int offset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
                CGRect newFrame = CGRectOffset(imagevc.collectionView.frame, 0, offset);
                
                imagevc.collectionView.frame = newFrame;
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


@end
