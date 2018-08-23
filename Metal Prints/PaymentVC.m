//
//  PaymentVC.m
//  Metal Prints
//
//  Created by Bryan Stevens on 8/22/16.
//  Copyright © 2016 Pocket Tools. All rights reserved.
//

#import "PaymentVC.h"
#import "AppDelegate.h"
#import <Stripe/Stripe.h>
#import "Communicate.h"

@interface PaymentVC (){
    
    Communicate *comm;
    NSString *theToken;
}

@end

@implementation PaymentVC


- (void)paymentContextDidChange:(STPPaymentContext *)paymentContext{
    
    
}
- (AppDelegate *)sharedAppDelegate
{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (PaymentVC *)sharedPaymentVC
{
    static PaymentVC *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PaymentVC alloc] init];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)retrieveStripeToken {
    
    STPCardParams *params = [[STPCardParams alloc] init];
    params.number = [self sharedAppDelegate].userSettings.billing.payment.CCN;
    params.expMonth = [[self sharedAppDelegate].userSettings.billing.payment.expMonth integerValue];
    params.expYear = [[self sharedAppDelegate].userSettings.billing.payment.expYear integerValue];
    params.cvc = [self sharedAppDelegate].userSettings.billing.payment.securityCode;
    params.name = [self sharedAppDelegate].userSettings.billing.firstName;
    params.addressLine1 = [self sharedAppDelegate].userSettings.billing.street;
    params.addressLine2 = [self sharedAppDelegate].userSettings.billing.apt;
    params.addressCity = [self sharedAppDelegate].userSettings.billing.city;
    params.addressState = [self sharedAppDelegate].userSettings.billing.state;
    params.addressZip = [self sharedAppDelegate].userSettings.billing.zip;
//    params.addressCountry = [billingDict objectForKey:@"country"];

    [[STPAPIClient sharedClient] createTokenWithCard:params completion:^(STPToken *token, NSError *error) {
        if (error) {
            NSLog(@"error %@",error);
            [self.delegate failedToRetireveToken];
            //[error valueForKey:@"invalid_number"];
            
        } else {
//            NSString *code = [[self sharedAppDelegate].userSettings.billing.payment.CCN substringFromIndex: [[self sharedAppDelegate].userSettings.billing.payment.CCN length] - 4];
//            [self sharedAppDelegate].userSettings.billing.payment.CCN = [NSString stringWithFormat:@"**** **** **** %@",code];
            [self sharedAppDelegate].userSettings.billing.payment.stripe_Token = token;
            [self.delegate retirevedToken];
            //[self createBackendChargeWithToken:token completion:nil];
        }
    }];
    
}
-(void)begin{
    if (comm == nil) {
        comm = [[Communicate alloc] init];
    }
    theToken = [comm authenticate];
    NSLog(@"authenticated");
    NSLog(@"%@",theToken);
    if ([theToken isEqualToString:@"269C877DCFFB2533DA41A97CAAB91"]) {
        NSLog(@"token correct");
        [self createBackendChargeWithToken:[self sharedAppDelegate].userSettings.billing.payment.stripe_Token completion:nil];
    }
}

-(void)VerifyConnectionToServer{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://print-it-photo-stevens-apps.c9users.io/authenticate.php"]];
    NSDictionary *chargeParams = [NSDictionary dictionaryWithObjectsAndKeys:@"8w0eF7uBgx5e2azW0714p5IQVKuF8c95", @"key",nil];
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

        id json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];

        NSString *successString = [json objectForKey:@"status"];
        if ([successString isEqualToString:@"success"]) {
            [self sharedAppDelegate].serverToken = [json objectForKey:@"token"];
            if ([self sharedAppDelegate].serverToken.length == 29) {
                NSLog(@"authenticated");
                [self.delegate retirevedToken];
            }
            else{
                NSLog(@"failed token authentification");
                NSLog(@"%@",[self sharedAppDelegate].serverToken);
                [self.delegate failedToRetireveToken];
            }

        }
        else{
            NSLog(@"no success");
            [self.delegate failedToRetireveToken];
        }
        
        
        
    }
    else{
        NSLog(@"Error!");
        
    }
}

NSTimer *timer2;
- (void)createBackendChargeWithToken:(STPToken *)token completion:(void (^)(PKPaymentAuthorizationStatus))completion {
NSLog(@"charging");
        NSArray *orderAttemptArray = @[@"charge attempted",@"upload not attempted"];
        [NSKeyedArchiver archiveRootObject:orderAttemptArray toFile:[self archiveOrderAttemp]];
        

        
        NSInteger totalAmount = self.totalPlusTax * 100;
        NSInteger fee = totalAmount * 0.3;
        NSLog(@"Total: %ld",(long)totalAmount);
        NSString *stringAmount = [NSString stringWithFormat:@"%li",(long)totalAmount];
        NSString *feeAmount = [NSString stringWithFormat:@"%li",(long)fee];
    NSLog(@"Stripe token:%@",token.stripeID);
        NSDictionary *chargeParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                      token.tokenId, @"stripeToken",
                                      stringAmount, @"chargeAmount",
                                      @"example charge", @"description",
                                      @"incrementing ID", @"orderID",
                                      [self sharedAppDelegate].userSettings.billing.firstName, @"name",
                                      feeAmount, @"fee",
                                      [self sharedAppDelegate].taxPercentString, @"tax_Percent",
                                      [self sharedAppDelegate].total_TaxCharged, @"tax_TotalCharged",
                                      @"charged",@"type",
                                      theToken, @"token", nil];
    NSArray *idArray = [comm stripeCharge:chargeParams];
    if (idArray != nil){
        chargeID = [idArray objectAtIndex:0];
        customerID = [idArray objectAtIndex:1];
        NSLog(@"Customer id:%@",customerID);
        NSLog(@"charge id:%@",chargeID);
        NSLog(@"successfully charged");
        timer2 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(PostData) userInfo:nil repeats:NO];
    
    }else{
        
    }

    
    
}



