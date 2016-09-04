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


-(void)reloadTheCollectionView{
    NSLog(@"Reloading collectionView");
    
    if ([self sharedAppDelegate].theNewImageArray.count != 0) {
        loadingImages = YES;
        int x = 0;
        for (NSArray *imgArray1 in [self sharedAppDelegate].theNewImageArray) {
            x++;
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library assetForURL:[imgArray1 objectAtIndex:0]
                     resultBlock:^(ALAsset *asset) {
                         
                         if (x < [self sharedAppDelegate].theNewImageArray.count) {
                             NSLog(@"Less than: %i",x);
                             
                             UIImage *thumbImg = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                             if (thumbImg == nil || thumbImg == NULL) {
                                 [[self sharedAppDelegate].phoneImageArray removeObjectAtIndex:x];
                             }else{
                                 [[self sharedAppDelegate].mutableImageArray insertObject:thumbImg atIndex:0];
                             }
                         }
                         if (x == [self sharedAppDelegate].theNewImageArray.count) {
                             NSLog(@"Equal to");
                             UIImage *thumbImg = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
                             if (thumbImg == nil || thumbImg == NULL) {
                                 [[self sharedAppDelegate].phoneImageArray removeObjectAtIndex:x];
                             }else{
                                 [[self sharedAppDelegate].mutableImageArray insertObject:thumbImg atIndex:0];
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
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

    //[self.navigationItem setTitle:@"My Gallery"];
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
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.collectionView  addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.collectionView  addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];

}


-(void)SingleTap:(UITapGestureRecognizer *)gesture{
    CGPoint location = [gesture locationInView:self.collectionView];
    NSIndexPath *tappedIndexPath = [self.collectionView indexPathForItemAtPoint:location];
    ImageCollectionViewCell* cell = [self.collectionView  cellForItemAtIndexPath:tappedIndexPath];
    currentTempArray = [[self sharedAppDelegate].phoneImageArray objectAtIndex:tappedIndexPath.row];
    iPath = tappedIndexPath;
    tempImage = [[self sharedAppDelegate].mutableImageArray objectAtIndex:tappedIndexPath.row];
    [self performSegueWithIdentifier:@"addCartItem" sender:self];
}

-(void)doubleTap:(UITapGestureRecognizer *)gesture{
    CGPoint location = [gesture locationInView:self.collectionView];
    NSIndexPath *tappedIndexPath = [self.collectionView indexPathForItemAtPoint:location];
    ImageCollectionViewCell* cell = [self.collectionView  cellForItemAtIndexPath:tappedIndexPath];
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
        NSArray *highlightedImageArray = @[[cellArray objectAtIndex:0],@""];
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
        NSArray *highlightedImageArray = @[[cellArray objectAtIndex:0],@"YES"];
        NSArray *highlightedImageArray1 = @[[cellArray objectAtIndex:0],[[self sharedAppDelegate].mutableImageArray objectAtIndex:tappedIndexPath.row]];
        [[self sharedAppDelegate].highlightedArray insertObject:highlightedImageArray1 atIndex:0];
        [[self sharedAppDelegate].phoneImageArray replaceObjectAtIndex:tappedIndexPath.row withObject:highlightedImageArray];
        
    }

}

CGRect initialRect;
UIImageView *bigImageView;
UIImageView *backgroungImageview;
NSIndexPath *firstSelectedIndexPath;
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
                    initialRect = cell.imageViewCell.frame;
                     float division = cell.imageViewCell.frame.size.width/cell.imageViewCell.frame.size.height;
                     
                     if (fullImg.size.width < fullImg.size.height) {
                         NSLog(@"portrait");
                         float newWidth = (self.view.bounds.size.height - 315) * division;
                         bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, newWidth, self.view.bounds.size.height - 315)];
                         bigImageView.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
                         bigImageView.image = fullImg;
                         //            UIImage *blurredImage = [self blurImage];
                         //            backgroungImageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
                         //            backgroungImageview.image = blurredImage;
                         //            [self.view addSubview:backgroungImageview];
                         [self.view addSubview:bigImageView];
                     }
                     if (fullImg.size.width > fullImg.size.height) {
                         NSLog(@"landscape");
                         float newHeight = (self.view.bounds.size.width - 90) / division;
                         bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 90, newHeight)];
                         bigImageView.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
                         bigImageView.image = fullImg;
                         [self.view addSubview:bigImageView];
                     }
                     if (fullImg.size.width == fullImg.size.height) {
                         NSLog(@"square");
                         bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 100, self.view.bounds.size.width - 100)];
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
        
        CGPoint location = [gesture locationInView:self.collectionView];
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:location];
        NSLog(@"Ended selection");
        ImageCollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:firstSelectedIndexPath];
        cell.imageViewCell.frame = initialRect;
        [bigImageView removeFromSuperview];
        
    }
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
    
