//
//  HighlightedImageCVC.h
//  Metal Prints
//
//  Created by Bryan Stevens on 7/29/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageCollectionViewController.h"
#import "ImageCollectionViewCell.h"

@interface HighlightedImageCVC : UICollectionViewController

    + (HighlightedImageCVC *)sharedHighlightedImageCVC;
    
    @property (strong, nonatomic) IBOutlet UICollectionView *highlightedImageCollectionView;
    @property (retain, nonatomic) NSMutableArray *highlightedImageArray;
@end
