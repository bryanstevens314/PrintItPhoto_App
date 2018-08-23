//
//  ImageCollectionViewController.m
//  Metal Prints
//
//  Created by Bryan Stevens on 6/25/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "ImageCollectionViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "OrderOverViewTVC.h"

@interface ImageCollectionViewController (){
    BOOL newSelection;
}
@property (retain, nonatomic)NSMutableArray *mutImageArray;
@property (retain, nonatomic)NSMutableArray *mutHighlightedArray;
@property (retain, nonatomic)NSMutableArray *reverseImageArray;
@property (retain, nonatomic)NSMutableArray *reversePhoneImageArray;
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
        sharedInstance = (ImageCollectionViewController*)[storyboard instantiateViewControllerWithIdentifier: @"ImageCollectionView"];
    });
    return sharedInstance;
}


-(void)reloadTheCollectionView{
    NSLog(@"Reloading collectionView");
    
    if ([self sharedAppDelegate].phoneImageArray.count != 0) {
        loadingImages = YES;
        int x = 0;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        for (NSArray *imgArray1 in [self sharedAppDelegate].phoneImageArray) {
            x++;
            
            [library assetForURL:[imgArray1 objectAtIndex:0]
                     resultBlock:^(ALAsset *asset) {
                         
                         if (x < [self sharedAppDelegate].phoneImageArray.count) {
                             NSLog(@"Less than: %i",x);
                             
                             UIImage *thumbImg = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                             if (thumbImg == nil || thumbImg == NULL) {
                                 [[self sharedAppDelegate].phoneImageArray removeObjectAtIndex:x];
                             }else{
                                 [[self sharedAppDelegate].phoneImageArray insertObject:thumbImg atIndex:0];
                             }
                         }
                         if (x == [self sharedAppDelegate].phoneImageArray.count) {
                             NSLog(@"Equal to");
                             UIImage *thumbImg = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                             if (thumbImg == nil || thumbImg == NULL) {
                                 [[self sharedAppDelegate].phoneImageArray removeObjectAtIndex:x];
                             }else{
                                 [[self sharedAppDelegate].phoneImageArray insertObject:thumbImg atIndex:0];
                             }
                             
                             loadingImages = NO;
                             

                             [self.collectionView setNeedsDisplay];
                             
                             
                         }
                     }
             
                    failureBlock:^(NSError *error){
                        NSLog(@"operation was not successfull!");
                    }];
            
        }
    }
}

-(void)viewWillLayoutSubviews{
    
}
    

static NSString * const reuseIdentifier = @"Cell";
UIAlertController *loadingAlert;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Image View did load");
    UIImage *background = [UIImage imageNamed:@"Hamburger_icon.svg.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(toggleReveal) forControlEvents:UIControlEventTouchUpInside]; //adding action
    [button setBackgroundImage:background forState:UIControlStateNormal];
    button.frame = CGRectMake(0 ,0,35,30);
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    [self.navigationItem setTitle:@"My Photos"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:0.6];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.alpha = 0.93;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    loadingImages = YES;
    
    //create long press gesture recognizer(gestureHandler will be triggered after gesture is detected)
    _longPressGesture1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler1:)];
    _longPressGesture1.delegate = self;
    _longPressGesture1.delaysTouchesBegan = YES;
    //adjust time interval(floating value CFTimeInterval in seconds)
    [_longPressGesture1 setMinimumPressDuration:0.4];
    //add gesture to view you want to listen for it(note that if you want whole view to "listen" for gestures you should add gesture to self.view instead)
    for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gestureRecognizer requireGestureRecognizerToFail:_longPressGesture1];
        }
    }
    
    [self.collectionView addGestureRecognizer:_longPressGesture1];
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap1:)];
//    singleTap.numberOfTapsRequired = 1;
//    [self.collectionView  addGestureRecognizer:singleTap1];
    
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
//    doubleTap.numberOfTapsRequired = 2;
//    [self.collectionView  addGestureRecognizer:doubleTap];
//    
//    [singleTap requireGestureRecognizerToFail:doubleTap];

}





