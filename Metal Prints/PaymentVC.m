//
//  PaymentVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 8/22/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "PaymentVC.h"
#import "AppDelegate.h"
#import "ActualCCTVC.h"
#import <Stripe/Stripe.h>

@interface PaymentVC (){
    ActualCCTVC *paymentTable;
}

@end

@implementation PaymentVC

- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(PlaceOrderAndUploadImages)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [self.navigationItem setTitle:@"Payment"];
    
    paymentTable = [ActualCCTVC sharedActualCCTVC];
    paymentTable.tableView.frame = CGRectMake(self.tableContentView1.frame.origin.x, self.tableContentView1.frame.origin.y-125, self.tableContentView1.frame.size.width, self.tableContentView1.frame.size.height);
    [self.tableContentView1 addSubview:paymentTable.tableView];
    
    NSLog(@"%@",[self sharedAppDelegate].userSettings.billing);
}

- (void)PlaceOrderAndUploadImages {
    
    STPCardParams *params = [[STPCardParams alloc] init];
    params.number = paymentTable.CCN.text;
    params.expMonth = [paymentTable.expMonth.text integerValue];
    params.expYear = [paymentTable.expYear.text integerValue];
    params.cvc = paymentTable.securityCode.text;
    NSString *fullName = [NSString stringWithFormat:@"%@ %@",[self sharedAppDelegate].userSettings.billing.firstName, [self sharedAppDelegate].userSettings.billing.lastName];
    params.name = fullName;
    params.addressLine1 = [self sharedAppDelegate].userSettings.billing.street;
    params.addressLine2 = [self sharedAppDelegate].userSettings.billing.apt;
    params.addressCity = [self sharedAppDelegate].userSettings.billing.city;
    params.addressState = [self sharedAppDelegate].userSettings.billing.state;
    params.addressZip = [self sharedAppDelegate].userSettings.billing.zip;
//    params.addressCountry = [billingDict objectForKey:@"country"];
    params.currency = @"USD";
    [[STPAPIClient sharedClient] createTokenWithCard:params completion:^(STPToken *token, NSError *error) {
        if (error) {
            NSLog(@"error %@",error);
        } else {
            [self createBackendChargeWithToken:token completion:nil];
        }
    }];
    
}

UIAlertController *alert;
NSTimer *timer2;
- (void)createBackendChargeWithToken:(STPToken *)token completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://final-project-order-viewer-stevens-apps.c9users.io/stripeStuff.php"]];

    NSInteger totalAmount = [self sharedAppDelegate].cartTotal * 100;
    NSInteger fee = totalAmount * 0.3;
    NSString *stringAmount = [NSString stringWithFormat:@"%li",(long)totalAmount];
    NSString *feeAmount = [NSString stringWithFormat:@"%li",(long)fee];
    NSDictionary *chargeParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                  token.tokenId, @"stripeToken",
                                  stringAmount, @"chargeAmount",
                                  @"example charge", @"description",
                                  @"incrementing ID", @"orderID",
                                  [self sharedAppDelegate].userSettings.billing.firstName, @"name",
                                  feeAmount, @"fee",nil];
    
    NSError *error2;
    NSData *finalJSONdata = [NSJSONSerialization dataWithJSONObject:chargeParams options:0 error:&error2];
    
    
    [request setHTTPBody:finalJSONdata];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalJSONdata length]] forHTTPHeaderField:@"Content-Length"];
    
    
    NSError *err;
    NSURLResponse *response;
    
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    
    if(responseString)
    {
        NSLog(@"%@",responseString);
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
        alert = [UIAlertController alertControllerWithTitle:@""
                                                    message:@"Card successfully charged, please stay in the app while your images are uploaded."
                                             preferredStyle:UIAlertControllerStyleAlert]; // 1
        
        UIViewController *customVC     = [[UIViewController alloc] init];
        [alert.view setFrame:CGRectMake(0, 300, 320, 275)];
        
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
        
        
        [alert setValue:customVC forKey:@"contentViewController"];
        timer2 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(PostData) userInfo:nil repeats:NO];
        
    }
    else{
        NSLog(@"Error!");
        
    }
}

