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
        [self sharedAppDelegate].userSettings.shipping.Name = @"";
        [self sharedAppDelegate].userSettings.shipping.street = @"";
        [self sharedAppDelegate].userSettings.shipping.apt = @"";
        [self sharedAppDelegate].userSettings.shipping.city = @"";
        [self sharedAppDelegate].userSettings.shipping.zip = @"";
        [self sharedAppDelegate].userSettings.shipping.state = @"";
        [self sharedAppDelegate].userSettings.shipping.country = @"";
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (stateSelected == NO) {
        shippingTable.name_TextField.text = [self sharedAppDelegate].userSettings.shipping.Name;
        shippingTable.street_TextField.text = [self sharedAppDelegate].userSettings.shipping.street;
        shippingTable.apt_TextField.text = [self sharedAppDelegate].userSettings.shipping.apt;
        shippingTable.city_TextField.text = [self sharedAppDelegate].userSettings.shipping.city;
        shippingTable.zip_TextField.text = [self sharedAppDelegate].userSettings.shipping.zip;
        shippingTable.state_TextField.text = [self sharedAppDelegate].userSettings.shipping.state;
        shippingTable.country_Textfield.text = [self sharedAppDelegate].userSettings.shipping.country;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if (stateSelected == NO) {
        [shippingTable.name_TextField becomeFirstResponder];
    }
    stateSelected = NO;
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

UIAlertController *calculatingTax1;
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
    if ([shippingTable.country_Textfield isFirstResponder]) {
        NSLog(@"Zip");
        [shippingTable.country_Textfield resignFirstResponder];
        
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

        calculatingTax1 = [UIAlertController alertControllerWithTitle:@""
                                                                message:@"Calculating Tax"
                                                         preferredStyle:UIAlertControllerStyleAlert]; // 1
        
        UIViewController *customVC     = [[UIViewController alloc] init];
        [calculatingTax1.view setFrame:CGRectMake(0, 300, 320, 275)];
        
        UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        [customVC.view addSubview:spinner];
        [spinner setCenter:CGPointMake(100, 27)];
        
        [customVC.view addConstraint:[NSLayoutConstraint
                                      constraintWithItem: spinner
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:customVC.view
                                      attribute:NSLayoutAttributeCenterX
                                      multiplier:1.0f
                                      constant:0.0f]];
        
        
        [calculatingTax1 setValue:customVC forKey:@"contentViewController"];
        
        [self presentViewController:calculatingTax1 animated:YES completion:nil];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
        
        
        
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

-(void)waiting{
    NSString *requestString = [NSString stringWithFormat:@"https://api.zip-tax.com/request/v20?key=XT8Q3U3QHXJ3&postalcode=%@&state=%@&format=JSON",[self sharedAppDelegate].userSettings.shipping.zip,[self sharedAppDelegate].userSettings.shipping.state];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    [request setHTTPMethod:@"Get"];
    
    NSError *err;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    if(responseString)
    {
        //NSLog(@"%@",responseString);
        NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSInteger success = [[json objectForKey:@"rCode"] integerValue];
        if (success == 100) {
            id resultArray = [json objectForKey:@"results"];
            id resultDict = [resultArray objectAtIndex:0];
            float taxPercent = [[resultDict objectForKey:@"taxSales"] floatValue];
            [calculatingTax1 dismissViewControllerAnimated:YES completion:^{
                [self.delegate FinishedEnteringShippingInformationWithTaxPercent:taxPercent];
            }];
            
            
        }
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

-(void)displayStateController{
    [self performSegueWithIdentifier:@"showStates" sender:self];
}


BOOL stateSelected;
- (void)pickedState:(NSString*)state{
    stateSelected = YES;
    [self.navigationController popViewControllerAnimated:YES];
    shippingTable.state_TextField.text = state;
    [shippingTable.country_Textfield becomeFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showStates"]) {
        StateTableViewController *states = segue.destinationViewController;
        states.delegate = self;
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", returnbuttontitle) style:     UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
    }
    if ([segue.identifier isEqualToString:@"showStates1"]) {
        StateTableViewController *states = segue.destinationViewController;
        states.delegate = self;
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", returnbuttontitle) style:     UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
    }
}

@end
