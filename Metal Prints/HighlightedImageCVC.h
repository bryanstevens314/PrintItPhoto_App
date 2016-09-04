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
-(void)userSwipedBack;

@end

@interface HighlightedImageCVC : UICollectionViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) id<HighlightedImageCVCDelegate> delegate;

    + (HighlightedImageCVC *)sharedHighlightedImageCVC;
@property (strong, nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer1;
@property (strong, nonatomic, readonly) UILongPressGestureRecognizer *longPressGesture;
@property (strong, nonatomic) IBOutlet UICollectionView *highlightedImageCollectionView;
@property (retain, nonatomic) NSMutableArray *highlightedImageArray;
@end
