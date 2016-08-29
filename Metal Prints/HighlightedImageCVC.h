//
//  HighlightedImageCVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 7/29/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageCollectionViewCell.h"

@class HighlightedImageCVC;

@protocol HighlightedImageCVCDelegate

- (void)imageSelectedWithArray:(NSArray*)array andIndexPath:(NSIndexPath*)path;
-(void)addedCartItem;

@end

@interface HighlightedImageCVC : UICollectionViewController
@property (weak, nonatomic) id<HighlightedImageCVCDelegate> delegate;

    + (HighlightedImageCVC *)sharedHighlightedImageCVC;
    
    @property (strong, nonatomic) IBOutlet UICollectionView *highlightedImageCollectionView;
    @property (retain, nonatomic) NSMutableArray *highlightedImageArray;
@end
