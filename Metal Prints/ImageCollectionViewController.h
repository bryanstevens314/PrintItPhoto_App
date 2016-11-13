//
//  ImageCollectionViewController.h
//  Metal Prints
//
//  Created by Bryan Stevens on 6/25/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//


#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageCollectionViewCell.h"
#import <UIKit/UIKit.h>
#import "DetailsTVC.h"
#import "HighlightedImageCVC.h"
#import "ShoppingCartTVC.h"

@class ImageCollectionViewController;

@protocol ImageCollectionViewControllerDelegate

- (void)SelectedImageWithData:(NSArray*)data;

@end


@interface ImageCollectionViewController : UICollectionViewController <HighlightedImageCVCDelegate,DetailsTVCDelegate,ShoppingCartTVCDelegate,UIGestureRecognizerDelegate>{
    BOOL reloadView;
    BOOL loadingImages;
}
@property (weak, nonatomic) id<ImageCollectionViewControllerDelegate> delegate;
+ (ImageCollectionViewController *)sharedImageCollectionViewController;


-(void)reloadTheCollectionView;
-(void)removeHighlightedImagesFromView;
-(void)cellSelectedAtIndex:(NSIndexPath*)selectedImagePath;
- (IBAction)DisplayCart:(id)sender;
- (IBAction)ToggleSelectedImages:(id)sender;
@property (strong, nonatomic, readonly) UILongPressGestureRecognizer *longPressGesture1;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleOutlet;
@property (retain,nonatomic)UIImageView *collectionImgView;

@property (retain,nonatomic)NSMutableArray *mutableHighlightedArray;
@property (retain,nonatomic)NSMutableArray *mutableHighlightedImageArray;
@property (weak, nonatomic) IBOutlet UIImageView *inCartCheck;
@end