UITapGestureRecognizer *singleTap1;
BOOL revealed1 = NO;
-(void)toggleReveal{
    if (revealed1 == NO) {
        revealed1 = YES;
        //self.collectionView.userInteractionEnabled = NO;
        singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTapFunc:)];
        singleTap1.numberOfTapsRequired = 1;
        //singleTap1.cancelsTouchesInView = false;
        [self.collectionView  addGestureRecognizer:singleTap1];
        [self.revealViewController revealToggle];
    }
    else{
        revealed1 = NO;
        [self.revealViewController revealToggle];
        //self.collectionView.userInteractionEnabled = YES;
        [self.collectionView removeGestureRecognizer:singleTap1];
        singleTap1 = nil;
    }


}

-(void)SingleTapFunc:(UITapGestureRecognizer *)gesture{
    NSLog(@"SingleTapFunc");
    [self.revealViewController revealToggle];
    //self.collectionView.userInteractionEnabled = YES;
    [self.collectionView removeGestureRecognizer:singleTap1];
    singleTap1 = nil;
}


//-(void)SingleTap:(UITapGestureRecognizer *)gesture{
//    CGPoint location = [gesture locationInView:self.collectionView];
//    NSIndexPath *tappedIndexPath = [self.collectionView indexPathForItemAtPoint:location];
//    ImageCollectionViewCell *cell = [self.collectionView  cellForItemAtIndexPath:tappedIndexPath];
//    iPath = tappedIndexPath;
//    currentTempURL = cell.imgURL;
//    tempThumbImg = cell.imageViewCell.image;
//    [self performSegueWithIdentifier:@"addCartItem" sender:self];
//}

-(void)doubleTap:(UITapGestureRecognizer *)gesture{
    CGPoint location = [gesture locationInView:self.collectionView];
    NSIndexPath *tappedIndexPath = [self.collectionView indexPathForItemAtPoint:location];
    ImageCollectionViewCell *cell = [self.collectionView  cellForItemAtIndexPath:tappedIndexPath];
    BOOL stop = NO;
    
    if (cell.cellIsHighlighted == YES) {
        newSelection = YES;
        stop = YES;
        NSLog(@"highlighted");
        [cell.imageViewCell.layer setBorderColor: [[UIColor clearColor] CGColor]];
        [cell.imageViewCell.layer setBorderWidth: 3];
        cell.cellIsHighlighted = NO;
        
        NSLog(@"Indec: %ld",(long)cell.highlightedArrayIndex);
        NSArray *cellArray = [[self sharedAppDelegate].phoneImageArray objectAtIndex:tappedIndexPath.row];
        NSArray *highlightedImageArray = @[[cellArray objectAtIndex:0],@"",[cellArray objectAtIndex:2]];
        [[self sharedAppDelegate].highlightedArray removeObjectAtIndex:cell.highlightedArrayIndex];
        [[self sharedAppDelegate].phoneImageArray replaceObjectAtIndex:tappedIndexPath.row withObject:highlightedImageArray];
        cell.highlightedArrayIndex = 0;
    }
    if (cell.cellIsHighlighted == NO && stop == NO) {
        NSLog(@"not highlighted");
        newSelection = YES;
        [cell.imageViewCell.layer setBorderColor: [[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0] CGColor]];
        [cell.imageViewCell.layer setBorderWidth: 3];
        cell.cellIsHighlighted = YES;
        cell.highlightedArrayIndex = [self sharedAppDelegate].highlightedArray.count;
        
        NSArray *cellArray = [[self sharedAppDelegate].phoneImageArray objectAtIndex:tappedIndexPath.row];
        NSArray *highlightedImageArray = @[[cellArray objectAtIndex:0],@"YES",[cellArray objectAtIndex:2]];
        NSArray *highlightedImageArray1 = @[[cellArray objectAtIndex:0],[[self sharedAppDelegate].phoneImageArray objectAtIndex:tappedIndexPath.row]];
        [[self sharedAppDelegate].highlightedArray insertObject:highlightedImageArray1 atIndex:0];
        [[self sharedAppDelegate].phoneImageArray replaceObjectAtIndex:tappedIndexPath.row withObject:highlightedImageArray];
        
    }

}