-(void)PostData{
    [timer2 invalidate];
    timer2 = nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://final-project-order-viewer-stevens-apps.c9users.io/recieve_data.php"]];
    
    
    
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    [mutDict setObject:[self sharedAppDelegate].shippingInfo forKey:@"customer"];
    int i = 0;
    NSMutableDictionary *mutDict1 = [[NSMutableDictionary alloc] init];
    
    for (NSArray *array1 in [self sharedAppDelegate].shoppingCart) {
        
        //        NSArray *array = @[self.Product_Outlet.text,
        //                           self.Quantity_TextField.text,
        //                           price,
        //                           self.Retouching_TextField.text,
        //                           self.For_Aluminum_TextField.text,
        //                           self.textView.text,
        //                           imgData
        //                           ];
        
        NSString *prod = [array1 objectAtIndex:0];
        NSString *quan = [array1 objectAtIndex:1];
        NSString *retouch = [array1 objectAtIndex:3];
        NSString *alum = [array1 objectAtIndex:4];
        NSString *instructions = [array1 objectAtIndex:5];
        NSString *imgString = [array1 objectAtIndex:6];
        //            NSLog(@"%@",imgString);
        NSDictionary *cartItem = [NSDictionary dictionaryWithObjectsAndKeys:
                                  prod,@"product",
                                  
                                  quan,@"quantity",
                                  retouch,@"retouching",
                                  alum,@"aluminumOptions",
                                  instructions,@"instructions",
                                  imgString,@"image",nil];
        
        [mutDict1 setObject:cartItem forKey:[NSString stringWithFormat:@"cart_Item%i",i]];
        i++;
    }
    
    [mutDict setObject:mutDict1 forKey:@"shopping_Cart"];
    
    NSError *error2;
    NSData *finalJSONdata = [NSJSONSerialization dataWithJSONObject:mutDict options:0 error:&error2];
    
    //NSLog(@"%.2f MB",(float)finalJSONdata.length/1024.0f/1024.0f);
    
    [request setHTTPBody:finalJSONdata];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalJSONdata length]] forHTTPHeaderField:@"Content-Length"];
    
    
    NSError *err;
    NSURLResponse *response;
    
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    
    if(responseString)
    {
        //[self performSegueWithIdentifier:@"OrderPlaced" sender:self];
        NSLog(@"got response==%@", responseString);
        [self sendEmail];

    }
    else
    {
        NSLog(@"faield to connect");
        [alert dismissViewControllerAnimated:YES completion:nil];
        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"" message:@"There was a problem uploading your images. Please check your internet connection and try again"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [alert2 dismissViewControllerAnimated:YES completion:nil];
                                                               }]; // 2
        
        [alert2 addAction:cameraAction];
        
        [self presentViewController:alert2 animated:YES completion:nil];
        
    }
    
}


-(void)sendEmail
{
    
    Sendpulse* sendpulse = [[Sendpulse alloc] initWithUserIdandSecret:@"fb64b33382f07958418bb735ccbaffc9" :@"021a14d05af42f4be25cf2546e65ec0f"];
    NSDictionary *from = [NSDictionary dictionaryWithObjectsAndKeys:@"Bryan Stevens", @"name", @"btcfaucetfree@gmail.com", @"email", nil];
    NSMutableArray* to = [[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Bryan Stevens", @"name", @"btcfaucetfree@gmail.com", @"email", nil], nil];
    NSString *messageBody = [NSString stringWithFormat:@"test Email"];
    NSMutableDictionary *emaildata = [NSMutableDictionary dictionaryWithObjectsAndKeys:messageBody, @"html", messageBody, @"text",@"BTC Faucet Withdrawal",@"subject",from,@"from",to,@"to", nil];
    [sendpulse smtpSendMail:emaildata];
    
    
    
    
}

//-(void)messageSent:(SKPSMTPMessage *)message{
//    NSLog(@"sent");
//    [alert dismissViewControllerAnimated:YES completion:nil];
//    [self performSegueWithIdentifier:@"OrderComplete" sender:self];
//    //save was successful
//}
//-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
//    NSLog(@"Failed to send: %@",error);
//}
//- (void)paymentContextDidChange:(STPPaymentContext *)paymentContext {
//    self.activityIndicator.animating = paymentContext.loading;
//    self.paymentButton.enabled = paymentContext.selectedPaymentMethod != nil;
//    self.paymentLabel.text = paymentContext.selectedPaymentMethod.label;
//    self.paymentIcon.image = paymentContext.selectedPaymentMethod.image;
//}
//
//- (void)paymentContext:(STPPaymentContext *)paymentContext
//didCreatePaymentResult:(STPPaymentResult *)paymentResult
//            completion:(STPErrorBlock)completion {
//    [self.apiClient createCharge:paymentResult.source.stripeID completion:^(NSError *error) {
//        if (error) {
//            completion(error);
//        } else {
//            completion(nil);
//        }
//    }];
//}
//
//- (void)paymentContext:(STPPaymentContext *)paymentContext
//   didFinishWithStatus:(STPPaymentStatus)status
//                 error:(NSError *)error {
//    switch (status) {
//        case STPPaymentStatusSuccess:
//            [self showReceipt];
//        case STPPaymentStatusError:
//            [self showError:error];
//        case STPPaymentStatusUserCancellation:
//            return; // Do nothing
//    }
//}

- (void)paymentContext:(STPPaymentContext *)paymentContext didFailToLoadWithError:(NSError *)error {
    [self.navigationController popViewControllerAnimated:YES];
    // Show the error to your user, etc.
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