NSString *chargeID;
NSString *customerID;
-(void)PostData{
    [timer2 invalidate];
    timer2 = nil;
    
    [self.delegate UploadingImages];
    
    NSArray *orderAttemptArray = @[@"charge successful",@"upload attempted"];
    [NSKeyedArchiver archiveRootObject:orderAttemptArray toFile:[self archiveOrderAttemp]];
    
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    NSString *name = [self sharedAppDelegate].userSettings.shipping.Name;
    NSString *email = [self sharedAppDelegate].userSettings.billing.email;
    NSString *street = [self sharedAppDelegate].userSettings.shipping.street;
    NSString *apt = [self sharedAppDelegate].userSettings.shipping.apt;
    NSString *city = [self sharedAppDelegate].userSettings.shipping.city;
    NSString *state = [self sharedAppDelegate].userSettings.shipping.state;
    NSString *zip = [self sharedAppDelegate].userSettings.shipping.zip;
    NSString *shippingAddress;
    if ([apt isEqualToString:@""]) {
        shippingAddress = [NSString stringWithFormat:@"%@, %@, %@ %@",street,city,state,zip];
    }
    else{
        shippingAddress = [NSString stringWithFormat:@"%@ %@, %@ %@ %@",street,apt,city,state,zip];
    }
    [self sharedAppDelegate].userSettings.shipping.shippingDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   name,@"name",
                                                                   email, @"email",
                                                                   street,@"street",
                                                                   apt,@"apt",
                                                                   city,@"city",
                                                                   state,@"state",
                                                                   zip,@"zip",
                                                                   @"US",@"country",
                                                                   shippingAddress,@"shipping_address",
                                                                   chargeID,@"stripeChargeID",
                                                                   customerID,@"customerID",nil];
    //NSLog(@"Shipping info:%@",[self sharedAppDelegate].userSettings.shipping.shippingDict);
    [mutDict setObject:[self sharedAppDelegate].userSettings.shipping.shippingDict forKey:@"customer"];
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
        NSLog(@"Product:%@",[array1 objectAtIndex:0]);
        NSString *prod = [array1 objectAtIndex:0];
        NSString *quan = [array1 objectAtIndex:1];
        NSString *retouch = [array1 objectAtIndex:3];
        NSString *alum = [array1 objectAtIndex:4];
        NSString *instructions = [array1 objectAtIndex:5];
        NSString *imgString = [array1 objectAtIndex:7];

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

    BOOL success = [comm postData:mutDict withDelegate:self];
    if (success) {
        [self sendEmail];
        [self.delegate ImagesSuccessFullyUploaded];
    }else{
        [self.delegate imageUploadFailure];
    }
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if(response)
    {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:[self archiveOrderAttemp] error:&error];
        
        [self.delegate ImagesSuccessFullyUploaded];
        
    }
    else
    {
        NSArray *orderAttemptArray = @[@"charge successful",@"upload failed"];
        [NSKeyedArchiver archiveRootObject:orderAttemptArray toFile:[self archiveOrderAttemp]];
        NSLog(@"faield to connect");
        [self.delegate imageUploadFailure];
        
    }
}

- (void)connection:(NSURLConnection *)connection  didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    float prog = (totalBytesWritten / (totalBytesExpectedToWrite * 1.0f) * 100);
    //NSLog(@"%f",prog);
    [self.delegate imageUploadPercent:prog];
}

-(void)sendEmail
{
    
    Sendpulse* sendpulse = [[Sendpulse alloc] initWithUserIdandSecret:@"8663ca13cd9f05ef1f538f8d6295ff0e" :@"1af4a885aaaa45faa3ee21e763cc5667"];
    
    NSDictionary *from = [NSDictionary dictionaryWithObjectsAndKeys:@"PrintItPhoto", @"name", @"b.stevens.photo@gmail.com", @"email", nil];
    NSMutableArray* to = [[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Alan Fraser", @"name", @"b.stevens.photo@gmail.com", @"email", nil], nil];
    //NSString *messageBody = [NSString stringWithFormat:@"test Email"];
    NSMutableDictionary *emaildata = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"html", @"Congratulations!", @"text",@"You got an order!",@"subject",from,@"from",to,@"to", nil];
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


- (NSString*)archiveOrderAttemp{
    NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = documentDirs[0];
    return [docDir stringByAppendingPathComponent:@"orderAttempt"];
}




@end
