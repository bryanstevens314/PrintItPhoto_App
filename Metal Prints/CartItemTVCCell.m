//
//  CartItemTVCCell.m
//  Metal Prints
//
//  Created by Bryan Stevens on 9/15/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "CartItemTVCCell.h"
#import "AppDelegate.h"

@implementation CartItemTVCCell



- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

UIViewController *imageController;
- (IBAction)view_Image:(id)sender {
    NSLog(@"!!!");
//    array = @[product,
//              self.Quantity_TextField.text,
//              price,
//              @"",
//              self.For_Aluminum_TextField.text,
//              self.textView.text,
//              [self.selectedImageURL absoluteString],
//              imgString,
//              [NSString stringWithFormat:@"%li",(long)self.selectedRow],
//              [NSString stringWithFormat:@"%li",(long)self.selectedSection1]
//              ];
    
    
    imageController = [[UIViewController alloc] init];
    imageController.view.frame = [self sharedAppDelegate].window.frame;
    imageController.view.backgroundColor = [UIColor blackColor];

    
    NSIndexPath *iPath = [NSIndexPath indexPathForRow:self.view_Image_Outlet.tag inSection:1];
    NSLog(@"%li",(long)self.view_Image_Outlet.tag);
    NSArray *array = [[self sharedAppDelegate].shoppingCart objectAtIndex:iPath.row];
        NSData *data = [[NSData alloc]initWithBase64EncodedString:[array objectAtIndex:7] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image1 = [UIImage imageWithData:data];
    float ratio = image1.size.width  /image1.size.height;
    if (image1.size.width < image1.size.height) {
        NSLog(@"portrait");
        int xy = [self sharedAppDelegate].window.frame.size.width-60;
        float newHeight =  xy / ratio;
        UIImageView *imageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self sharedAppDelegate].window.frame.size.width-60, newHeight)];
        imageImageView.center = CGPointMake([self sharedAppDelegate].window.bounds.size.width/2, [self sharedAppDelegate].window.bounds.size.height/2);
        imageImageView.image = image1;
        NSLog(@"Image:%@",image1);
        [imageController.view addSubview:imageImageView];
    }
    if (image1.size.width > image1.size.height) {
        NSLog(@"landscape");
        float newWidth = [self sharedAppDelegate].window.frame.size.height-150 * ratio;
        UIImageView *imageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, newWidth, [self sharedAppDelegate].window.frame.size.height-150)];
        imageImageView.center = CGPointMake([self sharedAppDelegate].window.bounds.size.width/2, [self sharedAppDelegate].window.bounds.size.height/2);
        imageImageView.image = image1;
        NSLog(@"Image:%@",image1);
        [imageController.view addSubview:imageImageView];
    }
    if (image1.size.width == image1.size.height) {
        NSLog(@"square");
        UIImageView *imageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self sharedAppDelegate].window.frame.size.width-75, [self sharedAppDelegate].window.frame.size.width-75)];
        imageImageView.center = CGPointMake([self sharedAppDelegate].window.bounds.size.width/2, [self sharedAppDelegate].window.bounds.size.height/2);
        imageImageView.image = image1;
        NSLog(@"Image:%@",image1);
        [imageController.view addSubview:imageImageView];
    }

    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap1:)];
    singleTap.numberOfTapsRequired = 1;
    [imageController.view  addGestureRecognizer:singleTap];
    
    [[self sharedAppDelegate].window.rootViewController.view addSubview:imageController.view];
    
}


-(void)SingleTap1:(UITapGestureRecognizer *)gesture{
    [imageController.view removeFromSuperview];
}
@end
