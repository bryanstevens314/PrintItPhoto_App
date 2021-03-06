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
    
    //create long press gesture recognizer(gestureHandler will be triggered after gesture is detected)
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler:)];
    _longPressGesture.delegate = self;
    _longPressGesture.delaysTouchesBegan = YES;
    //adjust time interval(floating value CFTimeInterval in seconds)
    [_longPressGesture setMinimumPressDuration:0.5];
    //add gesture to view you want to listen for it(note that if you want whole view to "listen" for gestures you should add gesture to self.view instead)
    for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gestureRecognizer requireGestureRecognizerToFail:_longPressGesture];
        }
    }
    
    [self.collectionView addGestureRecognizer:_longPressGesture];
    
    _panGestureRecognizer1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer:)];
    _panGestureRecognizer1.delegate = self;
    [self.collectionView addGestureRecognizer:_panGestureRecognizer1];
}

BOOL started = NO;
-(void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
    NSLog(@"location: %f",touchLocation.x);
    if (touchLocation.x <= 40 && started == NO) {
        NSLog(@"started");
        started = YES;
        self.collectionView.frame = CGRectMake(touchLocation.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    }
    if (started == YES) {
        NSLog(@"Continueing");
        self.collectionView.frame = CGRectMake(touchLocation.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);

    }

    if(UIGestureRecognizerStateEnded == panGestureRecognizer.state)
    {
        if (started == YES) {
            if (touchLocation.x >= 160) {
                [UIView animateWithDuration:0.2 animations:^{
                    
                    self.collectionView.frame = CGRectMake(self.view.bounds.size.width, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
                    
                }completion:^(BOOL finished) {
                    [self.delegate userSwipedBack];
                    started = NO;
                }];
                
                
            }
            else{
                [UIView animateWithDuration:0.3 animations:^{
                    self.collectionView.frame = CGRectMake(self.view.bounds.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
                    started = NO;
                }];
            }
        }
    }
    
}





- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL simultaneous = NO;
    if ([_longPressGesture isEqual:gestureRecognizer]) {
        simultaneous = NO;
    }
    
    if (started == YES) {
        simultaneous = NO;
    }
    if (started == NO) {
        simultaneous = YES;
    }
    
    return simultaneous;
}


NSIndexPath *initialSelection;
-(void)gestureHandler:(UISwipeGestureRecognizer *)gesture
{
    
    if(UIGestureRecognizerStateBegan == gesture.state)
    {
        CGPoint location = [gesture locationInView:self.collectionView];
        NSIndexPath *removeIndexPath = [self.collectionView indexPathForItemAtPoint:location];
        initialSelection = removeIndexPath;
        ImageCollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:removeIndexPath];
        cell.imageViewCell.frame = CGRectMake(cell.imageViewCell.frame.origin.x-5, cell.imageViewCell.frame.origin.y-5, cell.imageViewCell.frame.size.width + 10, cell.imageViewCell.frame.size.height + 10);
    }
    if(UIGestureRecognizerStateEnded == gesture.state)
    {
        
        CGPoint location = [gesture locationInView:self.collectionView];
        NSIndexPath *removeIndexPath = [self.collectionView indexPathForItemAtPoint:location];
        if (initialSelection == removeIndexPath) {
            [[self sharedAppDelegate].highlightedArray removeObjectAtIndex:removeIndexPath.row];
            self.highlightedImageArray = nil;
            self.highlightedImageArray = [self sharedAppDelegate].highlightedArray;
            [self.collectionView reloadData];
        }
        else{
            NSLog(@"Ended selection");
            ImageCollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:initialSelection];
            cell.imageViewCell.frame = CGRectMake(cell.imageViewCell.frame.origin.x+5, cell.imageViewCell.frame.origin.y+5, cell.imageViewCell.frame.size.width - 10, cell.imageViewCell.frame.size.height - 10);
        }

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

    return self.highlightedImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"HighlightedCell";
    
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell.imageViewCell != nil) {
        [cell.imageViewCell removeFromSuperview];
        cell.imageViewCell = nil;
    }
    cell.imageViewCell = [[UIImageView alloc] init];
    
    NSArray *highlightedArray = [self.highlightedImageArray objectAtIndex:indexPath.row];
    UIImage *thumbImg = [highlightedArray objectAtIndex:1];
                     //UIImage *fullImg = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                     //                 if (self.collectionImgView) {
                     //                     self.collectionImgView = nil;
                     //                 }
                     float division = thumbImg.size.width/thumbImg.size.height;
                     if (thumbImg.size.width < thumbImg.size.height) {
                         NSLog(@"portrait");
                         
                         float newWidth = (cell.bounds.size.height - 5) * division;
                         
                         [cell.imageViewCell setFrame:CGRectMake(0, 0, newWidth, cell.bounds.size.height - 5)];
                         [cell.imageViewCell setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
                         cell.imageViewCell.image = thumbImg;
                         [cell.contentView addSubview:cell.imageViewCell];
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

    
//                     if ([self sharedAppDelegate].imagesInCartArray.count != 0) {
//                         NSURL *highlightedImageURL = [[self sharedAppDelegate].highlightedArray objectAtIndex:indexPath.row];
//                         NSURL *cartImageURL = [[self sharedAppDelegate].imagesInCartArray objectAtIndex:indexPath.row];
//                         if ([[cartImageURL absoluteString] isEqualToString:[highlightedImageURL absoluteString]]) {
//                             [cell.inCartCheck setFrame:CGRectMake(0, 0, 30, 30)];
//                             [cell.inCartCheck setCenter:CGPointMake(cell.bounds.size.width/2,cell.bounds.size.height/2)];
//                             UIImage *img = [UIImage imageNamed:@"MW-Icon-CheckMark.svg.png"];
//                             cell.inCartCheck.image = img;
//                         }
//
//                     }
    
                 


    
    

    
    NSLog(@"creating cell");
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Selected image");
    
    NSLog(@"Selected array: %@",[self.highlightedImageArray objectAtIndex:indexPath.row]);
    [self.delegate imageSelectedWithArray:[self.highlightedImageArray objectAtIndex:indexPath.row] andIndexPath:indexPath];

}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    NSLog(@"Preparing for segue");
//    if ([segue.identifier isEqualToString:@"StartOrderFromHighlightedImage"]) {
//        NSLog(@"Segueing");
//
//    }
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
