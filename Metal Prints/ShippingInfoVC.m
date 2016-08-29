//
//  ShippingInfoVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 8/12/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "ShippingInfoVC.h"

#import "AppDelegate.h"
#import "UserShipping.h"
#import "UserObject.h"

@interface ShippingInfoVC (){
    ShippingTVC *shippingTable;
}

@end

@implementation ShippingInfoVC


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


UIBarButtonItem *rightBarButtonItem5;
- (void)viewDidLoad {
    [super viewDidLoad];
    rightBarButtonItem5 = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(EnterBilling)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem5];
    
    shippingTable = [ShippingTVC sharedShippingTVC];
    shippingTable.delegate = self;
    shippingTable.ShippingPresenting = YES;
    shippingTable.tableView.frame = CGRectMake(self.orderDataView.frame.origin.x, self.orderDataView.frame.origin.y-125, self.orderDataView.frame.size.width, self.orderDataView.frame.size.height);
    [self.orderDataView addSubview:shippingTable.tableView];
    if ([self sharedAppDelegate].userSettings.shipping != nil) {
        shippingTable.name_TextField.text = [self sharedAppDelegate].userSettings.shipping.firstName;
        
        shippingTable.street_TextField.text = [self sharedAppDelegate].userSettings.shipping.street;
        
        shippingTable.apt_TextField.text = [self sharedAppDelegate].userSettings.shipping.apt;
        
        shippingTable.city_TextField.text = [self sharedAppDelegate].userSettings.shipping.city;
        
        shippingTable.state_TextField.text = [self sharedAppDelegate].userSettings.shipping.state;
        
        shippingTable.zip_TextField.text = [self sharedAppDelegate].userSettings.shipping.zip;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)EnterBilling{
    
    if (![shippingTable.name_TextField.text isEqualToString: @""] && ![shippingTable.street_TextField.text isEqualToString: @""] && ![shippingTable.city_TextField.text isEqualToString: @""] && ![shippingTable.state_TextField.text isEqualToString: @""] && ![shippingTable.zip_TextField.text isEqualToString: @""]) {
        
        [self sharedAppDelegate].userSettings = [[UserObject alloc] init];
        [self sharedAppDelegate].userSettings.shipping = [[UserShipping alloc] init];
        [self sharedAppDelegate].userSettings.shipping.firstName = shippingTable.name_TextField.text;
        
        [self sharedAppDelegate].userSettings.shipping.lastName = shippingTable.name_TextField.text;
        
        [self sharedAppDelegate].userSettings.shipping.street = shippingTable.street_TextField.text;
        
        [self sharedAppDelegate].userSettings.shipping.apt = shippingTable.apt_TextField.text;
        
        [self sharedAppDelegate].userSettings.shipping.city = shippingTable.city_TextField.text;
        
        [self sharedAppDelegate].userSettings.shipping.state = shippingTable.state_TextField.text;
        
        [self sharedAppDelegate].userSettings.shipping.zip = shippingTable.zip_TextField.text;

        [self performSegueWithIdentifier:@"Billing" sender:self];
    }
    else{
        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter all required information"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [alert2 dismissViewControllerAnimated:YES completion:nil];
                                                               }]; // 2
        
        [alert2 addAction:cameraAction];
        
        [self presentViewController:alert2 animated:YES completion:nil];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)zipIsFirstResponderMoveViewUp{
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setFrame:CGRectMake(0,-30,self.view.bounds.size.width,self.view.bounds.size.height)];
    }];
}

- (void) zipResignedFirstResponderMoveViewDown{
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    }];
}


@end