//    if ([self sharedAppDelegate].mutableImageArray.count == 0) {
//        loadingAlert = [UIAlertController alertControllerWithTitle:@""
//                                                           message:@"Loading Images"
//                                                    preferredStyle:UIAlertControllerStyleAlert]; // 1
//        
//        UIViewController *customVC     = [[UIViewController alloc] init];
//        [loadingAlert.view setFrame:CGRectMake(0, 300, 320, 275)];
//        
//        UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [spinner startAnimating];
//        [customVC.view addSubview:spinner];
//        [spinner setCenter:CGPointMake(100, 27)];
//        
//        [customVC.view addConstraint:[NSLayoutConstraint
//                                      constraintWithItem: spinner
//                                      attribute:NSLayoutAttributeCenterX
//                                      relatedBy:NSLayoutRelationEqual
//                                      toItem:customVC.view
//                                      attribute:NSLayoutAttributeCenterX
//                                      multiplier:1.0f
//                                      constant:0.0f]];
//        
//        
//        [loadingAlert setValue:customVC forKey:@"contentViewController"];
//        [self presentViewController:loadingAlert animated:YES completion:nil];
//    }
    

    
//    int x = 0;
//    loadingImages = YES;
//    for (NSURL *imgURL in [self sharedAppDelegate].phoneImageArray) {
//        //NSLog(@"%@",imgURL);
//        
//        x++;
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        [library assetForURL:imgURL
//                 resultBlock:^(ALAsset *asset) {
//                     
//                     if (x != [self sharedAppDelegate].phoneImageArray.count) {
//                         
//                         UIImage *thumbImg = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
//                         NSLog(@"Width %f Height %f",thumbImg.size.width, thumbImg.size.height);
//                         NSArray *anArray = @[thumbImg,imgURL, @""];
//                         [[self sharedAppDelegate].mutableImageArray addObject:anArray];
//                         [self.mutableHighlightedArray addObject:@""];
//                     }
//                     if (x == [self sharedAppDelegate].phoneImageArray.count) {
//                         NSLog( @"Number of cells: %i",x);
//                         UIImage *thumbImg = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
//                         NSArray *anArray = @[thumbImg,imgURL,@""];
//                         [[self sharedAppDelegate].mutableImageArray addObject:anArray];
//                         [self.mutableHighlightedArray addObject:@""];
//
//                         
//                         loadingImages = NO;
//                         reloadView = YES;
//                         [self.collectionView reloadData];
//                     }
//                     
//                     //UIImage *fullImg = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
//                     //                 if (self.collectionImgView) {
//                     //                     self.collectionImgView = nil;
//                     //                 }
//                     
//                 }
//         
//                failureBlock:^(NSError *error){
//                    NSLog(@"operation was not successfull!");
//                }];
//    }

    
    //    if (loadingImages == YES) {
//        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        activityIndicator.frame = CGRectMake(0.0, 0.0, 40, 40.0);
//        activityIndicator.center = self.view.center;
//        CGAffineTransform transform = CGAffineTransformMakeScale(1.25f, 1.25f);
//        activityIndicator.transform = transform;
//        [self.view addSubview: activityIndicator];
//        [activityIndicator startAnimating];
//    }

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
    return numberOfCells;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell.imageViewCell != nil) {
        [cell.imageViewCell removeFromSuperview];
        cell.imageViewCell = nil;
    }
    cell.imageViewCell = [[UIImageView alloc] init];
    
    UIImage  *thumbImg = [[self sharedAppDelegate].mutableImageArray objectAtIndex:indexPath.row];
    NSArray *urlImageArray = [[self sharedAppDelegate].phoneImageArray objectAtIndex:indexPath.row];
    cell.imgURL = [urlImageArray objectAtIndex:0];
    NSLog(@"%lu",(unsigned long)[self sharedAppDelegate].mutableImageArray.count);
    NSLog(@"%lu",(unsigned long)[self sharedAppDelegate].phoneImageArray.count);
    NSString *highlighted = [urlImageArray objectAtIndex:1];
    //cell.cellImage = thumbImg;

    
    //cell.cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    float division = thumbImg.size.width/thumbImg.size.height;
    
    if (thumbImg.size.width < thumbImg.size.height) {
        NSLog(@"portrait");
        NSLog(@"ImageView %@",cell.cellImageView);
        float newWidth = (cell.bounds.size.height - 5) * division;
        cell.imageViewCell.frame  = CGRectMake(0, 0, newWidth, cell.bounds.size.height - 5);
        cell.imageViewCell.center = CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2);
        cell.imageViewCell.image = thumbImg;
        [cell.contentView addSubview:cell.imageViewCell];
        NSLog(@"ImageView 2 %@",cell.cellImageView);
    }
    if (thumbImg.size.width > thumbImg.size.height) {
        NSLog(@"landscape");
        float newHeight = (cell.bounds.size.width - 5) / division;
        [cell.imageViewCell setFrame:CGRectMake(0, 0, cell.bounds.size.width - 5, newHeight)];
        [cell.imageViewCell setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
        cell.imageViewCell.image = thumbImg;
        [cell.contentView addSubview:cell.imageViewCell];
    }
    if (thumbImg.size.width == thumbImg.size.height) {
        NSLog(@"square");
        [cell.imageViewCell setFrame:CGRectMake(0, 0, cell.bounds.size.height - 20, cell.bounds.size.height - 20)];
        [cell.imageViewCell setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
        cell.imageViewCell.image = thumbImg;
        [cell.contentView addSubview:cell.imageViewCell];
    }

    
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
                    CGRect newFrame = CGRectOffset(imagevc.collectionView.frame, 0, offset);
                    
                    imagevc.collectionView.frame = newFrame;
                    [imagevc.collectionView reloadData];
                    

                }
                NSLog(@"Displaying view");
                newSelection = NO;
                [self.toggleOutlet setTintColor:[UIColor blueColor]];
                [self.navigationItem setTitle:@"Highlighted Images"];
                [self.view addSubview:imagevc.collectionView];
                
            }
            else{
                displayingHighlightedImages = NO;
                [self.navigationItem setTitle:@"My Gallery"];
                [imagevc.collectionView removeFromSuperview];
            }
        }
    


}




-(void)cellSelectedAtIndex:(NSIndexPath*)selectedImagePath{
    NSLog(@"here");
    selectedIndex = selectedImagePath;
    //[self performSegueWithIdentifier:@"addCartItem" sender:self];

}


NSArray *currentTempArray;
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
NSLog(@"Segueing");
        
//        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", returnbuttontitle) style:UIBarButtonItemStyleBordered target:nil action:nil];
//        self.navigationItem.backBarButtonItem = backButton;
        DetailsTVC *details = segue.destinationViewController;

    }
    if ([segue.identifier isEqualToString:@"addCartItem"]) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", returnbuttontitle) style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        DetailsTVC *details = segue.destinationViewController;
        details.delegate = self;
        details.selectedImageIndex = iPath;
        details.startingFromHighlightedImage = YES;
        details.currentImageArray = currentTempArray;
        details.currentImage = tempImage;
        NSLog(@"temp Array: %@",currentTempArray);
        NSLog(@"temp Array: %@",details.currentImageArray);
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
