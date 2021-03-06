//
//  ImageCollectionViewCell.h
//  Metal Prints
//
//  Created by Bryan Stevens on 7/18/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (nonatomic) BOOL cellIsHighlighted;
@property (nonatomic) NSInteger highlightedArrayIndex;
@property (weak, nonatomic) IBOutlet UIImageView *inCartCheck;
@property (retain, nonatomic) UIImageView *imageViewCell;
@property (weak, nonatomic) UIImage *cellImage;
@property (weak, nonatomic) UIImage *fullImage;
@property (weak, nonatomic) NSURL *imgURL;
@end
