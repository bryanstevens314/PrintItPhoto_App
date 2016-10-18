//
//  BillingVC.m
//  
//
//  Created by Bryan Stevens on 8/22/16.
//
//
#import "Sendpulse.h"
#import "BillingVC.h"
#import "AppDelegate.h"
#import "UserBilling.h"

@interface BillingVC (){
    CCTVC *CCTable;
}

@end

@implementation BillingVC


- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(EnterPayment)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [self.navigationItem setTitle:@"Billing"];
    
    if ([self sharedAppDelegate].userSettings == nil) {
        [self sharedAppDelegate].userSettings = [[UserObject alloc] init];
    }
    
    if ([self sharedAppDelegate].userSettings.billing == nil) {
        [self sharedAppDelegate].userSettings.billing = [[UserBilling alloc] init];
        [self sharedAppDelegate].userSettings.billing.payment = [[UserPayment alloc] init];
        [self sharedAppDelegate].userSettings.billing.email = @"";
        [self sharedAppDelegate].userSettings.billing.payment.CCN = @"";
        [self sharedAppDelegate].userSettings.billing.payment.securityCode = @"";
        [self sharedAppDelegate].userSettings.billing.firstName = @"";
        [self sharedAppDelegate].userSettings.billing.street = @"";
        [self sharedAppDelegate].userSettings.billing.apt = @"";
        [self sharedAppDelegate].userSettings.billing.city = @"";
        [self sharedAppDelegate].userSettings.billing.zip = @"";
        [self sharedAppDelegate].userSettings.billing.state = @"";
    }
    CCTable = [CCTVC sharedCCTVC];
    CCTable.delegate = self;
        CCTable.tableView.frame = CGRectMake(self.tableContentView.frame.origin.x, self.tableContentView.frame.origin.y-110, self.tableContentView.frame.size.width, self.tableContentView.frame.size.height);

    [self.tableContentView addSubview:CCTable.tableView];
    
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
        CCTable.email.text = [self sharedAppDelegate].userSettings.billing.email;
        CCTable.ccn.text = [self sharedAppDelegate].userSettings.billing.payment.CCN;
        if ([self sharedAppDelegate].userSettings.billing.payment.expMonth != NULL) {
            CCTable.expMonth.text = [NSString stringWithFormat:@"%@/%@",[self sharedAppDelegate].userSettings.billing.payment.expMonth,[self sharedAppDelegate].userSettings.billing.payment.expYear];
        }

        CCTable.cvc.text = [self sharedAppDelegate].userSettings.billing.payment.securityCode;
        CCTable.firstName.text = [self sharedAppDelegate].userSettings.billing.firstName;
        CCTable.streetAddress.text = [self sharedAppDelegate].userSettings.billing.street;
        CCTable.apt.text = [self sharedAppDelegate].userSettings.billing.apt;
        CCTable.City.text = [self sharedAppDelegate].userSettings.billing.city;
        CCTable.zip.text = [self sharedAppDelegate].userSettings.billing.zip;
        CCTable.stateText.text = [self sharedAppDelegate].userSettings.billing.state;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (stateSelected1 == NO) {
        [CCTable.email becomeFirstResponder];
    }
    stateSelected1 = NO;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [CCTable.keyboardDoneButtonView2 removeFromSuperview];
    [self moveViewDown];
    
    if ([CCTable.email isFirstResponder]) {
        NSLog(@"name");
        [CCTable.email resignFirstResponder];
    }
    
    if ([CCTable.ccn isFirstResponder]) {
        NSLog(@"name");
        [CCTable.ccn resignFirstResponder];
    }
    
    if ([CCTable.expMonth isFirstResponder]) {
        NSLog(@"name");
        [CCTable.expMonth resignFirstResponder];
    }
    
    if ([CCTable.cvc isFirstResponder]) {
        NSLog(@"name");
        [CCTable.cvc resignFirstResponder];
    }
    
    if ([CCTable.firstName isFirstResponder]) {
        NSLog(@"name");
        [CCTable.firstName resignFirstResponder];
    }
    
    if ([CCTable.streetAddress isFirstResponder]) {
        NSLog(@"street");
        [CCTable.streetAddress resignFirstResponder];
    }
    
    if ([CCTable.apt isFirstResponder]) {
        NSLog(@"city");
        [CCTable.apt resignFirstResponder];
    }
    
    if ([CCTable.City isFirstResponder]) {
        NSLog(@"city");
        [CCTable.City resignFirstResponder];
    }
    
    if ([CCTable.stateText isFirstResponder]) {
        NSLog(@"state");
        [CCTable.stateText resignFirstResponder];
    }
    
    if ([CCTable.zip isFirstResponder]) {
        NSLog(@"Zip");
        [CCTable.zip resignFirstResponder];
        
    }

    
}


