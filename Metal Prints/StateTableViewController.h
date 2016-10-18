//
//  StateTableViewController.h
//  Metal Prints
//
//  Created by Bryan Stevens on 10/4/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StateTableViewController;

@protocol StateTableViewControllerDelegate

- (void)pickedState:(NSString*)state;

@end


@interface StateTableViewController : UITableViewController
@property (weak, nonatomic) id<StateTableViewControllerDelegate> delegate;
@end