CGRect initialRect;
UIImageView *bigImageView;
UIImageView *backgroungImageview;
NSIndexPath *firstSelectedIndexPath;
UIImageView *blurImageView;
-(void)gestureHandler1:(UISwipeGestureRecognizer *)gesture
{
    
    if(UIGestureRecognizerStateBegan == gesture.state)
    {
        
        CGPoint location = [gesture locationInView:self.collectionView];
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:location];
        firstSelectedIndexPath = selectedIndexPath;
        NSLog(@"Selected Image got here");
        ImageCollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:selectedIndexPath];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:cell.imgURL
                 resultBlock:^(ALAsset *asset) {
                     UIImage *fullImg = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                     NSLog(@"Image:%@",fullImg);
//                     CGRect screenRect = [[UIScreen mainScreen] bounds];
//                     UIGraphicsBeginImageContext(screenRect.size);
//                     CGContextRef ctx = UIGraphicsGetCurrentContext();
//                     [[UIColor blackColor] set];
//                     CGContextFillRect(ctx, screenRect);
//                     
//                     // grab reference to our window
//                     UIWindow *window = [UIApplication sharedApplication].keyWindow;
//                     
//                     // transfer content into our context
//                     [window.layer renderInContext:ctx];
//                     UIImage *screengrab = UIGraphicsGetImageFromCurrentImageContext();
//                     UIGraphicsEndImageContext();
//                     if (!blurImageView) {
//                         blurImageView = [[UIImageView alloc] initWithImage:[self blur:screengrab]];
//                         blurImageView.frame = CGRectMake(-50, -50, self.view.bounds.size.width+100, self.view.bounds.size.height+100);
//                     }
//                     else{
//                         blurImageView.image = [self blur:screengrab];
//                     }
                     //[[self sharedAppDelegate].window addSubview:blurImageView];
                    initialRect = cell.imageViewCell.frame;
                     float division = cell.imageViewCell.image.size.width/cell.imageViewCell.image.size.height;
                     
                     if (fullImg.size.width < fullImg.size.height) {
                         NSLog(@"portrait");
                         float newWidth = (self.view.bounds.size.height - 260) * division;
                         // create graphics context with screen size

                         
                         if (bigImageView) {
                             bigImageView = nil;
                         }
                         bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, newWidth, self.view.bounds.size.height - 260)];
                         bigImageView.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
                         bigImageView.image = fullImg;
                         [self.view addSubview:bigImageView];

                         
                     }
                     if (fullImg.size.width > fullImg.size.height) {
                         NSLog(@"landscape");
                         float newHeight = (self.view.bounds.size.width - 45) / division;
                         bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 45, newHeight)];
                         bigImageView.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
                         bigImageView.image = fullImg;
                         [self.view addSubview:bigImageView];
                     }
                     if (fullImg.size.width == fullImg.size.height) {
                         NSLog(@"square");
                         bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 50, self.view.bounds.size.width - 50)];
                         bigImageView.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
                         bigImageView.image = fullImg;
                         [self.view addSubview:bigImageView];
                     }
                 }
         
                failureBlock:^(NSError *error){
                    NSLog(@"operation was not successfull!");
                }];
        

    }
    if(UIGestureRecognizerStateEnded == gesture.state)
    {
        //NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:location];
        NSLog(@"Ended selection");
        ImageCollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:firstSelectedIndexPath];
        cell.imageViewCell.frame = initialRect;
        [bigImageView removeFromSuperview];
        [blurImageView removeFromSuperview];
        
    }
}


