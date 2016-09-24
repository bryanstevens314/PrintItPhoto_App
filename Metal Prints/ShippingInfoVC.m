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



+ (ShippingInfoVC *)sharedShippingInfoVC
{
    static ShippingInfoVC *sharedInstance = nil;
    
    UIStoryboard *storyboard;
    
    // detect the height of our screen
    int height = [UIScreen mainScreen].bounds.size.height;
    
    if (height == 480) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_3.5_inch" bundle:nil];
        // NSLog(@"Device has a 3.5inch Display.");
    }
    if (height == 568) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_4_inch" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    if (height == 667) {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    if (height == 736) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_5.5_inch" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = (ShippingInfoVC*)[storyboard instantiateViewControllerWithIdentifier: @"ShippingInfo"];
    });
    return sharedInstance;
}


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


UIBarButtonItem *rightBarButtonItem5;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    rightBarButtonItem5 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(EnterBilling)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem5];
    [self.navigationItem setTitle:@"Shipping"];
    
    shippingTable = [ShippingTVC sharedShippingTVC];
    shippingTable.delegate = self;
    shippingTable.ShippingPresenting = YES;
    shippingTable.tableView.frame = CGRectMake(self.orderDataView.frame.origin.x, self.orderDataView.frame.origin.y-142, self.orderDataView.frame.size.width, self.orderDataView.frame.size.height);
    [self.orderDataView addSubview:shippingTable.tableView];
    if ([self sharedAppDelegate].userSettings == nil) {
        [self sharedAppDelegate].userSettings = [[UserObject alloc] init];
        [self sharedAppDelegate].userSettings.shipping = [[UserShipping alloc] init];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [shippingTable.name_TextField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [shippingTable.keyboardDoneButtonView1 removeFromSuperview];
    if ([shippingTable.name_TextField isFirstResponder]) {
        NSLog(@"name");
        [shippingTable.name_TextField resignFirstResponder];
    }
    
    
    if ([shippingTable.street_TextField isFirstResponder]) {
        NSLog(@"street");
        [shippingTable.street_TextField resignFirstResponder];
    }
    
    if ([shippingTable.apt_TextField isFirstResponder]) {
        NSLog(@"city");
        [shippingTable.apt_TextField resignFirstResponder];
    }
    
    if ([shippingTable.city_TextField isFirstResponder]) {
        NSLog(@"city");
        [shippingTable.city_TextField resignFirstResponder];
    }
    
    if ([shippingTable.state_TextField isFirstResponder]) {
        NSLog(@"state");
        [shippingTable.state_TextField resignFirstResponder];
    }
    
    if ([shippingTable.zip_TextField isFirstResponder]) {
        NSLog(@"Zip");
        [shippingTable.zip_TextField resignFirstResponder];
        
    }
    
    if ([shippingTable.country_Textfield isFirstResponder]) {
        NSLog(@"state");
        [shippingTable.country_Textfield resignFirstResponder];
    }

}

-(void)EnterBilling{
    
    if ([shippingTable.name_TextField isFirstResponder]) {
        NSLog(@"name");
        [shippingTable.name_TextField resignFirstResponder];
    }

    
    if ([shippingTable.street_TextField isFirstResponder]) {
        NSLog(@"street");
        [shippingTable.street_TextField resignFirstResponder];
    }
    
    if ([shippingTable.apt_TextField isFirstResponder]) {
        NSLog(@"city");
        [shippingTable.apt_TextField resignFirstResponder];
    }
    
    if ([shippingTable.city_TextField isFirstResponder]) {
        NSLog(@"city");
        [shippingTable.city_TextField resignFirstResponder];
    }
    
    if ([shippingTable.state_TextField isFirstResponder]) {
        NSLog(@"state");
        [shippingTable.state_TextField resignFirstResponder];
    }
    
    if ([shippingTable.zip_TextField isFirstResponder]) {
        NSLog(@"Zip");
        [shippingTable.zip_TextField resignFirstResponder];
        
    }
    
    if (![shippingTable.name_TextField.text isEqualToString: @""] && ![shippingTable.street_TextField.text isEqualToString: @""] && ![shippingTable.city_TextField.text isEqualToString: @""] && ![shippingTable.state_TextField.text isEqualToString: @""] && ![shippingTable.zip_TextField.text isEqualToString: @""] && ![shippingTable.country_Textfield.text isEqualToString: @""]) {
        
//        [self sharedAppDelegate].userSettings = [[UserObject alloc] init];
//        [self sharedAppDelegate].userSettings.shipping = [[UserShipping alloc] init];
        [self sharedAppDelegate].userSettings.shipping.Name = shippingTable.name_TextField.text;
        
        [self sharedAppDelegate].userSettings.shipping.street = shippingTable.street_TextField.text;
        
        [self sharedAppDelegate].userSettings.shipping.apt = shippingTable.apt_TextField.text;
        
        [self sharedAppDelegate].userSettings.shipping.city = shippingTable.city_TextField.text;
        
        [self sharedAppDelegate].userSettings.shipping.state = shippingTable.state_TextField.text;
        
        [self sharedAppDelegate].userSettings.shipping.zip = shippingTable.zip_TextField.text;
        
        [self sharedAppDelegate].userSettings.shipping.country = shippingTable.country_Textfield.text;

        
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://development.avalara.net/1.0/tax/get"]];
//        
////        {
////            "DocDate": "2013-01-16",
////            "CustomerCode": "CUST1",
////            "DocCode": "DOC0001",
////            "DocType": "SalesInvoice",
////            "Addresses":[{
////                "AddressCode": "1",
////                "Line1": "100 Ravine Lane NE",
////                "City": "Bainbridge Island",
////                "Region": "WA",
////                "PostalCode": "98110"
////            }],
////            "Lines":[{
////                "LineNo": "1",
////                "DestinationCode": "1",
////                "OriginCode": "1",
////                "Qty": 1,
////                "Amount": 10
////            }]
//            //    }
//        
//        NSDictionary *address = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 [self sharedAppDelegate].userSettings.shipping.street, @"AddressCode",
//                                 [self sharedAppDelegate].userSettings.shipping.street, @"Line1",
//                                 [self sharedAppDelegate].userSettings.shipping.city, @"City",
//                                 [self sharedAppDelegate].userSettings.shipping.state, @"Region",
//                                 [self sharedAppDelegate].userSettings.shipping.zip, @"PostalCode",nil];
//        NSDictionary *lines = [NSDictionary dictionaryWithObjectsAndKeys:
//                               @"1", @"LineNo",
//                               @"1", @"DestinationCode",
//                               @"1", @"OriginCode",
//                               @"1", @"Qty",
//                               [self sharedAppDelegate].cartTotal, @"Amount",nil];
//            NSDictionary *chargeParams = [NSDictionary dictionaryWithObjectsAndKeys:
//                                          @"2013-01-16", @"DocDate",
//                                          @"CUST1", @"CustomerCode",
//                                          @"DOC0001", @"DocCode",
//                                          @"SalesInvoice", @"DocType",
//                                          address, @"Addresses",
//                                          lines, @"Lines",nil];
//            
//            NSError *error2;
//            NSData *finalJSONdata = [NSJSONSerialization dataWithJSONObject:chargeParams options:0 error:&error2];
//            
//            
//            [request setHTTPBody:finalJSONdata];
//            [request setHTTPMethod:@"POST"];
//            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalJSONdata length]] forHTTPHeaderField:@"Content-Length"];
//            
//            
//            NSError *err;
//            NSURLResponse *response;
//            
//            
//            
//            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
//            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
//            
//            
//            if(responseString)
//            {
//                NSLog(@"%@",responseString);
//                
//                
//                
//            }
//            else{
//                NSLog(@"Error!");
//                
//            }

            
[self.delegate FinishedEnteringShippingInformation];
        
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
