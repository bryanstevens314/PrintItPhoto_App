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


- (IBAction)addToQuantity:(id)sender {
    int quan = [self.quantity_TextField.text intValue];
    [self sharedAppDelegate].cartPrintTotal = [self sharedAppDelegate].cartPrintTotal - quan;
    quan++;
    [self sharedAppDelegate].cartPrintTotal = [self sharedAppDelegate].cartPrintTotal + quan;
    self.quantity_TextField.text = [NSString stringWithFormat:@"%i",quan];
    
    NSArray *array = [[self sharedAppDelegate].shoppingCart objectAtIndex:self.addOutlet.tag];
    int price = [[array objectAtIndex:2] intValue];
    int total = price * quan;
    NSString *stringWithoutSpaces = [self.total_Price.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
    NSInteger tempTotal = [self sharedAppDelegate].cartTotal - [stringWithoutSpaces integerValue];
    [self sharedAppDelegate].cartTotal = tempTotal + total;
    
    self.total_Price.text = [NSString stringWithFormat:@"$%i",total];
    
    NSArray *newArray = @[[array objectAtIndex:0],
                          self.quantity_TextField.text,
                          [array objectAtIndex:2],
                          [array objectAtIndex:3],
                          [array objectAtIndex:4],
                          [array objectAtIndex:5],
                          [array objectAtIndex:6],
                          [array objectAtIndex:7],
                          [array objectAtIndex:8],
                          [array objectAtIndex:9],
                          [array objectAtIndex:10],
                          [array objectAtIndex:11]];
    
    [[self sharedAppDelegate].shoppingCart replaceObjectAtIndex:self.addOutlet.tag withObject:newArray];
    [self.delegate addedQuantity];
}

- (IBAction)subtractFromQuantity:(id)sender {
    int quan = [self.quantity_TextField.text intValue];
    if (quan != 1) {
        [self sharedAppDelegate].cartPrintTotal = [self sharedAppDelegate].cartPrintTotal - quan;
        quan--;
        [self sharedAppDelegate].cartPrintTotal = [self sharedAppDelegate].cartPrintTotal + quan;
        self.quantity_TextField.text = [NSString stringWithFormat:@"%i",quan];
        
        NSArray *array = [[self sharedAppDelegate].shoppingCart objectAtIndex:self.addOutlet.tag];
        int price = [[array objectAtIndex:2] intValue];
        int total = price * quan;
        NSString *stringWithoutSpaces = [self.total_Price.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
        NSInteger tempTotal = [self sharedAppDelegate].cartTotal - [stringWithoutSpaces integerValue];
        [self sharedAppDelegate].cartTotal = tempTotal + total;
        
        self.total_Price.text = [NSString stringWithFormat:@"$%i",total];
        
        NSArray *newArray = @[[array objectAtIndex:0],
                              self.quantity_TextField.text,
                              [array objectAtIndex:2],
                              [array objectAtIndex:3],
                              [array objectAtIndex:4],
                              [array objectAtIndex:5],
                              [array objectAtIndex:6],
                              [array objectAtIndex:7],
                              [array objectAtIndex:8],
                              [array objectAtIndex:9],
                              [array objectAtIndex:10],
                              [array objectAtIndex:11]];
        
        [[self sharedAppDelegate].shoppingCart replaceObjectAtIndex:self.addOutlet.tag withObject:newArray];
        [self.delegate addedQuantity];
    }
}
@end
