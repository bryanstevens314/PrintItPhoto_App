//
//  OrderPlacedVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 4/20/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "OrderPlacedVC.h"


@interface OrderPlacedVC ()

@end

@implementation OrderPlacedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBarButtonItem4 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(Done)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem4];
    [self.navigationItem setTitle:@"Thank You!"];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)Done {
    [self performSegueWithIdentifier:@"DoneWithOrder" sender:self];
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