- (UIImage*) blur:(UIImage*)theImage
{
    // ***********If you need re-orienting (e.g. trying to blur a photo taken from the device camera front facing camera in portrait mode)
    // theImage = [self reOrientIfNeeded:theImage];
    
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
    
    // *************** if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}


- (UIImage *)blurImage{
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:7.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *retVal = [UIImage imageWithCGImage:cgImage];
    return retVal;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL simultaneous;
    if ([_longPressGesture1 isEqual:gestureRecognizer]) {
        simultaneous = NO;
    }

    
    return simultaneous;
}




UIActivityIndicatorView *activityIndicator;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];


    
    self.toggleOutlet.tintColor = [UIColor lightGrayColor];
    cartVC1 = [ShoppingCartTVC sharedShoppingCartTVC];
    cartVC1.delegate = self;
    proceedButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    proceedButton1.frame = CGRectMake(0, 0, 353, 50);
    proceedButton1.layer.cornerRadius = 2;
    proceedButton1.clipsToBounds = YES;
    [proceedButton1 addTarget:self action:@selector(EnterShipping1) forControlEvents:UIControlEventTouchUpInside];
    [proceedButton1 setTitle:@"Proceed with order" forState:UIControlStateNormal];
    proceedButton1.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:1];
    proceedButton1.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-35);

    
    if ([self sharedAppDelegate].displayingCart == YES) {

        [self sharedAppDelegate].displayingCart = YES;
        [self.navigationItem setTitle:@"Cart"];
        
        //self.switchViewsOutlet.image = [UIImage imageNamed:@"Home Icon.png"];
        [self.view addSubview:cartVC1.view];
        [self.view addSubview:proceedButton1];
        [self.view bringSubviewToFront:proceedButton1];

    }

}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    if ([self sharedAppDelegate].mutableImageArray.count == 0) {
//        loadingImages = YES;
//        int x = 0;
//        NSLog(@"%@",[self sharedAppDelegate].phoneImageArray);
//        for (NSArray *imgArray1 in [self sharedAppDelegate].phoneImageArray) {
//            x++;
//            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//            [library assetForURL:[imgArray1 objectAtIndex:0]
//                     resultBlock:^(ALAsset *asset) {
//                         
//                         if (x < [self sharedAppDelegate].phoneImageArray.count) {
//                             NSLog(@"Less than: %i",x);
//                             
//                             UIImage *thumbImg = [UIImage imageWithCGImage: [asset aspectRatioThumbnail]];
//                             if (thumbImg == nil || thumbImg == NULL) {
//                                 [[self sharedAppDelegate].phoneImageArray removeObjectAtIndex:x];
//                             }else{
//                                 [[self sharedAppDelegate].mutableImageArray addObject:thumbImg];
//                             }
//                         }
//                         if (x == [self sharedAppDelegate].phoneImageArray.count) {
//                             NSLog(@"Equal to");
//                             UIImage *thumbImg = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
//                             if (thumbImg == nil || thumbImg == NULL) {
//                                 [[self sharedAppDelegate].phoneImageArray removeObjectAtIndex:x];
//                             }else{
//                                 [[self sharedAppDelegate].mutableImageArray addObject:thumbImg];
//                             }
//                             
//                             loadingImages = NO;
//                             
//                             if (loadingAlert) {
//                                 [loadingAlert dismissViewControllerAnimated:YES completion:nil];
//                                 loadingAlert = nil;
//                             }
//                             
//                             [self.collectionView reloadData];
//                             
//                             
//                         }
//                     }
//             
//                    failureBlock:^(NSError *error){
//                        NSLog(@"operation was not successfull!");
//                    }];
//            
//        }
    

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    if (imagesPresenting1 == YES) {
        imagesPresenting1 = NO;
        [self.navigationItem setTitle:@"Store"];
        [proceedButton1 removeFromSuperview];
        //self.switchViewsOutlet.image = [UIImage imageNamed:@"Cart Icon.png"];
        [cartVC1.view removeFromSuperview];
        
    }
    
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

NSInteger numberOfCells = 0;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
//    if (reloadView == YES) {
//       numberOfCells = numberOfCells + 100;
//        if (numberOfCells > [self sharedAppDelegate].phoneImageArray.count) {
//            NSInteger sub = numberOfCells - [self sharedAppDelegate].phoneImageArray.count;
//            numberOfCells = numberOfCells - sub;
//        }
//    }
    if ([self sharedAppDelegate].loadingImages == YES) {
        numberOfCells = 0;
    }
    else{
        numberOfCells = [self sharedAppDelegate].phoneImageArray.count;
    }
    NSLog(@"Rows: %ld",(long)numberOfCells);
    return numberOfCells;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat size = width / 3;
    return CGSizeMake(size, size);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Creating cell");
    static NSString *identifier = @"Cell";
    
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell.imageViewCell != nil) {
        [cell.imageViewCell removeFromSuperview];
        cell.imageViewCell = nil;
    }
    cell.imageViewCell = [[UIImageView alloc] init];
    cell.imageViewCell.layer.cornerRadius = 2;
    cell.imageViewCell.clipsToBounds = YES;
    
    NSArray *urlImageArray = [[self sharedAppDelegate].phoneImageArray objectAtIndex:indexPath.row];
    cell.imgURL = [urlImageArray objectAtIndex:0];
    NSString *highlighted = [urlImageArray objectAtIndex:1];
    UIImage  *thumbImg = [urlImageArray objectAtIndex:2];
    //cell.cellImage = thumbImg;

    
    //cell.cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageViewCell.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageViewCell.clipsToBounds = YES;
