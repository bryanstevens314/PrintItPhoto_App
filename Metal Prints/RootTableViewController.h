//
//  RootTableViewController.h
//  Trucks
//
//  Created by Bryan Stevens on 7/16/15.
//  Copyright (c) 2015 PocketTools. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTableViewController : UITableViewController
+ (RootTableViewController *)sharedRootTableViewController;
@property (weak, nonatomic) IBOutlet UINavigationItem *navbar;

-(void)toggleSlideOver;
@end
