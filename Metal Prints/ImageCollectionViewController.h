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

@interface ImageCollectionViewController : UICollectionViewController{
    BOOL reloadView;
    BOOL loadingImages;
}

+ (ImageCollectionViewController *)sharedImageCollectionViewController;
-(void)removeHighlightedImagesFromView;
-(void)cellSelectedAtIndex:(NSIndexPath*)selectedImagePath;
- (IBAction)ToggleSelectedImages:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleOutlet;
@property (retain,nonatomic)UIImageView *collectionImgView;
@property (retain,nonatomic)NSMutableArray *mutableImageArray;
@property (retain,nonatomic)NSMutableArray *mutableHighlightedArray;
@property (retain,nonatomic)NSMutableArray *mutableHighlightedImageArray;
@property (weak, nonatomic) IBOutlet UIImageView *inCartCheck;
@end
