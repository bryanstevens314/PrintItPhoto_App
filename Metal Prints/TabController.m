//
//  TabController.m
//  Metal Prints
//
//  Created by Bryan Stevens on 7/17/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "TabController.h"
#import "AppDelegate.h"
@interface TabController ()

@end

@implementation TabController

-(id) init {
    if(self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self sharedAppDelegate].TheTabController = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