//    cell.imageViewCell.frame  = CGRectMake(0, 0, cell.bounds.size.width-2, cell.bounds.size.width - 2);
//    cell.imageViewCell.center = CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2);
//    cell.imageViewCell.image = thumbImg;
//    [cell.contentView addSubview:cell.imageViewCell];
//    
//    float division = thumbImg.size.width/thumbImg.size.height;
//    
//    if (thumbImg.size.width < thumbImg.size.height) {
//        NSLog(@"portrait");
//        float newWidth = (cell.bounds.size.height - 5) * division;
//        cell.imageViewCell.frame  = CGRectMake(0, 0, newWidth, cell.bounds.size.height - 5);
//        cell.imageViewCell.center = CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2);
//        cell.imageViewCell.image = thumbImg;
//        [cell.contentView addSubview:cell.imageViewCell];
//        NSLog(@"ImageView 2 %@",cell.cellImageView);
//    }
//    if (thumbImg.size.width > thumbImg.size.height) {
//        NSLog(@"landscape");
//        float newHeight = (cell.bounds.size.width - 5) / division;
//        [cell.imageViewCell setFrame:CGRectMake(0, 0, cell.bounds.size.width - 5, newHeight)];
//        [cell.imageViewCell setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
//        cell.imageViewCell.image = thumbImg;
//        [cell.contentView addSubview:cell.imageViewCell];
//    }
//    if (thumbImg.size.width == thumbImg.size.height) {
//        NSLog(@"square");
        [cell.imageViewCell setFrame:CGRectMake(0, 0, cell.bounds.size.height - 2, cell.bounds.size.height - 2)];
        [cell.imageViewCell setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
        cell.imageViewCell.image = thumbImg;
        [cell.contentView addSubview:cell.imageViewCell];
    //}

    
    if ([highlighted isEqualToString:@"YES"]) {
        [cell.imageViewCell.layer setBorderColor: [[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0] CGColor]];
        [cell.imageViewCell.layer setBorderWidth: 3];
        cell.cellIsHighlighted = YES;
//        cell.highlightedArrayIndex = [[urlImageArray objectAtIndex:2] integerValue];
    }
    else{
        [cell.imageViewCell.layer setBorderColor: [[UIColor clearColor] CGColor]];
        [cell.imageViewCell.layer setBorderWidth: 3];
        cell.cellIsHighlighted = NO;
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


UIImage *tempImage;
NSIndexPath *selectedIndex;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Collection selected");

    ImageCollectionViewCell *cell = [self.collectionView  cellForItemAtIndexPath:indexPath];
    iPath = indexPath;
    currentTempURL = cell.imgURL;
    tempThumbImg = cell.imageViewCell.image;
    [self performSegueWithIdentifier:@"addCartItem" sender:self];
//
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
                        imagevc.highlightedImageArray = [self sharedAppDelegate].highlightedArray;
//                        int offset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
//                        CGRect newFrame = CGRectOffset(imagevc.collectionView.frame, 0, offset);
//                        
//                        imagevc.collectionView.frame = newFrame;
                        self.toggleOutlet.tintColor = [UIColor lightGrayColor];
                        [imagevc.collectionView reloadData];
                    }
                    
                }
                else{
                    imagevc = [HighlightedImageCVC sharedHighlightedImageCVC];
                    imagevc.delegate = self;
                    imagevc.highlightedImageArray = [self sharedAppDelegate].highlightedArray;
                    int offset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
                    CGRect newFrame = CGRectMake(imagevc.collectionView.frame.origin.x, imagevc.collectionView.frame.origin.y+offset, imagevc.collectionView.frame.size.width, imagevc.collectionView.frame.size.height-(self.navigationController.navigationBar.frame.size.height*2));
                    
                    imagevc.collectionView.frame = newFrame;
                    [imagevc.collectionView reloadData];
                    

                }
                NSLog(@"Displaying view");
                newSelection = NO;
                [self.toggleOutlet setTintColor:[UIColor blueColor]];
                [self.navigationItem setTitle:@"Favorited"];
                [self.view addSubview:imagevc.collectionView];
                
            }
            else{
                displayingHighlightedImages = NO;
                [self.navigationItem setTitle:@"Gallery"];
                [imagevc.collectionView removeFromSuperview];
            }
        }
    


}




