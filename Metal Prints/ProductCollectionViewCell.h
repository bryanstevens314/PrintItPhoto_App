//
//  ProductCollectionViewCell.h
//  Metal Prints
//
//  Created by Bryan Stevens on 8/10/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (retain, nonatomic) UIImageView *theProductImage;
@end
