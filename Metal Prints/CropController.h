//
//  CropController.h
//  Metal Prints
//
//  Created by Bryan Stevens on 11/4/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CropController;

@protocol CropControllerDelegate

- (void)FinishedCroppingImageWithImage:(UIImage*)croppedImage;

@end


@interface CropController : UIViewController

@property (weak, nonatomic) id<CropControllerDelegate> delegate;
- (IBAction)RotateCrop:(id)sender;
@property (retain, nonatomic) UIView *cropView;

@property (retain, nonatomic) UIImage *cropImage;
@property (nonatomic) float cropRatio;
@end
