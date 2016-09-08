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
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(EnterPayment)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [self.navigationItem setTitle:@"Billing"];
    
    if ([self sharedAppDelegate].userSettings.billing == nil) {
        [self sharedAppDelegate].userSettings.billing = [[UserBilling alloc] init];
    }
    CCTable = [CCTVC sharedCCTVC];
    CCTable.delegate = self;
        CCTable.tableView.frame = CGRectMake(self.tableContentView.frame.origin.x, self.tableContentView.frame.origin.y-110, self.tableContentView.frame.size.width, self.tableContentView.frame.size.height);

    [self.tableContentView addSubview:CCTable.tableView];
    
    

}

UIAlertController *chargingCardAlert;
- (void)EnterPayment {
    
    
    if (![CCTable.email.text isEqualToString:@""] &&![CCTable.ccn.text isEqualToString:@""] && ![CCTable.cvc.text isEqualToString:@""] && ![CCTable.firstName.text isEqualToString:@""] && ![CCTable.streetAddress.text isEqualToString:@""] && ![CCTable.City.text isEqualToString:@""] && ![CCTable.state.text isEqualToString:@""] && ![CCTable.zip.text isEqualToString:@""]) {
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
        
        [self sharedAppDelegate].userSettings.billing.payment = [[UserPayment alloc] init];
        
        [self sharedAppDelegate].userSettings.billing.payment.CCN = CCTable.ccn.text;

        [self sharedAppDelegate].userSettings.billing.payment.expMonth = CCTable.currentMonth;
        
        [self sharedAppDelegate].userSettings.billing.payment.expYear = CCTable.currentYear;
        
        [self sharedAppDelegate].userSettings.billing.payment.securityCode = CCTable.cvc.text;
        
        
        
        [self sharedAppDelegate].userSettings.billing.firstName = CCTable.firstName.text;
        
        [self sharedAppDelegate].userSettings.billing.street = CCTable.streetAddress.text;
        
        [self sharedAppDelegate].userSettings.billing.apt = CCTable.apt.text;
        
        [self sharedAppDelegate].userSettings.billing.city = CCTable.City.text;
        
        [self sharedAppDelegate].userSettings.billing.state = CCTable.state.text;
        
        [self sharedAppDelegate].userSettings.billing.zip = CCTable.zip.text;
        
        [self sharedAppDelegate].userSettings.shipping.email = CCTable.email.text;
        
        chargingCardAlert = [UIAlertController alertControllerWithTitle:@""
                                                    message:@"Charging Card"
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
        [PaymentVC sharedPaymentVC].delegate = self;
        [[PaymentVC sharedPaymentVC] PlaceOrderAndUploadImages];
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

    [self PostData];
    }
}

- (void)shippingSameAsBilling{
    
    [self sharedAppDelegate].userSettings.billing.firstName = CCTable.firstName.text;
    
    [self sharedAppDelegate].userSettings.billing.street = CCTable.streetAddress.text;
    
    [self sharedAppDelegate].userSettings.billing.apt = CCTable.apt.text;
    
    [self sharedAppDelegate].userSettings.billing.city = CCTable.City.text;
    
    [self sharedAppDelegate].userSettings.billing.state = CCTable.state.text;
    
    [self sharedAppDelegate].userSettings.billing.zip = CCTable.zip.text;
    
    [self performSegueWithIdentifier:@"Payment" sender:self];
}


-(void)moveViewUp{
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setFrame:CGRectMake(0,-264,self.view.bounds.size.width,self.view.bounds.size.height+264)];
    }];
    
}

-(void)moveViewDown{
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    }];
}


#pragma  mark PaymentDelegate

UIAlertController *alert;

- (void)CardSuccessFullyCharged{
    NSLog(@"Card Successfully Charged");
    [chargingCardAlert dismissViewControllerAnimated:YES completion:nil];
    if (alert) {
        alert = nil;
    }
    alert = [UIAlertController alertControllerWithTitle:@"" message:@"Charged Card"preferredStyle:UIAlertControllerStyleAlert];
    
//    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
//                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                               [alert dismissViewControllerAnimated:YES completion:nil];
//                                                           }]; // 2
//    
//    [alert addAction:cameraAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)CardFailedToCharged{
    NSLog(@"Card Failed To Charge");
    [chargingCardAlert dismissViewControllerAnimated:YES completion:nil];
    if (alert) {
        alert = nil;
    }
    alert = [UIAlertController alertControllerWithTitle:@"" message:@"Failed to charge card"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }]; // 2
    
    [alert addAction:cameraAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


UIAlertController *uploadAlert;
-(void)UploadingImages{
    NSLog(@"Uploading images");
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
    uploadAlert = [UIAlertController alertControllerWithTitle:@""
                                                message:@"Uploading Images"
                                         preferredStyle:UIAlertControllerStyleAlert]; // 1
    
    UIViewController *customVC     = [[UIViewController alloc] init];
    [uploadAlert.view setFrame:CGRectMake(0, 300, 320, 275)];
    
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
    
    
    [uploadAlert setValue:customVC forKey:@"contentViewController"];
    
    [self presentViewController:uploadAlert animated:YES completion:nil];
    
}


-(void)ImagesSuccessFullyUploaded{
    
    NSLog(@"Images successfully upload");
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
    [self performSegueWithIdentifier:@"PaymentComplete" sender:self];
}


-(void)imageUploadFailure{
    NSLog(@"Upload Failed");
    
    [alert dismissViewControllerAnimated:YES completion:nil];
    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"There was a problem uploading your images. Please check your internet connection and try again"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               [alert2 dismissViewControllerAnimated:YES completion:nil];
                                                           }]; // 2
    
    [alert2 addAction:cameraAction];
    
    [self presentViewController:alert2 animated:YES completion:nil];
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