-(void)cellSelectedAtIndex:(NSIndexPath*)selectedImagePath{
    NSLog(@"here");
    selectedIndex = selectedImagePath;
    //[self performSegueWithIdentifier:@"addCartItem" sender:self];

}


NSArray *imageSelectionData1;
- (void)SelectedRowWithData:(NSArray*)data{
    imageSelectionData1 = data;
    [self performSegueWithIdentifier:@"addCartItem" sender:self];
    
}


ShoppingCartTVC *cartVC1;
UIButton *proceedButton1;
BOOL imagesPresenting1;
- (IBAction)DisplayCart:(id)sender {
    
    if (cartVC1) {
        if ([self sharedAppDelegate].displayingCart == NO) {
            [self sharedAppDelegate].displayingCart = YES;
            [self.navigationItem setTitle:@"Cart"];
            
            //self.switchViewsOutlet.image = [UIImage imageNamed:@"Home Icon.png"];
            [self.view addSubview:cartVC1.view];
            [self.view addSubview:proceedButton1];
            [self.view bringSubviewToFront:proceedButton1];
            
        }
        else{
            [self sharedAppDelegate].displayingCart = NO;
            [self.navigationItem setTitle:@"Store"];
            [proceedButton1 removeFromSuperview];
            //self.switchViewsOutlet.image = [UIImage imageNamed:@"Cart Icon.png"];
            [cartVC1.view removeFromSuperview];
        }
    }
    else{
        [self sharedAppDelegate].displayingCart = YES;
        [self.navigationItem setTitle:@"Cart"];
        //self.switchViewsOutlet.image = [UIImage imageNamed:@"Home Icon.png"];
        cartVC1 = [ShoppingCartTVC sharedShoppingCartTVC];
        cartVC1.delegate = self;
        [self.view addSubview:cartVC1.view];
        if (proceedButton1) {
            NSLog(@"!!!!!!!!!!!!");
            [self.view addSubview:proceedButton1];
            [self.view bringSubviewToFront:proceedButton1];
        }
        else{
            NSLog(@"?????????");
            proceedButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
            proceedButton1.frame = CGRectMake(0, 0, 353, 50);
            proceedButton1.layer.cornerRadius = 2;
            proceedButton1.clipsToBounds = YES;
            [proceedButton1 addTarget:self action:@selector(EnterShipping1) forControlEvents:UIControlEventTouchUpInside];
            [proceedButton1 setTitle:@"Proceed with order" forState:UIControlStateNormal];
            proceedButton1.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:127.0/255.0 blue:184.0/255.0 alpha:1];
            proceedButton1.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-35);
            [self.view addSubview:proceedButton1];
            [self.view bringSubviewToFront:proceedButton1];
        }
    }
    
}




