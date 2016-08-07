//
//  CartTVCCell.m
//  Metal Prints
//
//  Created by Bryan Stevens on 4/25/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "CartTVCCell.h"
#import "AppDelegate.h"

@implementation CartTVCCell

- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (id) init
{
    self = [super initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"cartCell"];
    if ( self != nil )
    {
        self.instructionsOutlet = [[UILabel alloc] initWithFrame:CGRectMake(269, 117, 91, 55)];
        self.instructions_TextView = [[UITextView alloc] initWithFrame:CGRectMake(1, 36, 101, 76)];
        [self.contentView addSubview: self.instructions_TextView];
        [self.contentView addSubview: self.instructionsOutlet];
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    // dynamic layout logic:
//    if ([self.imageSizeType isEqualToString:@"<"]) {
//        NSLog(@"got here <");
//        //        CGRect textViewFrame = cell.instructions_TextView.frame;
//        //        CGRect newframe2 = CGRectMake(textViewFrame.origin.x, y, textViewFrame.size.width, textViewFrame.size.height);
//        //        cell.instructions_TextView.frame = newframe2;
//        cell.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 22, 93.75, 125)];
//    }
//    if ([self.imageSizeType isEqualToString:@"?"]) {
//        NSLog(@">");
//        cell.imageSizeType = @">";
//        cell.instructions_TextView = [[UITextView alloc] initWithFrame:CGRectMake(23, 146, 337, 55)];
//        
//        cell.instructionsOutlet = [[UILabel alloc] initWithFrame:CGRectMake(269, 117, 91, 55)];
//        cell.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 36, 101, 76)];
//    }
    if ([self.imageSizeType isEqualToString:@"="]) {
        NSLog(@"got here=");
        CGRect newframe2 = CGRectMake(23, 125, 337, 55);
        CGRect newframe3 = CGRectMake(269, 105, 91, 55);
        self.instructions_TextView.frame = newframe2;
        self.instructionsOutlet.frame = newframe3;
    }
}
@end