UIAlertController *chargingCardAlert;
- (void)EnterPayment {
    
    
    if (![CCTable.email.text isEqualToString:@""] &&![CCTable.ccn.text isEqualToString:@""] && ![CCTable.cvc.text isEqualToString:@""] && ![CCTable.firstName.text isEqualToString:@""] && ![CCTable.streetAddress.text isEqualToString:@""] && ![CCTable.City.text isEqualToString:@""] && ![CCTable.stateText.text isEqualToString:@""] && ![CCTable.zip.text isEqualToString:@""]) {
        if ([CCTable.email isFirstResponder]) {
            [CCTable.email resignFirstResponder];
        }
        
        if ([CCTable.ccn isFirstResponder]) {
            [CCTable.ccn resignFirstResponder];
        }
        
        if ([CCTable.expMonth isFirstResponder]) {
            [CCTable.expMonth resignFirstResponder];
        }
        
        if ([CCTable.cvc isFirstResponder]) {
            [CCTable.cvc resignFirstResponder];
        }
        
        if ([CCTable.firstName isFirstResponder]) {
            [CCTable.firstName resignFirstResponder];
        }
        
        if ([CCTable.streetAddress isFirstResponder]) {
            [CCTable.streetAddress resignFirstResponder];
        }
        
        if ([CCTable.City isFirstResponder]) {
            [CCTable.City resignFirstResponder];
        }
        
        if ([CCTable.zip isFirstResponder]) {
            [CCTable.zip resignFirstResponder];
        }
        
        [self sharedAppDelegate].userSettings.billing = [[UserBilling alloc] init];
        
        [self sharedAppDelegate].userSettings.billing.payment = [[UserPayment alloc] init];

        [self sharedAppDelegate].userSettings.billing.payment.CCN = CCTable.ccn.text;
        NSLog(@"%@",CCTable.ccn.text);
        [self sharedAppDelegate].userSettings.billing.payment.expMonth = CCTable.currentMonth;
        
        [self sharedAppDelegate].userSettings.billing.payment.expYear = CCTable.currentYear;
        
        [self sharedAppDelegate].userSettings.billing.payment.securityCode = CCTable.cvc.text;
        
        
        
        [self sharedAppDelegate].userSettings.billing.firstName = CCTable.firstName.text;
        
        [self sharedAppDelegate].userSettings.billing.street = CCTable.streetAddress.text;
        
        [self sharedAppDelegate].userSettings.billing.apt = CCTable.apt.text;
        
        [self sharedAppDelegate].userSettings.billing.city = CCTable.City.text;
        
        [self sharedAppDelegate].userSettings.billing.state = CCTable.stateText.text;
        
        [self sharedAppDelegate].userSettings.billing.zip = CCTable.zip.text;
        
        [self sharedAppDelegate].userSettings.billing.email = CCTable.email.text;
        
        chargingCardAlert = [UIAlertController alertControllerWithTitle:@""
                                                    message:@""
                                             preferredStyle:UIAlertControllerStyleAlert]; // 1
        
        UIViewController *customVC     = [[UIViewController alloc] init];
        [chargingCardAlert.view setFrame:CGRectMake(0, 300, 320, 275)];
        
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
        
        
        [chargingCardAlert setValue:customVC forKey:@"contentViewController"];
        
        [self presentViewController:chargingCardAlert animated:YES completion:nil];
        [self moveViewDown];
        [PaymentVC sharedPaymentVC].delegate = self;
        [[PaymentVC sharedPaymentVC] retrieveStripeToken];
    }
    else{
//        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter all required information"preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
//                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                                   [alert2 dismissViewControllerAnimated:YES completion:nil];
//                                                               }]; // 2
//        
//        [alert2 addAction:cameraAction];
//        
//        [self presentViewController:alert2 animated:YES completion:nil];

    }
}

-(void)retirevedToken{
    [chargingCardAlert dismissViewControllerAnimated:YES completion:^{
        [self.delegate FinishedEnteringBillingInformation];
    }];
    
}

- (void)failedToRetireveToken{
    [chargingCardAlert dismissViewControllerAnimated:YES completion:^{
        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"Error validating card" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [alert2 dismissViewControllerAnimated:YES completion:nil];
                                                               }]; // 2
        
        [alert2 addAction:cameraAction];
        
        [self presentViewController:alert2 animated:YES completion:nil];

    }];
}
- (void)shippingSameAsBilling{
    
    [self sharedAppDelegate].userSettings.billing.firstName = CCTable.firstName.text;
    
    [self sharedAppDelegate].userSettings.billing.street = CCTable.streetAddress.text;
    
    [self sharedAppDelegate].userSettings.billing.apt = CCTable.apt.text;
    
    [self sharedAppDelegate].userSettings.billing.city = CCTable.City.text;
    
    [self sharedAppDelegate].userSettings.billing.state = CCTable.stateText.text;
    
    [self sharedAppDelegate].userSettings.billing.zip = CCTable.zip.text;
    
    //[self performSegueWithIdentifier:@"Payment" sender:self];
}


-(void)moveViewUp{
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setFrame:CGRectMake(0,-75,self.view.bounds.size.width,self.view.bounds.size.height+75)];
    }];
    
}

-(void)moveViewDown{
    
    [UIView animateWithDuration:0.25f animations:^{
        int offset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
        [self.view setFrame:CGRectMake(0,offset,self.view.bounds.size.width,self.view.bounds.size.height)];
    }];
}




-(void)displayStateController1{
    [self performSegueWithIdentifier:@"showStates1" sender:self];
}

BOOL stateSelected1;
- (void)pickedState:(NSString*)state{
    
    [self.navigationController popViewControllerAnimated:YES];
    CCTable.stateText.text = state;
    stateSelected1 = YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"showStates1"]) {
        StateTableViewController *states = segue.destinationViewController;
        states.delegate = self;
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", returnbuttontitle) style:     UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
    }
}

@end
