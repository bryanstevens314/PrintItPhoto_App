//
//  ImageCollectionViewCell.m
//  Metal Prints
//
//  Created by Bryan Stevens on 7/18/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

-(void)layoutSubviews{
    NSLog(@"Laying Out Images");
    
//    float division = self.cellImage.size.width/self.cellImage.size.height;
//    
//    if (self.cellImage.size.width < self.cellImage.size.height) {
//        NSLog(@"portrait");
//        NSLog(@"ImageView %@",self.cellImageView);
//        float newWidth = (self.bounds.size.height - 5) * division;
//        [self.cellImageView setFrame:CGRectMake(0, 0, newWidth, self.bounds.size.height - 5)];
//        [self.cellImageView setCenter:CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2)];
//        [self.cellImageView setImage:self.cellImage];
//        
//        NSLog(@"ImageView 2 %@",self.cellImageView);
//    }
//    if (self.cellImage.size.width > self.cellImage.size.height) {
//        NSLog(@"landscape");
//        float newHeight = (self.bounds.size.width - 5) / division;
//        [self.cellImageView setFrame:CGRectMake(0, 0, self.bounds.size.width - 5, newHeight)];
//        [self.cellImageView setCenter:CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2)];
//        self.cellImageView.image = self.cellImage;
//    }
//    if (self.cellImage.size.width == self.cellImage.size.height) {
//        NSLog(@"square");
//        [self.cellImageView setFrame:CGRectMake(0, 0, self.bounds.size.height - 20, self.bounds.size.height - 20)];
//        [self.cellImageView setCenter:CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2)];
//        self.cellImageView.image = self.cellImage;
//    }

    
}

@end