- (void)EnterShipping1 {
    
    if ([self sharedAppDelegate].shoppingCart.count != 0) {
        [self performSegueWithIdentifier:@"StartCheckOut1" sender:self];
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


NSArray *currentTempArray;
NSURL *currentTempURL;
UIImage *tempThumbImg;
NSIndexPath *iPath;
- (void)imageSelectedWithArray:(NSArray*)array andIndexPath:(NSIndexPath*)path{
    NSLog(@"Selected Image got here");
    currentTempArray = array;
    NSLog(@"Array: %@",array);
    NSLog(@"temp Array: %@",currentTempArray);
    iPath = path;
    [self performSegueWithIdentifier:@"addCartItem" sender:self];
}


-(void)removeHighlightedImagesFromView{
    
}

-(void)addedCartItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)userSwipedBack{
    [self.navigationItem setTitle:@"My Gallery"];
    [imagevc.collectionView removeFromSuperview];
    imagevc.collectionView.frame = CGRectMake(imagevc.view.bounds.origin.x, imagevc.collectionView.frame.origin.y, imagevc.collectionView.frame.size.width, imagevc.collectionView.frame.size.height);
    displayingHighlightedImages = NO;
}
    
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Preparing for segue");
    


    if ([segue.identifier isEqualToString:@"addCartItem"]) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"", returnbuttontitle) style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;

        if ([self sharedAppDelegate].cartIsMainController == YES) {
            NSLog(@"cartIsMainController");
            DetailsTVC *details = segue.destinationViewController;
            details.editingCartItem = YES;
            //NSArray *array5 = @[currentItem,indexPath,[NSString stringWithFormat:@"%ld",(long)selectedRow],@"YES"];
            details.selectedCartRow = [[imageSelectionData1 objectAtIndex:2] integerValue];
            details.selectedImageIndex = [imageSelectionData1 objectAtIndex:1];
        }
        else{
            NSLog(@"else");
            DetailsTVC *details = segue.destinationViewController;
            details.delegate = self;
            details.selectedImageIndex = iPath;
            details.startingFromHighlightedImage = YES;
            details.selectedImageURL = currentTempURL;
            details.thumbImg = tempThumbImg;
        }
        //        details.currentImage = tempImage;
        //        NSLog(@"temp Array: %@",currentTempArray);
        //        NSLog(@"temp Array: %@",details.currentImageArray);
    }
    if ([segue.identifier isEqualToString:@"StartCheckOut1"]) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"", returnbuttontitle) style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        
        OrderOverViewTVC *orderOverView = segue.destinationViewController;
        orderOverView.displayedIt = NO;
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



- (NSString*)archiveHighlightedImagesArray{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"ActualImageArray"];
}


@end
