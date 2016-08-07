//
//  NonCopyPasteTextField.m
//  Metal Prints
//
//  Created by Bryan Stevens on 5/7/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "NonCopyPasteTextField.h"

@implementation NonCopyPasteTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:) || action == @selector(paste:) || action == @selector(select:) || action == @selector(selectAll:)) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

@end
